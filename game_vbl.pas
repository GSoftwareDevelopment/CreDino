procedure VBL_Game_Screen; Interrupt;
begin
  asm
    xitvbl      = $e462
    sysvbv      = $e45c
    portb       = $d301
    atract      = 77

      phr

;      lda #<MAIN.DLI_GAME_SCREEN.START
;      ldx #>MAIN.DLI_GAME_SCREEN.START
;      sta VDSLST
;      stx VDSLST+1

      lda #0
      sta atract

      ldx #9
  tmLoop:
      lda adr.timer,x
      beq tmNext
      dec adr.timer,x
  tmNext:
      dex
      bpl tmLoop
  end;
{
  asm
    lda timeTick
    beq skip
    sed
    clc
    lda gameTime
    adc #2
    sta gameTime
    lda gameTime+1
    adc #0
    sta gameTime+1
    cld
  skip:
  end;
  updateGameTime;
}
if gameState<3 then
begin
  putDino;
  putSTONE;
end;

//  HIT:=peek($d004) or peek($d000);
//  poke($d01e,0);


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