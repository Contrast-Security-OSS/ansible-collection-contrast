# -*- mode: ruby -*-
# vi: set ft=ruby :

# ARM64/Apple Silicon compatible Vagrantfile for Contrast Security Ansible Collection
# Uses ARM64-native boxes for better performance and compatibility

VAGRANTFILE_API_VERSION = "2"

# ARM64-compatible test scenarios
TEST_SCENARIOS = {
  # Ubuntu ARM64 scenarios
  "ubuntu2004" => {
    box: "bento/ubuntu-20.04-arm64",
    memory: 1024,
    cpus: 1,
    java_package: "openjdk-11-jdk",
    service_name: "tomcat9"
  },
  "ubuntu2204" => {
    box: "bento/ubuntu-22.04-arm64", 
    memory: 1024,
    cpus: 1,
    java_package: "openjdk-11-jdk",
    service_name: "tomcat9"
  },
  "ubuntu2404" => {
    box: "bento/ubuntu-24.04-arm64",
    memory: 1024,
    cpus: 1,
    java_package: "openjdk-11-jdk", 
    service_name: "tomcat10"
  },
  
  # CentOS/RHEL ARM64 scenarios
  "centos9" => {
    box: "bento/centos-stream-9-arm64",
    memory: 1024,
    cpus: 1,
    java_package: "java-11-openjdk-devel",
    service_name: "tomcat"
  },
  "rocky9" => {
    box: "bento/rockylinux-9-arm64",
    memory: 1024,
    cpus: 1,
    java_package: "java-11-openjdk-devel",
    service_name: "tomcat"
  },
  
  # Amazon Linux ARM64 scenarios  
  "amazonlinux2" => {
    box: "bento/amazonlinux-2-arm64",
    memory: 1024,
    cpus: 1,
    java_package: "java-11-amazon-corretto-devel",
    service_name: "tomcat"
  }
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Global settings optimized for Apple Silicon
  config.vm.boot_timeout = 600
  config.vm.graceful_halt_timeout = 60
  config.vm.box_check_update = false

  # VMware provider (recommended for Apple Silicon)
  config.vm.provider "vmware_desktop" do |vmware|
    vmware.gui = false
    vmware.memory = 1024
    vmware.cpus = 1
    vmware.ssh_info_public = true
    vmware.vmx["ethernet0.virtualdev"] = "vmxnet3"
  end

  # Parallels provider (excellent Apple Silicon support)
  config.vm.provider "parallels" do |prl|
    prl.memory = 1024
    prl.cpus = 1
    prl.update_guest_tools = true
    prl.check_guest_tools = false
  end

  # VirtualBox provider (limited ARM64 support)
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 1024
    vb.cpus = 1
    
    # ARM64-specific VirtualBox settings
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--audio", "none"]
    vb.customize ["modifyvm", :id, "--uart1", "off"]
    vb.customize ["modifyvm", :id, "--uart2", "off"]
  end

  # Disable default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.ssh.forward_agent = true
  
  TEST_SCENARIOS.each do |name, settings|
    config.vm.define name do |vm|
      vm.vm.box = settings[:box]
      vm.vm.hostname = "#{name}-contrast-test"
      
      # Network configuration
      vm.vm.network "private_network", type: "dhcp"
      
      # Sync the collection for testing
      vm.vm.synced_folder ".", "/home/vagrant/contrast.security", 
        type: "rsync",
        rsync__exclude: [".git/", "*.tar.gz", ".molecule/"]
      
      # ARM64-optimized bootstrap script
      vm.vm.provision "shell", inline: <<-SHELL
        set -e
        
        echo "=== Bootstrapping #{name} (ARM64) for Contrast testing ==="
        
        # Update package manager
        if command -v apt-get >/dev/null 2>&1; then
          export DEBIAN_FRONTEND=noninteractive
          apt-get update
          apt-get install -y python3 python3-pip curl wget unzip
          
          # Install Java and Tomcat
          apt-get install -y #{settings[:java_package]}
          
          # Install Tomcat based on Ubuntu version
          if [[ "#{name}" == *"2404"* ]]; then
            apt-get install -y tomcat10 tomcat10-admin
            systemctl enable tomcat10
          else
            apt-get install -y tomcat9 tomcat9-admin
            systemctl enable tomcat9
          fi
          
        elif command -v yum >/dev/null 2>&1; then
          yum update -y
          yum install -y python3 python3-pip curl wget unzip
          yum install -y #{settings[:java_package]}
          yum install -y tomcat tomcat-webapps tomcat-admin-webapps
          systemctl enable tomcat
          
        elif command -v dnf >/dev/null 2>&1; then
          dnf update -y
          dnf install -y python3 python3-pip curl wget unzip
          dnf install -y #{settings[:java_package]}
          dnf install -y tomcat tomcat-webapps tomcat-admin-webapps
          systemctl enable tomcat
        fi
        
        # Install Ansible
        python3 -m pip install --user ansible
        
        # Create test directories
        mkdir -p /opt/tomcat/bin
        mkdir -p /var/log/contrast
        
        # Create basic setenv.sh
        if [[ ! -f /opt/tomcat/bin/setenv.sh ]]; then
          cat > /opt/tomcat/bin/setenv.sh << 'SETENV_EOF'
#!/bin/bash
# Tomcat environment configuration
export JAVA_OPTS=""
export CATALINA_OPTS=""
SETENV_EOF
          chmod +x /opt/tomcat/bin/setenv.sh
        fi
        
        # Fix permissions
        chown -R tomcat:tomcat /opt/tomcat/ 2>/dev/null || true
        chown -R tomcat:tomcat /var/log/contrast/ 2>/dev/null || true
        
        echo "=== Bootstrap complete for #{name} (ARM64) ==="
      SHELL
      
      # Ansible provisioning
      vm.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "/home/vagrant/contrast.security/tests/vagrant/setup.yml"
        ansible.inventory_path = "/home/vagrant/contrast.security/tests/vagrant/inventory"
        ansible.limit = "all"
        ansible.extra_vars = {
          service_name: settings[:service_name],
          java_package: settings[:java_package],
          test_scenario: name
        }
      end
    end
  end
  
  # Test runner VM
  config.vm.define "test-runner", primary: true do |runner|
    runner.vm.box = "bento/ubuntu-22.04-arm64"
    runner.vm.hostname = "contrast-test-runner"
    
    runner.vm.provider "vmware_desktop" do |vmware|
      vmware.memory = 512
      vmware.cpus = 1
    end
    
    runner.vm.provider "parallels" do |prl|
      prl.memory = 512
      prl.cpus = 1
    end
    
    runner.vm.provider "virtualbox" do |vb|
      vb.name = "contrast-test-runner"
      vb.memory = 512
      vb.cpus = 1
    end
    
    runner.vm.synced_folder ".", "/home/vagrant/contrast.security",
      type: "rsync",
      rsync__exclude: [".git/", "*.tar.gz", ".molecule/"]
    
    runner.vm.provision "shell", inline: <<-SHELL
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y python3 python3-pip ansible
      python3 -m pip install --user molecule pytest testinfra
      echo "ARM64 test runner ready for executing test suites"
    SHELL
  end
end
