.model small

.stack 

.data

buffer db 51 
prompt db "Enter a string (max 50 characters): $"


first_line DB 51 DUP (?)
second_line DB 51 DUP (?)
third_line DB 51 DUP (?)
fourth_line DB 51 DUP (?)

ciphered_first_line DB 51 DUP (?)
ciphered_second_line DB 51 DUP (?)
ciphered_third_line DB 51 DUP (?)
ciphered_fourth_line DB 51 DUP (?)



.code
.startup

XOR AX,AX
XOR BX,BX
XOR CX,CX
XOR DX,DX
XOR SI,SI
XOR DI,DI
XOR SP,SP

get_string:MOV DX,offset prompt
           MOV AH,9h
           int 21h   
           MOV DX,offset buffer          
           MOV AH,0Ah 
           int 21h

           


MOV BL,buffer[1] ; Check the length of characters.
PUSH BX ; Keep track of the length of all the strings (Needed for when the occurence is computed) 
CMP BL,50d
JE  write_line  ; The jump is made when you don't care about the enter condition meaning you don't have a string between 20 or 50 characters.
CMP BL,20d
JNAE  write_line
JAE conditional_write_line  ; Check where the enter character comes in the string.

                        
conditional_write_line: INC BP
                        CMP BP, 1 
                        JE  conditional_write_line_1
                        CMP BP, 2
                        JE conditional_write_line_2
                        CMP BP, 3 
                        JE conditional_write_line_3 
                        CMP BP, 4
                        JE conditional_write_line_4
                        
                        
conditional_write_line_1: MOV CL, buffer[SI+2]
                          CMP CL, 13          ; the enter character is represented by the 13 in ascii code.
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
                          JE  clear_indices_for_conditional_write_line
                          MOV third_line[DI], CL
                          INC SI
                          INC DI
                          CMP SI,BX
                          JNE conditional_write_line_3
                          JE  clear_indices_for_conditional_write_line
                          

conditional_write_line_4:MOV CL, buffer[SI+2]
                         CMP CL, 13
                         JE  clear_indices_for_conditional_write_line
                         MOV fourth_line[DI], CL
                         INC SI
                         INC DI
                         CMP SI,BX
                         JNE conditional_write_line_4
                         JE  clear_indices_for_conditional_write_line                           
                          

write_line:INC CH    
           CMP CH, 1
           JE write_line_1
           CMP CH, 2
           JE write_line_2
           CMP CH, 3
           JE write_line_3
           CMP CH, 4
           JE write_line_4
            



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
              

write_line_4: MOV CL, buffer[SI+2]
              MOV fourth_line[DI], CL
              INC SI
              INC DI
              CMP SI,BX
              JNE write_line_4
              JE  clear_indices_for_write_line
            


                      
                      
clear_indices_for_write_line: INC BP 
                              XOR SI,SI
                              XOR CL,CL 
                              XOR DI,DI
                              CMP CH, 4 
                              JE  clear_indices
                              CMP BP, 4
                              JE  clear_indices
                              JMP get_string


clear_indices_for_conditional_write_line: INC CH 
                                          XOR SI,SI
                                          XOR CL,CL 
                                          XOR DI,DI
                                          CMP CH, 4 
                                          JE  clear_indices
                                          CMP BP, 4
                                          JE  clear_indices
                                          JMP get_string
                                          
                                          
                                                                                    
                                          
     
 
                    
clear_indices: XOR CH,CH
               XOR BP,BP
               POP BX ; I used the stack to keep track of the lengths of all the strings 


; ----This section performs the caesar cipher of the strings taken as an input ----

; ---- Iteratively cipher each string one after the other, I am starting with the last string inputed ----




; ---- Overview on how the ciphering algorithm was implemented: I check each letter if it is a lower case, 
; ---- alphabet or an upper case or just a random symbol ----
; ----- If random symbol: put it directly in the ciphered text as it is not relevant to ciphering --- 
; ----- If lower case letter: check if the index of the letter in the string is even or odd --- 
; ------If even: it stays lower case, if odd it needs to become uppercase ----
; ----- If upper case letter: check if the index of the letter in the string is even or odd ---
; ----- If even: it becomes a lower case letter, if odd it stays upper case ----
; ------ There is an honorable mention to the letter 'z' which needs to be cycled with the letters ---
; ------ and thus I cannot directly add the cipher to the letter z before cycling to the corresponding letter----

               

perform_cipher:INC BP
               CMP BP,1 
               JE find_cipher_4 
               CMP BP,2
               JE find_cipher_3
               CMP BP,3 
               JE find_cipher_2 
               CMP BP,4
               JE find_cipher_1
               
               

find_cipher_4:MOV CL, fourth_line[SI]
              CMP CL, 61h
              JAE check_lower_4
              JB  check_upper_4
              
check_lower_4:CMP CL,7Ah
              JA  continue_4
              JBE cipher_lower_4
              

check_upper_4:CMP CL,41h
              JB  continue_4
              JAE check_boundary_4
              
check_boundary_4: CMP CL,5Ah
                  JBE cipher_upper_4
                  JA continue_4


                  

