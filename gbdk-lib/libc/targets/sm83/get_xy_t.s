        .include        "global.s"

        .area   _HOME

        ;; Store window tile table into (BC) at xy = DE of size WH = HL
.get_xy_wtt::
        PUSH    HL              ; Store WH
        LDH     A,(.LCDC)
        AND     #LCDCF_WIN9C00
        JR      Z,.is98
        JR      .is9c
        ;; Store background tile table into (BC) at XY = DE of size WH = HL
.get_xy_btt::
        PUSH    HL              ; Store WH
        LDH     A,(.LCDC)
        AND     #LCDCF_BG9C00
        JR      NZ,.is9c
.is98:
        LD      H,#0x98
        JR      .get_xy_tt
.is9c:
        LD      H,#0x9C
        
        ;; Store background tile table into (BC) at XY = DE, size WH on stack, from vram from address (H << 8)
.get_xy_tt::
        ld l, d
        ld a, e
        add a
        add a
        add a
        add a
        ld d, #0
        rr d
        ld e, a
        add hl, de
        add hl, de
        ld d, h
        ld e, l                 ; source de = (H << 8) + 0x20 * Y + X

        ld h, b
        ld l, c                 ; HL = destination
        
        pop bc                  ; BC = WH
0$:
        push bc                 ; store WH
        push de                 ; store source
        ; Copy W tiles
1$:                             
        WAIT_STAT
        ld a, (de)
        ld (hl+), A

        ; inc source and wrap around
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
        pop bc

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
