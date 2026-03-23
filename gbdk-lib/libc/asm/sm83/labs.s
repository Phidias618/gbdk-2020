;--------------------------------------------------------------------------
;  labs.s
;
;  Copyright (c) 2026, Phidias618
;
;--------------------------------------------------------------------------

        .module labs

        .area   _HOME

;long labs(long num)
_labs::
        lda     HL, 2(SP)
        ld      A, (HL+)
        ld      E, A
        ld      A, (HL+)
        ld      D, A
        ld      A, (HL+)
        ld      H, (HL)
        ld      L, A            ; HLDE = num
.labs::
        bit 7, h
        ret z                   ; return if HLDE >= 0

        ; HLDE = -HLDE
        xor a
        sub e
        ld e, a
        
        sbc a
        sub d
        ld d, a

        sbc a
        sub l
        ld l, a

        sbc a
        sub h
        ld h, a

        ret 
