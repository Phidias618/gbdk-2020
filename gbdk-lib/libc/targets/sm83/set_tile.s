.include "global.s"

.area _CODE

_set_vram_byte::
        WAIT_STAT_HL

        ; Write tile
        ld      (de),a
        ret

_set_win_tile_xy::
        ld      d, a
        ldh     a, (.LCDC)
        and     #LCDCF_WIN9C00
        jr      z, .is98
        jr      .is9c

_set_bkg_tile_xy::
        ld      d, a
        ldh     a, (.LCDC)
        and     #LCDCF_BG9C00
        jr      nz, .is9c
.is98:
        ld      b, #0x98
        jr      .set_tile_xy
.is9c:
        ld      b,#0x9C

.set_tile_xy:                   ; DE = XY; B = origin
        ldhl sp, #2
        ld c, (hl)
        
        ld l, d
        ld h, b
        
        ld e, a
        add a
        add a
        add a
        add a
        ld d, #0
        rl d
        ld e, a
        add hl, de
        add hl, de              ; dest hl = (BASE << 8) + 0x20 * Y + X            
        
        WAIT_STAT
        ld (hl), c

        ld b, h
        ld c, l                 ; return dest in BC 
        
        pop     hl
        inc     sp
        jp      (hl)