cipher_lower_4:test SI, 1
               JZ lower_even_4
               JNZ lower_odd_4
               

lower_even_4:CMP CL,7Ah
             JE  handle_lower_even_z_4
             ADD CL,4d
             MOV ciphered_fourth_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_4
             JE clear_indices_for_cipher 
            
                              

lower_odd_4:CMP CL,7Ah
            JE  handle_lower_odd_z_4
            ADD CL,4d
            SUB CL,20h
            MOV ciphered_fourth_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_4
            JE clear_indices_for_cipher
            
             



cipher_upper_4:test SI, 1
               JZ upper_even_4
               JNZ upper_odd_4
               
upper_even_4:CMP CL,5Ah
             JE  handle_upper_even_z_4
             ADD CL,4d 
             ADD CL,20h
             MOV ciphered_fourth_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_4
             JE clear_indices_for_cipher 


upper_odd_4:CMP CL,5Ah
            JE  handle_upper_odd_z_4
            ADD CL,4d
            MOV ciphered_fourth_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_4
            JE clear_indices_for_cipher
            
            

handle_lower_even_z_4:SUB CL,26d
                      ADD CL,4d
                      MOV ciphered_fourth_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_4
                      JE clear_indices_for_cipher
                
                
                
handle_lower_odd_z_4: SUB CL,26d
                      ADD CL,4d
                      SUB CL,20h
                      MOV ciphered_fourth_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_4
                      JE clear_indices_for_cipher
                      
                      

handle_upper_even_z_4:SUB CL,26d
                      ADD CL,4d
                      ADD CL,20h
                      MOV ciphered_fourth_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_4
                      JE clear_indices_for_cipher
                      
                      
handle_upper_odd_z_4:SUB CL,26d
                     ADD CL,4d
                     MOV ciphered_fourth_line[SI], CL
                     INC SI
                     CMP SI,BX
                     JNE find_cipher_4
                     JE clear_indices_for_cipher  
                 
                 
continue_4:MOV ciphered_fourth_line[SI], CL
           INC SI
           CMP SI,BX 
           JNE find_cipher_4
           JE clear_indices_for_cipher
           
           
find_cipher_3:MOV CL, third_line[SI]
              CMP CL, 61h
              JAE check_lower_3
              JB  check_upper_3
              
check_lower_3:CMP CL,7Ah
              JA  continue_3
              JBE cipher_lower_3
              

check_upper_3:CMP CL,41h
              JB  continue_3
              JAE check_boundary_3
              
check_boundary_3: CMP CL,5Ah
                  JBE cipher_upper_3
                  JA continue_3

                 

cipher_lower_3:test SI, 1
               JZ lower_even_3
               JNZ lower_odd_3
               

lower_even_3:CMP CL,7Ah
             JE  handle_lower_even_z_3
             ADD CL,3d
             MOV ciphered_third_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_3
             JE clear_indices_for_cipher
            
             
            
lower_odd_3:CMP CL,7Ah
            JE  handle_lower_odd_z_3
            ADD CL,3d
            SUB CL,20h
            MOV ciphered_third_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_3
            JE clear_indices_for_cipher
            
             


cipher_upper_3:test SI, 1
               JZ upper_even_3
               JNZ upper_odd_3
               
upper_even_3:CMP CL,5Ah
             JE  handle_upper_even_z_3
             ADD CL,3d
             ADD CL,20h
             MOV ciphered_third_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_3
             JE clear_indices_for_cipher 


upper_odd_3:CMP CL,5Ah
            JE  handle_upper_odd_z_3
            ADD CL,3d
            MOV ciphered_third_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_3
            JE clear_indices_for_cipher
            
            

handle_lower_even_z_3:SUB CL,26d
                      ADD CL,3d
                      MOV ciphered_third_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_3
                      JE clear_indices_for_cipher
                      
                      
handle_upper_even_z_3:SUB CL,26d
                      ADD CL,3d
                      ADD CL,20h
                      MOV ciphered_third_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_3
                      JE clear_indices_for_cipher
                
                
                
handle_lower_odd_z_3: SUB CL,26d
                      ADD CL,3d
                      SUB CL,20h
                      MOV ciphered_third_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_3
                      JE clear_indices_for_cipher
                      
                      

handle_upper_odd_z_3: SUB CL,26d
                      ADD CL,3d
                      ADD CL,20h
                      MOV ciphered_third_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_3
                      JE clear_indices_for_cipher
            
            

  
                 
                 
continue_3:MOV ciphered_third_line[SI], CL
           INC SI
           CMP SI,BX 
           JNE find_cipher_3
           JE clear_indices_for_cipher
           
           

find_cipher_2:MOV CL, second_line[SI]
              CMP CL, 61h
              JAE check_lower_2
              JB  check_upper_2
              
check_lower_2:CMP CL,7Ah
              JA  continue_2
              JBE cipher_lower_2
              

check_upper_2:CMP CL,41h
              JB  continue_2
              JAE check_boundary_2
              
check_boundary_2: CMP CL,5Ah
                  JBE cipher_upper_2
                  JA continue_2


                  

