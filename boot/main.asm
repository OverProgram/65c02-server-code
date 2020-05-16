	.org $8000

reset:
	lda #$ff

  .org $fffc
  .word reset
  .word $0000
