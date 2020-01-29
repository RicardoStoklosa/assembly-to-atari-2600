    processor 6502

    seg code
    org $F000       ; define code origin to $F000
Start:
    sei             ; disable interrupts
    cld             ; disable decimal mode
    ldx #$FF        ; load X with #FF
    txs             ; transfer X to stack register

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the zero page ($00 to $FF)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #0          ; A = 0
    ldx #$FF        ; X = #$FF

MemLoop:
    sta $0,X        ; store zero at $0 + X
    dex             ; x--
    bne MemLoop     ; loop until x==0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; File ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC
    .word Start     ; reset at $FFC
    .word Start
