# template chaos pack

## Getting started

- init submodules
- change `id` and `mod_filename` in `mod.toml`, change `NRM_TARGET` to match 
- Adding effects
  - Add your effect c file to `src/effects`
    - create a `CozyChaosEffect` and set the effect params plus disturbance level
    - add your effects hooks and whatnot to this file
  - in `include/cozy_chaos.h`
    - Add `ENABLE_<effect name>` define to the top
    - Add extern for your effect at the bottom
  - in `src/chaos.c`
    - add your effect to the `all_effects` array (e.g. `&example_effect,`)
  - in `src/effect_includes.c`
    - see example - there needs to be an ifdef/else with your `ENABLE_<effect name>` define from earlier
    - `MAKE_FAKE(effect)` macro should have the variable name of your effect

## building notes

mostly like the main template except that

- uses `RecompModTool.exe`. either have it in your `PATH` or change the makefile to use a path to the mod tool
- `make copy` will try to copy the nrm after building to your mods folder (only on windows tho)
