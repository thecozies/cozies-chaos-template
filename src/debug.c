#include "cozy_chaos.h"

RECOMP_HOOK_RETURN("Sram_OpenSave") void after_Sram_OpenSave() {
    gSaveContext.save.entrance = ENTRANCE(SOUTH_CLOCK_TOWN, 0);
    gSaveContext.save.day = 1;
    gSaveContext.save.time = CLOCK_TIME(6, 0);
    AMMO(ITEM_BOW) = 69;
    AMMO(ITEM_DEKU_STICK) = 69;
    AMMO(ITEM_DEKU_NUT) = 69;
    AMMO(ITEM_POWDER_KEG) = 69;
    AMMO(ITEM_BOMB) = 69;
    AMMO(ITEM_BOMBCHU) = 69;
}
