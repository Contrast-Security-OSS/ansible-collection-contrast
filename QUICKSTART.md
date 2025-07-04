# Contrast Security Ansible Collection - Quick Start Guide

## Project Structure Created

The complete Ansible Collection has been created at:
`/Users/jonathanharper/MCP/contrast.security/`

## Key Features Implemented

### 1. **Core Role Structure**
- Complete `contrast.security.agent` role with all standard Ansible directories
- Idempotent task execution for installation, configuration, and activation
- Support for both systemd (recommended) and setenv.sh activation methods

### 2. **Configuration Options**
- **Environment Variables**: Default method, converts YAML config to env vars
- **YAML File**: Optional method for traditional configuration file approach
- **Flexible Variables**: Comprehensive set of configurable parameters

### 3. **Agent Management**
- **Installation**: Downloads from Maven Central or custom repository
- **Activation**: Clean injection of -javaagent flag via systemd or setenv.sh
- **Deactivation**: Complete removal with `contrast_agent_enabled: false`

### 4. **Enterprise Features**
- Support for air-gapped environments
- DataDog compatibility configuration
- Version pinning and latest version support
- Comprehensive logging and debugging

## Quick Usage

### 1. Build the Collection
```bash
cd /Users/jonathanharper/MCP/contrast.security
ansible-galaxy collection build
```

### 2. Install Locally
```bash
ansible-galaxy collection install contrast-security-*.tar.gz
```

### 3. Basic Playbook
```yaml
---
- name: Deploy Contrast
  hosts: servers
  become: yes
  roles:
    - role: contrast.security.agent
      vars:
        contrast_agent_enabled: true
        contrast_security_config:
          api:
            url: "https://app.contrastsecurity.com/Contrast"
            api_key: "YOUR_API_KEY"
            service_key: "YOUR_SERVICE_KEY"
            user_name: "YOUR_USER_NAME"
          application:
            name: "MyApp"
```

### 4. Run Playbook
```bash
ansible-playbook -i inventory playbook.yml
```

## Testing

The collection includes Molecule tests:
```bash
cd roles/agent
molecule test
```

## Examples Provided

- `examples/deploy-contrast.yml` - Various deployment scenarios
- `examples/deactivate-contrast.yml` - Safe deactivation examples
- `examples/inventory.ini` - Sample inventory structure
- `examples/group_vars/production.yml` - Production configuration

## Next Steps

1. Review and customize the configuration for your environment
2. Update API credentials in the examples
3. Test in a development environment first
4. Consider publishing to Ansible Galaxy for wider distribution

## Support

Refer to the comprehensive documentation in:
- `/README.md` - Collection overview
- `/roles/agent/README.md` - Detailed role documentation
- `/CONTRIBUTING.md` - Contribution guidelines
