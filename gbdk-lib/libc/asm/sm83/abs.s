        .module abs

        .area   _HOME

; int abs(int)
_abs::
        ld b, d
        ld c, e
        bit 7, a
        ret z

        xor a
        sub c
        ld c, a

        sbc a
        sub b
        ld b, a
        ret
