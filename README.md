# template chaos pack

## Getting started

- init submodules
- change `id` and `mod_filename` in `mod.toml`, change `NRM_TARGET` to match 
- Adding effects
  - Add your effect c file to `src/effects`
    - add `#include "cozy_chaos.h"`
    - Use macro `REGISTER_CHAOS_EFFECT(<your effect>)` at the top below the header
    - create a `CozyChaosEffect <your effect>` and set the effect params plus disturbance level
    - add your effects hooks and whatnot to this file
  - in `src/effect_includes.c`
    - include your effect, e.g. `#include "effects/example_effect.c"`

## building notes

mostly like the main template except that

- uses `RecompModTool.exe` or `RecompModTool`. either have it in your `PATH` or change the makefile to use a path to the mod tool (see `RECOMP_MOD_TOOL` in makefile)
- `make copy` will try to copy the nrm after building to your mods folder. tries to auto detect the path, can be changed via `NRM_COPY_DEST` in the makefile
