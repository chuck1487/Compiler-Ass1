 
 CMP(R0,SOB_VOID);
 JUMP_EQ(_VOID);
 PUSH(R0);
 CALL(WRITE_SOB);
 _VOID:
 CALL(NEWLINE);


  DROP(1);

  STOP_MACHINE;

  return 0;
} 