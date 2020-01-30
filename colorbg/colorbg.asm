    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000          ; def origin of ROM

START:
    CLEAN_START        ; Macro to clean memmory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set background to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #$4B           ; Load color into A (NTSC RED)
    sta COLUBK         ; Store A to background color ($09)

    jmp START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill Rom size to exacly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC
    .word START
    .word START
