# Contrast Security Agent Ansible Role

This is the official Ansible role for deploying and managing the Contrast Security Java agent on Linux systems. The role provides automated installation, configuration, and lifecycle management of the Contrast agent for Java applications.

## Requirements

- Ansible 2.9 or higher
- A Java application running on a supported application server (e.g., Tomcat)
- Valid Contrast Security credentials (API key, service key, user name)
- Root or sudo access on target hosts

## Role Variables

### Core Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `contrast_agent_enabled` | bool | `false` | Master toggle to enable/disable agent activation |
| `contrast_service_name` | string | `tomcat` | Name of the systemd service to inject the agent into |
| `contrast_agent_version` | string | `LATEST` | Version of agent to download (e.g., '6.19.0' or 'LATEST') |
| `contrast_agent_path` | string | `/opt/contrast/contrast.jar` | Path where the agent JAR will be placed |
| `contrast_config_method` | string | `systemd` | Method for activation: 'systemd' or 'setenv' |
| `contrast_config_source` | string | `environment` | Configuration source: 'environment' or 'yaml' |

### Configuration Variables

The `contrast_security_config` dictionary maps directly to the Contrast YAML configuration structure:

```yaml
contrast_security_config:
  api:
    url: "https://app.contrastsecurity.com/Contrast"
    api_key: "your-api-key"
    service_key: "your-service-key"
    user_name: "your-user-name"
  application:
    name: "MyApplication"
    tags: "env:production,team:backend"
  server:
    name: "prod-server-01"
    environment: "production"
  agent:
    logger:
      path: "/var/log/contrast/contrast.log"
      level: "INFO"
```

### JVM Arguments

Additional JVM arguments can be specified using:

```yaml
contrast_jvm_args:
  - "-Xmx1280m"
  - "-Ddd.trace.classes.exclude=com.contrast*"  # For DataDog compatibility
```

## Installation

### Using Ansible Galaxy

```bash
ansible-galaxy collection install contrast.security
```

### From Source

```bash
git clone https://github.com/Contrast-Security/ansible-collection-contrast.git
cd ansible-collection-contrast
ansible-galaxy collection build
ansible-galaxy collection install contrast-security-*.tar.gz
```

## Usage Examples

### Basic Usage

```yaml
---
- name: Deploy Contrast agent
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
            name: "WebApp-Production"
            tags: "env:prod,version:2.1.0"
```

### Using YAML Configuration

```yaml
---
- name: Deploy Contrast agent with YAML config
  hosts: app_servers
  become: yes
  
  roles:
    - role: contrast.security.agent
      vars:
        contrast_agent_enabled: true
        contrast_config_source: "yaml"
        contrast_security_config:
          api:
            url: "https://app.contrastsecurity.com/Contrast"
            api_key: "{{ vault_contrast_api_key }}"
            service_key: "{{ vault_contrast_service_key }}"
            user_name: "{{ vault_contrast_user_name }}"
          application:
            name: "{{ app_name }}"
          assess:
            enable: false
          protect:
            enable: true
```

### With DataDog Compatibility

```yaml
---
- name: Deploy Contrast with DataDog
  hosts: app_servers
  become: yes
  
  roles:
    - role: contrast.security.agent
      vars:
        contrast_agent_enabled: true
        contrast_jvm_args:
          - "-Ddd.trace.classes.exclude=com.contrast*"
          - "-Xmx1536m"  # Increased heap for both agents
        contrast_security_config:
          api:
            url: "{{ contrast_url }}"
            api_key: "{{ contrast_api_key }}"
            service_key: "{{ contrast_service_key }}"
            user_name: "{{ contrast_user_name }}"
```

### Deactivating the Agent

To deactivate the agent, simply set `contrast_agent_enabled` to `false` and re-run the playbook:

```yaml
---
- name: Deactivate Contrast agent
  hosts: app_servers
  become: yes
  
  roles:
    - role: contrast.security.agent
      vars:
        contrast_agent_enabled: false
        contrast_service_name: "tomcat"
```

## Configuration Methods

### systemd Method (Recommended)

The `systemd` method creates a service override file that doesn't modify vendor-supplied files:
- Creates `/etc/systemd/system/<service>.service.d/10-contrast.conf`
- Injects `JAVA_TOOL_OPTIONS` environment variable
- Clean and non-intrusive
- Survives package updates

### setenv Method

The `setenv` method modifies the application's startup script:
- Adds configuration to `/opt/<service>/bin/setenv.sh`
- Uses `CATALINA_OPTS` for Tomcat
- Direct but potentially conflicting with other tools

## Environment Variables

When using `contrast_config_source: environment`, the role converts the configuration dictionary to environment variables:

- `api.url` → `CONTRAST__API__URL`
- `application.name` → `CONTRAST__APPLICATION__NAME`
- `agent.logger.level` → `CONTRAST__AGENT__LOGGER__LEVEL`

## Resource Management

### Memory Recommendations

When running multiple agents (e.g., Contrast + DataDog):
- Increase JVM heap by ~256MB minimum
- Monitor application performance after deployment
- Start with ADR/Protect mode (lower memory usage)

### Agent Ordering

When using with DataDog, ensure Contrast is loaded first:
```yaml
contrast_jvm_args:
  - "-Ddd.trace.classes.exclude=com.contrast*"
```

## Troubleshooting

### Verify Agent Installation

Check if the agent JAR exists:
```bash
ls -la /opt/contrast/contrast.jar
```

### Check Service Configuration

For systemd method:
```bash
cat /etc/systemd/system/tomcat.service.d/10-contrast.conf
systemctl status tomcat
```

For setenv method:
```bash
grep "Contrast Security" /opt/tomcat/bin/setenv.sh
```

### View Agent Logs

Default log location:
```bash
tail -f /var/log/contrast/contrast.log
```

### Common Issues

1. **Service fails to start**: Check JVM arguments syntax and memory settings
2. **Agent not loading**: Verify file permissions and service configuration
3. **Configuration not applied**: Ensure service was restarted after changes

## License

MIT

## Author Information

This role is maintained by Contrast Security.
- Website: https://www.contrastsecurity.com
- Support: support@contrastsecurity.com
- Documentation: https://docs.contrastsecurity.com

## Contributing

Please submit issues and pull requests to:
https://github.com/Contrast-Security/ansible-collection-contrast
