        .include        "global.s"

        .area   _HOME

.fill_rect_wtt::
        PUSH    HL
        LDH     A,(.LCDC)
        AND     #LCDCF_WIN9C00
        JR      Z,.is98
        JR      .is9c
        ;; Initialize background tile table with B
.fill_rect_btt::
        PUSH    HL
        LDH     A,(.LCDC)
        AND     #LCDCF_BG9C00
        JR      NZ,.is9c
.is98:
        LD      HL,#0x9800      ; HL = origin
        JR      .fill_rect
.is9c:
        LD      HL,#0x9C00      ; HL = origin

        ;; fills rectangle area with tile B at XY = DE, size WH on stack, to vram from address (HL)
.fill_rect:
        ld a, e
        ld e, d
        ld d, #0
        add hl, de
        add a
        add a
        add a
        add a
        rl d
        ld e, a
        add hl, de
        add hl, de            ; dest HL = HL + 0x20 * Y + X

        pop de                ; DE = WH
0$:
        push de               ; store WH
        push hl               ; store dest

        ; Set W tiles
1$:                             
        WAIT_STAT
        LD      (HL), B

        ; inc dest and wrap around
        inc l
        ld a, l
        and #0x1F
        jr nz, 2$
        ld a, l
        sub #0x20
        ld l, a
2$:

        dec d
        jr nz, 1$

        pop hl
        pop de

        dec e
        ret z

        ; next row and wrap around
        ld a, l
        add #0x20
        ld l, a
        jr nc, 0$

        ld a, h
        rrca
        rrca
        add #64
        rlca
        rlca
        ld h, a
        
        jr 0$
