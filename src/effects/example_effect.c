#include "cozy_chaos.h"

// Creates the two functions you typically need. Handles setting an "active" state.
COMMON_FUNCS(example_effect, example_effect, "Example Effect")

static s32 effect_timer = 0;

// The COMMON_FUNCS macro makes these functions for you, you can create this manually.
// The macro automatically handles setting your effect to active/inactive
/*
void on_example_effect_activate(struct PlayState *play) {
    recomp_printf("\"Example Effect\"" " Activated\n");
    example_effect.active = 1;
}
void on_example_effect_end(struct PlayState *play) {
    recomp_printf("\"Example Effect\"" " Deactivated\n");
    example_effect.active = 0;
}
*/

// Happens every frame that your effect is active
void on_effect_update(struct PlayState *play) {
    recomp_printf("Time: %d\n", effect_timer++);
}

CozyChaosEffect example_effect = {
    .effect = {
        .name = "Example Effect",
        .duration = 20*12, // 12 seconds (20fps * 12)
        .on_start_fun = on_example_effect_activate,
        .update_fun = on_effect_update,
        .on_end_fun = on_example_effect_end,
    },
    .disturbance = CHAOS_DISTURBANCE_VERY_LOW,
    .active = false,
    .entity = NULL,
};

// The actual effect here. Is called using the PLAYER_UPDATE_RETURN_HOOK macro with this/play args
void after_player_update_example_effect(Player* this, PlayState* play) {
    // Make sure the effect is running
    if (!example_effect.active) {
        effect_timer = 0; // Setting timer to zero
        return;
    }
    // Make sure this isn't kafei
    if (this != GET_PLAYER(play)){
        return;
    }
    // Example effect just spinning the player
    this->actor.shape.rot.y += 0x800;
    this->actor.world.rot.y += 0x800;
    this->yaw += 0x800;
}

// Adds hook for this to be invoked after Player_Update
PLAYER_UPDATE_RETURN_HOOK(example_effect, after_player_update_example_effect);
