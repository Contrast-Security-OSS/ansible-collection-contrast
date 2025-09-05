# Testing Strategy Guide

This document explains when to use each testing approach in the Contrast Security Ansible Collection.

## Testing Approaches Overview

| Approach | Purpose | Duration | Use Case |
|----------|---------|----------|-----------|
| `test-docker.sh` | Quick validation | ~2 minutes | Development, quick checks |
| `molecule test` (default) | Full x86_64 testing | ~10 minutes | CI/CD, comprehensive validation |
| `molecule test -s apple-silicon` | Full ARM64 testing | ~10 minutes | Apple Silicon comprehensive testing |

## When to Use Each Approach

### Use `test-docker.sh` when:
- ✅ **Developing on Apple Silicon Mac**
- ✅ **Quick "does it work?" validation**
- ✅ **Testing specific OS targets**
- ✅ **Local development workflow**
- ✅ **Fast feedback needed**

### Use `molecule test` (default) when:
- ✅ **Running on Intel/AMD systems**
- ✅ **CI/CD pipeline testing**
- ✅ **Comprehensive validation needed**
- ✅ **Testing multiple scenarios**
- ✅ **Before releasing changes**

### Use `molecule test -s apple-silicon` when:
- ✅ **Apple Silicon comprehensive testing**
- ✅ **Validating ARM64 compatibility**
- ✅ **Testing systemd integration on ARM64**
- ✅ **Full test suite on Apple Silicon**

## Examples

### Developer Workflow (Apple Silicon)
```bash
# Quick check during development
./test-docker.sh ubuntu2204

# Full validation before committing
molecule test -s apple-silicon
```

### CI/CD Pipeline
```bash
# x86_64 systems
molecule test

# ARM64 systems (if needed)
molecule test -s apple-silicon
```

### Manual Testing Different Targets
```bash
# Test Ubuntu 24.04 quickly
./test-docker.sh ubuntu2404

# Test Rocky Linux 9 quickly  
./test-docker.sh rocky9

# Full test with all scenarios
molecule test -s apple-silicon
```

## Performance Comparison

| Test Type | Container Startup | Test Execution | Total Time |
|-----------|------------------|----------------|------------|
| `test-docker.sh` | ~30s | ~90s | ~2 minutes |
| `molecule` | ~60s | ~8 minutes | ~10 minutes |

## Architecture Support

| Platform | test-docker.sh | molecule (default) | molecule (apple-silicon) |
|----------|----------------|-------------------|-------------------------|
| Intel/AMD Mac | ✅ | ✅ | ❌ |
| Apple Silicon | ✅ | ❌ | ✅ |
| Linux x86_64 | ✅ | ✅ | ❌ |
| Linux ARM64 | ✅ | ❌ | ✅ |

## Recommendation

For **most development work** on Apple Silicon:
1. Use `./test-docker.sh` for quick validation
2. Use `molecule test -s apple-silicon` before major commits
3. Let CI/CD handle `molecule test` on x86_64

This gives you the best of both worlds: fast feedback and comprehensive testing.
