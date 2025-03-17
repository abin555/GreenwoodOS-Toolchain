# Greenwood OS Toolchain

Needed for compilation of OS kernel, LibC, and user applications

# On clone:

You need to apply the custom patches:
```bash
make patch
```

# Steps

1. Set up the environment variables
```bash
source .env
```

2. Build
```bash
make build
```