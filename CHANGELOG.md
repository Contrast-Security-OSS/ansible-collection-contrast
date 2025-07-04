# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-07-04

### Added
- Initial release of the Contrast Security Ansible Collection
- `contrast.security.agent` role for Java agent deployment
- Support for systemd and setenv.sh activation methods
- Support for environment variable and YAML configuration
- Automatic agent version detection from Maven Central
- Idempotent installation and configuration
- Clean deactivation mechanism
- DataDog compatibility configuration
- Comprehensive documentation and examples

### Features
- Master toggle for agent enablement (`contrast_agent_enabled`)
- Flexible configuration through `contrast_security_config` dictionary
- Support for custom JVM arguments
- Automatic directory creation
- Download verification and timeout handling
- Support for air-gapped environments

### Supported Platforms
- Red Hat Enterprise Linux 7, 8, 9
- CentOS 7, 8
- Amazon Linux 2, 2023
- Ubuntu 18.04, 20.04, 22.04
- Debian 10, 11, 12

[Unreleased]: https://github.com/Contrast-Security/ansible-collection-contrast/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Contrast-Security/ansible-collection-contrast/releases/tag/v1.0.0
