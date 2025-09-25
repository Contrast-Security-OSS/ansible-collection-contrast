# Contributing to Contrast Security Ansible Collection

We welcome contributions to the Contrast Security Ansible Collection! This document provides guidelines for contributing to this project.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/ansible-collection-contrast.git
   cd ansible-collection-contrast
   ```
3. Add the upstream repository:
   ```bash
   git remote add upstream https://github.com/Contrast-Security-OSS/ansible-collection-contrast.git
   ```

## Development Setup

### Prerequisites

- Python 3.6+
- Ansible 2.9+
- Docker (for testing with Molecule)
- Molecule and ansible-lint (for testing)

### Installing Development Dependencies

```bash
pip install --user ansible molecule ansible-lint yamllint molecule-docker
```

### Building the Collection

```bash
ansible-galaxy collection build
```

### Installing Locally for Testing

```bash
ansible-galaxy collection install contrast-security-*.tar.gz --force
```

## Making Changes

### Branch Naming

Create a feature branch with a descriptive name:
- `feature/add-xyz-support`
- `bugfix/fix-systemd-handler`
- `docs/update-readme`

### Code Style

- Follow [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- Use YAML formatting (not JSON)
- Indent with 2 spaces (not tabs)
- Add comments for complex logic
- Use meaningful variable names

### Commit Messages

Follow conventional commit format:
```
type(scope): brief description

Longer explanation if needed. Wrap at 72 characters.

Fixes #123
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## Testing

### Running Tests Locally

1. Navigate to the role directory:
   ```bash
   cd roles/agent
   ```

2. Run Molecule tests:
   ```bash
   molecule test
   ```

3. Run specific test scenarios:
   ```bash
   molecule test -s systemd
   ```

### Test Requirements

- All new features must include tests
- All bug fixes should include regression tests
- Tests must pass on all supported platforms

### Linting

Run ansible-lint before submitting:
```bash
ansible-lint roles/agent/
yamllint .
```

## Submitting Changes

### Pull Request Process

1. Update your fork:
   ```bash
   git checkout main
   git pull upstream main
   git push origin main
   ```

2. Rebase your feature branch:
   ```bash
   git checkout feature/your-feature
   git rebase main
   ```

3. Push your changes:
   ```bash
   git push origin feature/your-feature
   ```

4. Create a Pull Request on GitHub

### Pull Request Guidelines

- **Title**: Clear and descriptive
- **Description**: 
  - What changes were made
  - Why were they made
  - How were they tested
  - Related issues/PRs
- **Tests**: All tests must pass
- **Documentation**: Update if needed
- **Changelog**: Add entry if applicable

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested locally
- [ ] Added/updated tests
- [ ] All tests pass

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Changelog updated
```

## Documentation

### Where to Add Documentation

- **Role README**: `/roles/agent/README.md`
- **Collection README**: `/README.md`
- **Examples**: `/examples/`
- **Inline**: YAML comments for complex tasks

### Documentation Standards

- Use clear, concise language
- Include examples for all features
- Document all variables
- Keep README files up-to-date

## Release Process

Releases are managed by maintainers:

1. Update version in `galaxy.yml`
2. Update `CHANGELOG.md`
3. Tag release: `git tag v1.0.0`
4. Build collection: `ansible-galaxy collection build`
5. Publish to Galaxy

## Getting Help

- Open an issue for bugs/features
- Join our community chat
- Email: support@contrastsecurity.com

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the community

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Public or private harassment
- Publishing private information

## Recognition

Contributors will be recognized in:
- Release notes
- Contributors file
- GitHub insights

Thank you for contributing to the Contrast Security Ansible Collection!
