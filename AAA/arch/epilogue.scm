
JUMP(L_errors_end);

L_closure_error_args_count:
  printf("INCORRECT_NUMBER_OF_ARGS. \n");
  JUMP(L_code_finish);

L_error_cannot_apply_none_closure:
  printf("CANNOT APPLY NONE CLOSURE. \n");
  JUMP(L_code_finish);
    
L_error_car_not_pair:
  printf("EXCEPION in CAR: Variable is not a pair. \n");
  JUMP(L_code_finish);
  
L_error_cdr_not_pair:
  printf("EXCEPION in CDR: Variable is not a pair. \n");
  JUMP(L_code_finish);
  
L_error_string_length_not_string:
  printf("EXCEPION in STRING-LENGTH: Variable is not a string. \n");
  JUMP(L_code_finish);
  
L_error_vector_length_not_vector:
  printf("EXCEPION in VECTOR-LENGTH: Variable is not a vector. \n");
  JUMP(L_code_finish);
  
L_error_string_ref_not_string:
  printf("EXCEPION in STRING-REF: 1st variable is not a string. \n");
  JUMP(L_code_finish);
  
L_error_string_ref_not_integer:
  printf("EXCEPION in STRING-REF: 2nd variable is not an integer. \n");
  JUMP(L_code_finish);
  
L_error_vector_ref_not_vector:
  printf("EXCEPION in VECTOR-REF: 1st variable is not a vector. \n");
  JUMP(L_code_finish);
  
L_error_vector_ref_not_integer:
  printf("EXCEPION in VECTOR-REF: 2nd variable is not an integer. \n");
  JUMP(L_code_finish);
  
L_make_vector_not_integer:
  printf("EXCEPION in MAKE-VECTOR: 1st variable is not an integer. \n");
  JUMP(L_code_finish);
  
L_division_by_zero:
  printf("EXCEPION in DIV: Can not devide by 0. \n");
  JUMP(L_code_finish);

L_char2int_not_char:
  printf("EXCEPION in char->integer: Variable is not a char. \n");
  JUMP(L_code_finish);

L_int2char_not_int:
  printf("EXCEPION in integer->char: Variable is not an integer. \n");
  JUMP(L_code_finish);
  
L_error_set_car_not_pair:
  printf("EXCEPION in SET-CAR!: Variable is not a pair. \n");
  JUMP(L_code_finish);
  
L_error_set_cdr_not_pair:
  printf("EXCEPION in SET-CDR!: Variable is not a pair. \n");
  JUMP(L_code_finish);

L_numerator_not_num:
  printf("EXCEPION in NUMERATOR: Variable is not a number. \n");
  JUMP(L_code_finish);
  
L_denominator_not_num:
  printf("EXCEPION in DENOMINATOR: Variable is not a number. \n");
  JUMP(L_code_finish);
  
L_string_set_1_not_string:
  printf("EXCEPION in STRING-SET!: 1st variable is not a string. \n");
  JUMP(L_code_finish);

L_string_set_2_not_int:
  printf("EXCEPION in STRING-SET!: 2nd variable is not an integer. \n");
  JUMP(L_code_finish);

L_string_set_3_not_char:
  printf("EXCEPION in STRING-SET!: 3rd variable is not a char. \n");
  JUMP(L_code_finish);
  
L_vector_set_1_not_vector:
  printf("EXCEPION in VECTOR-SET!: 1st variable is not a vector. \n");
  JUMP(L_code_finish);
  
L_vector_set_2_not_int:
  printf("EXCEPION in VECTOR-SET!: 2nd variable is not an integer. \n");
  JUMP(L_code_finish);
  
L_remainder_not_integer:
  printf("EXCEPION in REMAINDER: variable is not an integer. \n");
  JUMP(L_code_finish);

L_string2symbol_not_string:
  printf("EXCEPION in STRING->SYMBOL variable is not a string. \n");
  JUMP(L_code_finish);
  
L_errors_end:




L_code_finish:
  STOP_MACHINE;

  return 0;
} 
