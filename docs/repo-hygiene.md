# Repository Hygiene

This repository enforces basic hygiene to keep automation deterministic and avoid dead artifacts.

## What is checked

- Python cache directories: `__pycache__/`
- Compiled/metadata files: `*.pyc`, `*.pyo`, `.DS_Store`
- Empty directories (excluding `.git`)

## Commands

```bash
# check only (non-destructive)
bash scripts/repo-hygiene.sh check

# cleanup mode (removes detected artifacts)
bash scripts/repo-hygiene.sh fix
```

`make lint` runs hygiene check automatically.

