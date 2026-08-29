# SCPSE tgstation Mirroring Guide

Use this as the local reminder for tgstation rebases and cherry-picks.

1. Keep tgstation changes as close to upstream as possible.
2. Put SCPSE additions in `modular_scpse/modules`.
3. Put necessary modular overrides in `modular_scpse/master_files` using the upstream path layout.
4. Prefer appending behavior with `..()` over copying full upstream procs.
5. If a core file must be edited, mark the changed block with `SCPSE EDIT` comments and list it in the module readme.
6. Keep binary assets in their owning module instead of editing upstream assets.

