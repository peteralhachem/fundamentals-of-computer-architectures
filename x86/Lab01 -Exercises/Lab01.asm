.model small

.stack 

.data

buffer db 51 
prompt db "Enter a string (max 50 characters): $"
newline db 0Dh, 0Ah, "$" 

first_line DB 51 DUP (?)
second_line DB 51 DUP (?)
third_line DB 51 DUP (?)

occurence_array_1 DB 53 DUP (0)
occurence_array_2 DB 53 DUP (0) 
occurence_array_3 DB 53 DUP (0) 

max_1 DB ? 
max_2 DB ?
max_3 DB ?


.code
.startup 
  

XOR AX,AX
XOR BX,BX
XOR CX,CX
XOR DX,DX
XOR SI,SI
XOR DI,DI
XOR SP,SP     


get_string:MOV AH, 06h
           MOV AL, 0
           int 10h  
           MOV DX,offset prompt
           MOV AH,9h
           int 21h   
           MOV DX,offset buffer          
           MOV AH,0Ah 
           int 21h


MOV BL,buffer[1] ; Check the length of characters.
PUSH BX ; Keep track of the length of all the strings.
CMP BL,50d
JE  write_line
CMP BL,20d
JNAE  write_line
JAE conditional_write_line

                        
conditional_write_line: INC BP
                        CMP BP, 1 
                        JE  conditional_write_line_1
                        CMP BP, 2
                        JE conditional_write_line_2
                        CMP BP, 3 
                        JE conditional_write_line_3
                        
                        
conditional_write_line_1: MOV CL, buffer[SI+2]
                          CMP CL, 13
                          JE  clear_indices_for_conditional_write_line
                          MOV first_line[DI], CL
                          INC SI
                          INC DI
                          CMP SI,BX
                          JNE conditional_write_line_1
                          JE clear_indices_for_conditional_write_line
                          
                          
conditional_write_line_2: MOV CL, buffer[SI+2]
                          CMP CL, 13
                          JE  clear_indices_for_conditional_write_line
                          MOV second_line[DI], CL
                          INC SI
                          INC DI
                          CMP SI,BX
                          JNE conditional_write_line_2
                          JE clear_indices_for_conditional_write_line
                          

conditional_write_line_3: MOV CL, buffer[SI+2]
                          CMP CL, 13
                          JE  end_process
                          MOV third_line[DI], CL
                          INC SI
                          INC DI
                          CMP SI,BX
                          JNE conditional_write_line_3
                          JE  clear_indices_for_conditional_write_line                          
                          

write_line:INC CH    
           CMP CH, 1
           JE write_line_1
           CMP CH, 2
           JE write_line_2
           CMP CH, 3
           JE write_line_3
            



write_line_1: MOV CL, buffer[SI+2]
              MOV first_line[DI], CL
              INC SI
              INC DI
              CMP SI,BX
              JNE write_line_1
              JE  clear_indices_for_write_line


write_line_2: MOV CL, buffer[SI+2]
              MOV second_line[DI], CL
              INC SI
              INC DI
              CMP SI,BX
              JNE write_line_2
              JE  clear_indices_for_write_line


write_line_3: MOV CL, buffer[SI+2]
              MOV third_line[DI], CL
              INC SI
              INC DI
              CMP SI,BX
              JNE write_line_3
              JE  clear_indices_for_write_line
            


                      
                      
clear_indices_for_write_line: INC BP 
                              XOR SI,SI
                              XOR CL,CL 
                              XOR DI,DI
                              CMP CH, 3 
                              JE  clear_indices
                              CMP BP, 3
                              JE  clear_indices
                              JMP get_string


clear_indices_for_conditional_write_line: INC CH 
                                          XOR SI,SI
                                          XOR CL,CL 
                                          XOR DI,DI
                                          CMP CH, 3 
                                          JE  clear_indices
                                          CMP BP, 3
                                          JE  clear_indices
                                          JMP get_string
                                          
                                          
                                          
                                          
                                          
     
 
                    
clear_indices: XOR CH,CH
               XOR BP,BP
               POP BX                     

                    
                    
                    
find_occurence:INC BP
               CMP BP,1
               JE occurence_3
               CMP BP,2 
               JE occurence_2
               CMP BP,3
               JE occurence_1 
               

               
; Take each line after it was written in its respective variable.
; Move each letter to a variable. 
; Check if this variable is upper or lower case. 
; if lower case: substract 61 to get an index,increase occurence and move the value to the index. 
; if upper case: substract 41 and add 26 to get an index, increase occurence and move the value to the index.
                            

occurence_3:MOV CL, third_line[DI]
            MOV SI, CX 
            CMP SI, 5Ah 
            JNBE lower_case_3 
            JBE upper_case_3

lower_case_3:SUB SI,61h
             INC occurence_array_3[SI]
             INC DI
             CMP DI,BX
             JNE occurence_3
             JE  clear_indices_for_occurence
             
             
             

upper_case_3:SUB SI,41h
             ADD SI,26
             INC occurence_array_3[SI]
             INC DI
             CMP DI,BX
             JNE occurence_3
             JE  clear_indices_for_occurence
             
; TODO: Add occurence             

occurence_2:MOV CL, second_line[DI]
            MOV SI, CX 
            CMP SI, 5Ah 
            JNBE lower_case_2 
            JBE upper_case_2
            


lower_case_2:SUB SI,61h
             INC occurence_array_2[SI]
             INC DI
             CMP DI,BX
             JNE occurence_2
             JE  clear_indices_for_occurence
             
             
             

upper_case_2:SUB SI,41h
             ADD SI,26
             INC occurence_array_2[SI]
             INC DI
             CMP DI,BX
             JNE occurence_2
             JE  clear_indices_for_occurence



occurence_1:MOV CL, first_line[DI]
            MOV SI, CX 
            CMP SI, 5Ah 
            JNBE lower_case_1 
            JBE upper_case_1
            


lower_case_1:SUB SI,61h
             INC occurence_array_1[SI]
             INC DI
             CMP DI,BX
             JNE occurence_1
             JE  clear_indices_for_occurence
             
             
             

upper_case_1:SUB SI,41h
             ADD SI,26
             INC occurence_array_1[SI]
             INC DI
             CMP DI,BX
             JNE occurence_1
             JE  clear_indices_for_occurence
 
             


             
             
          
  
             
                               
                    
                    
clear_indices_for_occurence:XOR SI,SI  
                            XOR DI,DI
                            XOR CL,CL
                            POP BX
                            CMP BP, 3
                            JNE find_occurence
                            JE  clear_index
                            
                            
clear_index: XOR BP,BP 
             XOR BX,BX
 

find_max:INC BP
         CMP BP,1
         JE  find_max_1
         CMP BP,2
         JE  find_max_2 
         CMP BP,3
         JE  find_max_3 
         
         

find_max_1: 



find_max_2: 



find_max_3: 
         
                             
                    
                    
                    
                    
                    
                      

end_process:

.exit
End 
