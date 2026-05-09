        .include        "global.s"

        .title  "Set tile map"
        .module SetTileMap

        .area   _DATA

__map_tile_offset::
        .ds     0x01

        .area   _HOME

        ;; Set window tile table from BC at XY = DE of size WH = HL
.set_xy_wtt::
        PUSH    HL              ; Store WH
        LDH     A,(.LCDC)
        AND     #LCDCF_WIN9C00
        JR      Z,.is98
        JR      .is9c
        ;; Set background tile table from (BC) at XY = DE of size WH = HL
.set_xy_btt::
        PUSH    HL              ; Store WH
        LDH     A,(.LCDC)
        AND     #LCDCF_BG9C00
        JR      NZ,.is9c
.is98:
        LD      HL,#0x9800
        JR      .set_xy_tt
.is9c:
        LD      HL,#0x9C00
        ;; Set background tile from (BC) at XY = DE, size WH on stack, to vram from address (HL)
.set_xy_tt::

        ld a, d
        ld d, #0
        add hl, de
        add hl, de
        add hl, de
        add hl, de
        add hl, de
        ld e, a
        add hl, de             ; dest HL = HL + 0x20 * Y + X  

        ld d, h
        ld e, l

        ld h, b
        ld l, c
        
        pop bc                 ; BC = WH
0$:
        push bc                ; store WH
        push de                ; store dest

        ; Copy W tiles
1$:
        ld a, (__map_tile_offset)
        add (hl)
        ld c, a
        WAIT_STAT
        ld a, c
        ld (de), a
        inc hl

        ; inc dest and wrap around
        inc e
        ld a, e
        and #0x1F
        jr nz, 2$
        ld a, e
        sub #0x20
        ld e, a
2$:

        dec b
        jr nz, 1$

        pop de
        pop bc        ; bc = WH

        dec c
        ret z
        
        ; next row and wrap around
        ld a, e
        add #32 
        ld e, a
        jr nc, 0$

        ld a, d
        rrca
        rrca
        add #64
        rlca
        rlca
        ld d, a

        jr 0$
