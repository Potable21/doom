// Capa de plataforma de doomgeneric para Roblox (WASM -> Luau)
#include <stdint.h>
#include "doomgeneric.h"
#include "doomkeys.h"

#define EXPORT(n) __attribute__((export_name(n)))
#define IMPORT(n) __attribute__((import_module("env"), import_name(n)))

IMPORT("ticks_ms") extern uint32_t rb_ticks_ms(void);
IMPORT("sleep_ms") extern void rb_sleep_ms(uint32_t ms);
IMPORT("key_pop")  extern int rb_key_pop(void);   // 0 = vacio, si no: (1<<16)|(pressed<<8)|tecla

void DG_Init(void) {}
void DG_DrawFrame(void) {}                         // Luau lee DG_ScreenBuffer tras cada tick
void DG_SleepMs(uint32_t ms) { rb_sleep_ms(ms); }
uint32_t DG_GetTicksMs(void) { return rb_ticks_ms(); }
void DG_SetWindowTitle(const char *title) {}

int DG_GetKey(int *pressed, unsigned char *key) {
    int v = rb_key_pop();
    if (!v) return 0;
    *pressed = (v >> 8) & 1;
    *key = (unsigned char)(v & 255);
    return 1;
}

static char *argv_[] = { "doom", "-iwad", "doom1.wad", 0 };

EXPORT("rb_init") void rb_init(void) { doomgeneric_Create(3, argv_); }
EXPORT("rb_tick") void rb_tick(void) { doomgeneric_Tick(); }
EXPORT("rb_fb")   uint32_t rb_fb(void) { return (uint32_t)(uintptr_t)DG_ScreenBuffer; }
