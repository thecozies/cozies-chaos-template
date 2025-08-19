#include "cozy_chaos.h"

// gives a placeholder effect that doesn't do anything. This is just so you can disable effects 
#define MAKE_FAKE(effect_code_name) CozyChaosEffect ##effect_code_name = { .fake = true };

#ifdef ENABLE_EXAMPLE_EFFECT
    // Path to your effect
    #include "effects/example_effect.c"
#else
    // Make a fake effect for your effect
    MAKE_FAKE(example_effect);
#endif

// Your other effects go under here:

/*
#ifdef ENABLE_ANOTHER_EFFECT
    #include "effects/another_effect.c"
#else
    MAKE_FAKE(another_effect);
#endif
*/
