# Contrast Security Ansible Collection

Official Ansible Collection for deploying and managing Contrast Security agents.

## Description

This collection provides enterprise-grade automation for deploying the Contrast Security Java agent across your infrastructure. It supports automated installation, configuration, and lifecycle management with a focus on idempotency and operational safety.

## Included Content

### Roles

- **contrast.security.agent** - Deploy and manage the Contrast Security Java agent

## Installation

### From Ansible Galaxy

```bash
ansible-galaxy collection install contrast.security
```

### From Source

```bash
git clone https://github.com/Contrast-Security-OSS/ansible-collection-contrast.git
cd ansible-collection-contrast
ansible-galaxy collection build
ansible-galaxy collection install contrast-security-*.tar.gz
```

## Quick Start

1. Install the collection:
   ```bash
   ansible-galaxy collection install contrast.security
   ```

2. Create a playbook:
   ```yaml
   ---
   - name: Deploy Contrast Security
     hosts: app_servers
     become: yes
     
     roles:
       - role: contrast.security.agent
         vars:
           contrast_agent_enabled: true
           contrast_service_name: "tomcat"
           contrast_security_config:
             api:
               url: "https://app.contrastsecurity.com/Contrast"
               api_key: "{{ vault_contrast_api_key }}"
               service_key: "{{ vault_contrast_service_key }}"
               user_name: "{{ vault_contrast_user_name }}"
             application:
               name: "MyApp"
   ```

3. Run the playbook:
   ```bash
   ansible-playbook -i inventory contrast-deploy.yml
   ```

## Requirements

- Ansible 2.9+
- Python 3.6+
- Root or sudo access on target hosts

## Supported Platforms

- Red Hat Enterprise Linux 7, 8, 9
- CentOS 7, 8
- Amazon Linux 2, 2023
- Ubuntu 18.04, 20.04, 22.04
- Debian 10, 11, 12

## Features

- **Idempotent Operations**: Safe to run multiple times
- **Flexible Configuration**: Support for environment variables and YAML files
- **Multiple Activation Methods**: systemd (recommended) and setenv.sh
- **Clean Deactivation**: Easy agent removal without residual configuration
- **Version Management**: Support for specific versions or latest
- **Enterprise Ready**: Support for air-gapped environments and custom repositories

## Documentation

For detailed documentation on the agent role, see:
- [Agent Role Documentation](roles/agent/README.md)
- [Contrast Documentation](https://docs.contrastsecurity.com)

## Examples

### Deploy to Multiple Environments

```yaml
---
# group_vars/production.yml
contrast_agent_enabled: true
contrast_security_config:
  server:
    environment: "production"
  assess:
    enable: false
  protect:
    enable: true

# group_vars/staging.yml
contrast_agent_enabled: true
contrast_security_config:
  server:
    environment: "qa"
  assess:
    enable: true
  protect:
    enable: false
```

### Using with Ansible Vault

```yaml
---
- name: Secure Contrast Deployment
  hosts: app_servers
  become: yes
  
  vars_files:
    - vault/contrast_credentials.yml
  
  roles:
    - role: contrast.security.agent
      vars:
        contrast_agent_enabled: true
        contrast_security_config:
          api:
            url: "{{ vault_contrast_url }}"
            api_key: "{{ vault_contrast_api_key }}"
            service_key: "{{ vault_contrast_service_key }}"
            user_name: "{{ vault_contrast_user_name }}"
```

## Testing

This collection includes Molecule tests for verification:

```bash
cd roles/agent
molecule test
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

- Documentation: https://docs.contrastsecurity.com
- Support Portal: https://support.contrastsecurity.com
- Email: support@contrastsecurity.com

## License

MIT - See [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Roadmap

- [ ] Support for .NET Core agent
- [ ] Support for Node.js agent
- [ ] Support for Python agent
- [ ] Kubernetes operator integration
- [ ] Enhanced monitoring and metrics collection

## Author

**Contrast Security**
- Website: https://www.contrastsecurity.com
- GitHub: https://github.com/Contrast-Security-OSS
