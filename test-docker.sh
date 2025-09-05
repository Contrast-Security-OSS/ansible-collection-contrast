#!/bin/bash

# Docker-based testing for Apple Silicon Macs
# Uses native ARM64 containers for fast, reliable testing

set -euo pipefail

log() {
    echo "[$(date '+%H:%M:%S')] $*"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        log "ERROR: Docker not found. Please install Docker Desktop."
        log "INFO: Download from: https://www.docker.com/products/docker-desktop/"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log "ERROR: Docker daemon not running. Please start Docker Desktop."
        exit 1
    fi
    
    log "SUCCESS: Docker is ready"
}

test_contrast_agent() {
    local os_target=${1:-ubuntu2204}
    
    # ARM64-compatible images
    local image
    case $os_target in
        ubuntu2004) image="ubuntu:20.04" ;;
        ubuntu2204) image="ubuntu:22.04" ;;
        ubuntu2404) image="ubuntu:24.04" ;;
        centos9) image="quay.io/centos/centos:stream9" ;;
        rocky9) image="rockylinux:9" ;;
        *) image="ubuntu:22.04" ;;
    esac
    
    log "Running Contrast agent test in $image container (ARM64)"
    
    # Create test playbook for container
    cat > container_test.yml << 'EOF'
---
- name: Test Contrast Agent in Container
  hosts: localhost
  connection: local
  become: true
  vars:
    contrast_agent_enabled: true
    contrast_agent_version: "6.19.0"
    contrast_config_method: "environment"  # Use environment instead of systemd
    contrast_test_mode: true
    contrast_security_config:
      api:
        url: "https://app.contrastsecurity.com/Contrast"
        api_key: "container-test-key"
        service_key: "container-test-service"
        user_name: "container-test-user"
      application:
        name: "ContainerTest"
        
  tasks:
    - name: Include contrast agent role
      include_role:
        name: agent
        
    - name: Verify agent installation
      stat:
        path: /opt/contrast/contrast.jar
      register: agent_check
      
    - name: Show test result
      debug:
        msg: "✅ Container test {{ 'PASSED' if agent_check.stat.exists else 'FAILED' }}"
EOF
    
    # Run test in container (simplified, no systemd)
    docker run --rm \
        --name "contrast-test-$os_target" \
        --platform linux/arm64 \
        -v "$PWD:/workspace" \
        -w /workspace \
        "$image" \
        bash -c "
            set -e
            
            # Install prerequisites based on OS
            if command -v apt-get >/dev/null 2>&1; then
                export DEBIAN_FRONTEND=noninteractive
                apt-get update
                
                # Check Ubuntu version to handle PEP 668 (externally-managed-environment)
                if grep -q 'Ubuntu 24\.' /etc/os-release 2>/dev/null; then
                    echo '[INFO] Ubuntu 24.04+ detected - using virtual environment for Ansible'
                    # Ubuntu 24.04+ - use system packages and virtual environment
                    apt-get install -y python3 python3-pip python3-venv python3-full openjdk-11-jdk curl wget sudo
                    
                    # Create and use virtual environment for Ansible
                    echo '[INFO] Creating Python virtual environment...'
                    python3 -m venv /opt/ansible-venv
                    echo '[INFO] Installing Ansible in virtual environment...'
                    /opt/ansible-venv/bin/pip install ansible
                    # Make ansible commands available
                    ln -sf /opt/ansible-venv/bin/ansible-playbook /usr/local/bin/ansible-playbook
                    ln -sf /opt/ansible-venv/bin/ansible /usr/local/bin/ansible
                    echo '[INFO] Ansible installation completed'
                else
                    echo '[INFO] Older Ubuntu version detected - installing Ansible directly'
                    # Older Ubuntu versions - can install directly
                    apt-get install -y python3 python3-pip openjdk-11-jdk curl wget sudo
                    python3 -m pip install ansible
                fi
            elif command -v dnf >/dev/null 2>&1; then
                echo '[INFO] Red Hat family OS detected'
                # Use --allowerasing to handle curl conflicts in Rocky/RHEL systems
                dnf install -y --allowerasing python3 python3-pip java-11-openjdk-devel curl wget sudo
                python3 -m pip install ansible
            fi
            
            echo '[INFO] Verifying Ansible installation...'
            ansible --version
            
            # Run the test
            ansible-playbook container_test.yml
        "
    
    log "SUCCESS: Container test completed"
}

main() {
    check_docker
    test_contrast_agent "$@"
}

main "$@"
