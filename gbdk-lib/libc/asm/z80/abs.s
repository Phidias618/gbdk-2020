        .area   _CODE

        .globl _abs

_abs:
        ld a, h
        add a
        ret nc
        
        xor a
        sub l
        ld l, a
        sbc a
        sub h
        ld h, a
        
        ret
