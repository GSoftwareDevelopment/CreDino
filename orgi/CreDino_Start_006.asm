/***************************************/
/*  Use MADS http://mads.atari8.info/  */
/*  Mode: DLI (char mode)              */
/***************************************/

	icl "CreDino_Start_006.h"

	org $f0

fcnt	.ds 2
fadr	.ds 2
fhlp	.ds 2
cloc	.ds 1
regA	.ds 1
regX	.ds 1
regY	.ds 1

WIDTH	= 40
HEIGHT	= 30

; ---	BASIC switch OFF
	org $2000\ mva #$ff portb\ rts\ ini $2000

; ---	MAIN PROGRAM
	org $2000
ant	dta $44,a(scr)
	dta $04,$84,$04,$04,$04,$04,$04,$04,$04,$84,$84,$84,$04,$84,$84,$04
	dta $84,$84,$84,$04,$04,$84,$84,$84,$84,$84,$04,$04,$04
	dta $41,a(ant)

scr	ins "CreDino_Start_006.scr"

	.ds 0*40

	.ALIGN $0400
fnt	ins "CreDino_Start_006.fnt"

	ift USESPRITES
	.ALIGN $0800
pmg	.ds $0300
	ift FADECHR = 0
	SPRITES
	els
	.ds $500
	eif
	eif

main
; ---	init PMG

	ift USESPRITES
	mva >pmg pmbase		;missiles and players data address
	mva #$03 pmcntl		;enable players and missiles
	eif

	lda:cmp:req $14		;wait 1 frame

	sei			;stop IRQ interrupts
	mva #$00 nmien		;stop NMI interrupts
	sta dmactl
	mva #$fe portb		;switch off ROM to get 16k more ram

	mwa #NMI $fffa		;new NMI handler

	mva #$c0 nmien		;switch on NMI+DLI again

	ift CHANGES		;if label CHANGES defined

_lp	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	bne _lp			;wait to press any key; here you can put any own routine

	els

null	jmp DLI.dli1		;CPU is busy here, so no more routines allowed

	eif


stop
	.ifdef FADE_CHARS\ lda #0\ jsr fade_chars\ eif

	mva #$00 pmcntl		;PMG disabled
	tax
	sta:rne hposp0,x+

	mva #$ff portb		;ROM switch on
	mva #$40 nmien		;only NMI interrupts, DLI disabled
	cli			;IRQ enabled

	rts			;return to ... DOS

; ---	DLI PROGRAM

.local	DLI

	?old_dli = *

	ift !CHANGES

dli1	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl
	and #$04
	beq stop

	lda vcount
	cmp #$02
	bne dli1

	:3 sta wsync

	DLINEW dli12

	eif

dli_start

dli12
	sta regA
	stx regX

c5	lda #$1E
c6	ldx #$14
	sta wsync		;line=24
	sta color0
	stx color2
	DLINEW dli13 1 1 0

dli13
	sta regA

c7	lda #$20
	sta wsync		;line=88
	sta color2
	DLINEW dli14 1 0 0

dli14
	sta regA

c8	lda #$14
	sta wsync		;line=96
	sta color2
	DLINEW DLI.dli2 1 0 0

dli2
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=104
	sta chbase
	DLINEW dli3 1 0 0

dli3
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=120
	sta chbase
	DLINEW dli4 1 0 0

dli4
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=128
	sta chbase
	DLINEW dli5 1 0 0

dli5
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=144
	sta chbase
	DLINEW dli15 1 0 0

dli15
	sta regA
	stx regX
	sty regY

c9	lda #$14
c10	ldx #$08
c11	ldy #$0E
	sta wsync		;line=152
	sta color0
	stx color1
	sty color2
	DLINEW dli6 1 1 1

dli6
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=160
	sta chbase
	DLINEW dli7 1 0 0

dli7
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=184
	sta chbase
	DLINEW dli16 1 0 0

dli16
	sta regA
	stx regX
	sty regY

c12	lda #$16
c13	ldx #$CA
c14	ldy #$1E
	sta wsync		;line=192
	sta color0
	stx color1
	sty color2
	DLINEW dli8 1 1 1

dli8
	sta regA
	lda >fnt+$400*$01
	sta wsync		;line=200
	sta chbase
	DLINEW dli9 1 0 0

dli9
	sta regA
	lda >fnt+$400*$00
	sta wsync		;line=208
	sta chbase
	DLINEW dli17 1 0 0

dli17
	sta regA
	stx regX

c15	lda #$14
c16	ldx #$16
	sta wsync		;line=216
	sta color0
	stx color1

	lda regA
	ldx regX
	rti

.endl

; ---

CHANGES = 1
FADECHR	= 0

SCHR	= 127

; ---

.proc	NMI

	bit nmist
	bpl VBL

	jmp DLI.dli_start
dliv	equ *-2

VBL
	sta regA
	stx regX
	sty regY

	sta nmist		;reset NMI flag

	mwa #ant dlptr		;ANTIC address program

	mva #@dmactl(standard|dma|lineX1|players|missiles) dmactl	;set new screen width

	inc cloc		;little timer

; Initial values

	lda >fnt+$400*$00
	sta chbase
c0	lda #$00
	sta colbak
c1	lda #$14
	sta color0
c2	lda #$16
	sta color1
c3	lda #$1E
	sta color2
c4	lda #$0E
	sta color3
	lda #$02
	sta chrctl
	lda #$08
	sta gtictl
x0	lda #$00
	sta hposp0
	sta hposp1
	sta hposp2
	sta hposp3
	sta hposm0
	sta hposm1
	sta hposm2
	sta hposm3
	sta sizep0
	sta sizep1
	sta sizep2
	sta sizep3
	sta sizem
	sta colpm0
	sta colpm1
	sta colpm2
	sta colpm3

	mwa #DLI.dli_start dliv	;set the first address of DLI interrupt

;this area is for yours routines

quit
	lda regA
	ldx regX
	ldy regY
	rti

.endp

; ---
	run main
; ---

	opt l-

.MACRO	SPRITES
missiles
	.ds $100
player0
	.ds $100
player1
	.ds $100
player2
	.ds $100
player3
	.ds $100
.ENDM

USESPRITES = 0

.MACRO	DLINEW
	mva <:1 NMI.dliv
	ift [>?old_dli]<>[>:1]
	mva >:1 NMI.dliv+1
	eif

	ift :2
	lda regA
	eif

	ift :3
	ldx regX
	eif

	ift :4
	ldy regY
	eif

	rti

	.def ?old_dli = *
.ENDM

