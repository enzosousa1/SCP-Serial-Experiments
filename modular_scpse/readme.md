# SCPSE Modularization Handbook

This folder contains downstream SCPSE content for a tgstation-based codebase.

Keep new content in `modular_scpse/modules/<module_id>/` with this layout:

- `code/` for DM files.
- `icons/` for DMI assets owned by the module.
- `sound/` for audio assets owned by the module.
- `strings/` for data text files owned by the module.
- `readme.md` documenting the module.

Use `modular_scpse/master_files/` only for modular overrides that intentionally mirror a tgstation file path or for special shared files that need early compile ordering, such as defines.

Do not copy tgstation's `code/modules/...` structure inside a module unless there is a specific maintenance reason. Prefer small, domain-named modules and paths that point to the owning module, for example:

```dm
icon = 'modular_scpse/modules/scps/icons/scp-173.dmi'
fire_sound = 'modular_scpse/modules/scp_weapons/sound/p90/p90_fire.ogg'
```

When changing core tgstation files directly, mark the changed block with `SCPSE EDIT` comments and document the file in the relevant module readme.

