    processor 6502

    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start unitialize segment at $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    seg.u var
    org $80
P0Height ds 1
P1Height ds 1


    seg code
    org $F000          ; def origin of ROM

START:
    CLEAN_START        ; Macro to clean memmory

    lda #$0C
    sta COLUBK

    lda #$32
    sta COLUPF

    lda #$48
    sta COLUP0

    lda #$C6
    sta COLUP1

    ldy #%00000010
    sty CTRLPF

    lda #10
    sta P0Height
    sta P1Height
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Turn on VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextFrame:
    lda #02
    sta VBLANK        ; turn on VBLANK
    sta VSYNC         ; turn on VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Create 3 lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    REPEAT 3
        sta WSYNC
    REPEND

    lda #0
    sta VSYNC        ; turn off VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 37 scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    REPEAT 37
        sta WSYNC        ; wait for the next scanline
    REPEND

    lda #0
    sta VBLANK       ; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Config Playfield
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;ldx #%00000001   ; Reflected playfield
    ;stx CTRLPF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 192 scanlines (kernel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VisibleScanLines:
    REPEAT 10
        sta WSYNC
    REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Score Board
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldy #0
ScoreLoop:
    lda NumberBitmap,Y
    sta PF1
    sta WSYNC
    iny
    cpy #10
    bne ScoreLoop

    lda #0
    sta PF1

    REPEAT 50
        sta WSYNC
    REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Players
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldy #0
Player0Loop:
    lda PlayerBitmap,Y
    sta GRP0
    sta WSYNC
    iny
    cpy P0Height
    bne Player0Loop

    lda #0
    sta GRP0

    ldy #0
Player1Loop:
    lda PlayerBitmap,Y
    sta GRP1
    sta WSYNC
    iny
    cpy P1Height
    bne Player1Loop

    lda #0
    sta GRP1


    REPEAT 102
        sta WSYNC
    REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 37 more of scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    REPEAT 30
        sta WSYNC
    REPEND

    jmp NextFrame

    org $FFE8
PlayerBitmap:
    .byte #%01111110   ;  ######
    .byte #%11111111   ; ########
    .byte #%10011001   ; #  ##  #
    .byte #%11111111   ; ########
    .byte #%11111111   ; ########
    .byte #%11111111   ; ########
    .byte #%10111101   ; # #### #
    .byte #%11000011   ; ##    ##
    .byte #%11111111   ; ########
    .byte #%01111110   ;  ######

    org $FFF2
NumberBitmap:
    .byte #%00001110   ; ########
    .byte #%00001110   ; ########
    .byte #%00000010   ;      ###
    .byte #%00000010   ;      ###
    .byte #%00001110   ; ########
    .byte #%00001110   ; ########
    .byte #%00001000   ; ###
    .byte #%00001000   ; ###
    .byte #%00001110   ; ########
    .byte #%00001110   ; ########

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill Rom size to exacly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC
    .word START
    .word START
