procedure wait4screen; assembler;
asm
  lda $d40b
  bne *-3
  lda $d40b
  beq *-3
end;