cipher_lower_2:test SI, 1
               JZ lower_even_2
               JNZ lower_odd_2
               

lower_even_2:CMP CL,7Ah
             JE  handle_lower_even_z_2
             ADD CL,2d
             MOV ciphered_second_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_2
             JE clear_indices_for_cipher
             

lower_odd_2:CMP CL,7Ah
            JE  handle_lower_odd_z_2
            ADD CL,2d
            SUB CL,20h
            MOV ciphered_second_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_2
            JE clear_indices_for_cipher
            
             




cipher_upper_2:test SI, 1
               JZ upper_even_2
               JNZ upper_odd_2
               
upper_even_2:CMP CL,5Ah
             JE  handle_upper_even_z_2
             ADD CL,2d
             ADD CL,20h
             MOV ciphered_second_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_2
             JE clear_indices_for_cipher 


upper_odd_2:CMP CL,5Ah
            JE  handle_upper_odd_z_2
            ADD CL,2d
            MOV ciphered_second_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_2
            JE clear_indices_for_cipher
            
            
            
handle_lower_even_z_2:SUB CL,26d
                      ADD CL,2d
                      MOV ciphered_second_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_2
                      JE clear_indices_for_cipher
                      
                      
handle_upper_even_z_2:SUB CL,26d
                      ADD CL,2d
                      ADD CL,20h
                      MOV ciphered_second_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_2
                      JE clear_indices_for_cipher
                
                
                
handle_lower_odd_z_2: SUB CL,26d
                      ADD CL,2d
                      SUB CL,20h
                      MOV ciphered_second_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_3
                      JE clear_indices_for_cipher
                      
                      

handle_upper_odd_z_2: SUB CL,26d
                      ADD CL,2d
                      ADD CL,20h
                      MOV ciphered_second_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_2
                      JE clear_indices_for_cipher  
                 
                 
continue_2:MOV ciphered_second_line[SI], CL
           INC SI
           CMP SI,BX 
           JNE find_cipher_2
           JE clear_indices_for_cipher
                     
         
         

find_cipher_1:MOV CL, first_line[SI]
              CMP CL, 61h
              JAE check_lower_1
              JB  check_upper_1
              
check_lower_1:CMP CL,7AH
              JA  continue_1
              JBE cipher_lower_1
              

check_upper_1:CMP CL,41h
              JB  continue_1
              JAE check_boundary_1
              
check_boundary_1: CMP CL,5Ah
                  JBE cipher_upper_1
                  JA continue_1

                  

cipher_lower_1:test SI, 1
               JZ lower_even_1
               JNZ lower_odd_1
               

lower_even_1:CMP CL,7Ah
             JE  handle_lower_even_z_1
             ADD CL,1d
             MOV ciphered_first_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_1
             JE clear_indices_for_cipher
             

lower_odd_1:CMP CL,7Ah
            JE  handle_lower_odd_z_1
            ADD CL,1d
            SUB CL,20h
            MOV ciphered_first_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_1
            JE clear_indices_for_cipher
            



cipher_upper_1:test SI, 1
               JZ upper_even_1
               JNZ upper_odd_1
               
upper_even_1:CMP CL,5Ah
             JE  handle_upper_even_z_1
             ADD CL,1d
             ADD CL,20h
             MOV ciphered_first_line[SI], CL
             INC SI
             CMP SI,BX
             JNE find_cipher_1
             JE clear_indices_for_cipher 


upper_odd_1:CMP CL,5Ah
            JE  handle_upper_odd_z_1
            ADD CL,1d
            MOV ciphered_first_line[SI], CL
            INC SI
            CMP SI,BX
            JNE find_cipher_1
            JE clear_indices_for_cipher
            
            

handle_lower_even_z_1:SUB CL,26d
                      ADD CL,1d
                      MOV ciphered_first_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_1
                      JE clear_indices_for_cipher
                

handle_upper_even_z_1:SUB CL,26d
                      ADD CL,1d 
                      ADD CL,20h
                      MOV ciphered_first_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_1
                      JE clear_indices_for_cipher
                
                
handle_lower_odd_z_1: SUB CL,26d
                      ADD CL,1d
                      SUB CL,20h
                      MOV ciphered_first_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_1
                      JE clear_indices_for_cipher
                      
                      

handle_upper_odd_z_1: SUB CL,26d
                      ADD CL,1d
                      ADD CL,20h
                      MOV ciphered_first_line[SI], CL
                      INC SI
                      CMP SI,BX
                      JNE find_cipher_1
                      JE clear_indices_for_cipher  
                 
                 
continue_1:MOV ciphered_first_line[SI], CL
           INC SI
           CMP SI,BX 
           JNE find_cipher_1
           JE clear_indices_for_cipher



clear_indices_for_cipher:XOR SI,SI
                         XOR CL,CL
                         POP BX 
                         CMP BP, 4
                         JE  clear_BP
                         JNE perform_cipher



clear_BP:XOR BP,BP     
                   
; ---- To visualize the results after running emulate, in the emulator window, on the bottom there is a 
; ---- vars button, choose the variable inside the vars window and click on it and in the emulator you can see
; ---- the values of the variable ---


.exit
End