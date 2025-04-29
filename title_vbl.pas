procedure VBL_Title_Screen; Interrupt;
begin
  asm
    xitvbl      = $e462
    sysvbv      = $e45c
    portb       = $d301
    atract      = 77

      phr

      lda #0
      sta atract

      ldx #6
  tmLoop:
      lda adr.timer,x
      beq tmNext
      dec adr.timer,x
  tmNext:
      dex
      bpl tmLoop
  end;

  asm
    dec PORTB
  end;
  msx.play();
  asm
    inc PORTB
  end;

  asm
      plr
      jmp xitvbl
  end;
end;