.model small

.stack 

.data

buffer db 51 
prompt db "Enter a string (max 50 characters): $"


first_line DB 51 DUP (?)
second_line DB 51 DUP (?)
third_line DB 51 DUP (?)

occurence_array_1 DB 53 DUP (0)
occurence_array_2 DB 53 DUP (0) 
occurence_array_3 DB 53 DUP (0) 

max_1 DB ? 
max_2 DB ?
max_3 DB ?

index_max_1 DB ? 
index_max_2 DB ? 
index_max_3 DB ?

half_characters_1 DB 53 DUP(0) 
half_characters_2 DB 53 DUP(0)
half_characters_3 DB 53 DUP(0)

final_string_1 DB 55 DUP(?)
final_string_2 DB 55 DUP(?)
final_string_3 DB 55 DUP(?)


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
         
; To find a maximum I need to assign a value to to the maximum variable then compare it with the next one.         

find_max_1:MOV CL, occurence_array_1[BX]
           CMP DI, 0 
           JE  assign_first
           CMP max_1, CL
           JB  change_max_1
           INC BX
           INC DI 
           CMP DI, 53
           JE  clear_indices_for_max
           JNE find_max_1
            
change_max_1: MOV max_1, CL
              MOV index_max_1,BL
              INC BX
              INC DI
              CMP DI, 53
              JE  clear_indices_for_max
              JNE find_max_1
              


find_max_2:MOV CL, occurence_array_2[BX]
           CMP DI, 0 
           JE  assign_first
           CMP max_2, CL
           JB  change_max_2
           INC BX
           INC DI 
           CMP DI, 53
           JE  clear_indices_for_max
           JNE find_max_2
           

change_max_2: MOV max_2, CL
              MOV index_max_2,BL
              INC BX
              INC DI
              CMP DI, 53
              JE  clear_indices_for_max
              JNE find_max_2 


find_max_3:MOV CL, occurence_array_3[BX]
           CMP DI, 0 
           JE  assign_first
           CMP max_3, CL
           JB  change_max_3
           INC BX
           INC DI 
           CMP DI, 53
           JE  clear_indices_for_max
           JNE find_max_3
           

change_max_3: MOV max_3, CL
              MOV index_max_3,BL
              INC BX
              INC DI
              CMP DI, 53
              JE  clear_indices_for_max
              JNE find_max_3



assign_first:CMP BP,1 
             JE  assign_1
             CMP BP,2
             JE  assign_2
             CMP BP,3
             JE  assign_3
             

assign_1:MOV max_1,CL
         MOV index_max_1,BL
         INC BX
         INC DI 
         JMP find_max_1 
         
                             
                    
                    
assign_2:MOV max_2,CL
         MOV index_max_2,BL
         INC BX
         INC DI 
         JMP find_max_2 


assign_3:MOV max_3,CL
         MOV index_max_3,BL
         INC BX
         INC DI 
         JMP find_max_3 


clear_indices_for_max: XOR BX,BX
                       XOR DI,DI
                       XOR CL,CL 
                       CMP BP,3 
                       JE  clear
                       JNE find_max                    
                    
                    
clear: XOR BP,BP
 
get_character:INC BP
              CMP BP,1
              JE get_character_1
              CMP BP, 2
              JE get_character_2
              CMP BP, 3
              JE get_character_3 
              
get_character_1: CMP index_max_1, 26
                 JB  lower_case_character_1 
                 JAE upper_case_character_1 
                 
                 
lower_case_character_1:ADD index_max_1, 61h
                       JMP next_step
                       

upper_case_character_1:SUB index_max_1, 26
                       ADD index_max_1, 41h
                       JMP next_step
                       


get_character_2: CMP index_max_2, 26
                 JB  lower_case_character_2 
                 JAE upper_case_character_2 
                 
                 
lower_case_character_2:ADD index_max_2, 61h
                       JMP next_step
                       

upper_case_character_2:SUB index_max_2, 26
                       ADD index_max_2, 41h
                       JMP next_step
                       
                       

get_character_3: CMP index_max_3, 26
                 JB  lower_case_character_3 
                 JAE upper_case_character_3 
                 
                 
lower_case_character_3:ADD index_max_3, 61h
                       JMP next_step
                       

upper_case_character_3:SUB index_max_3, 26
                       ADD index_max_3, 41h
                       JMP next_step
                       
next_step: CMP BP,3 
           JNE get_character
           JE  clear_value_of_BP
           
          
clear_value_of_BP:XOR BP,BP
                  JMP find_half          

find_half:INC BP
          CMP BP,1 
          JE find_half_1
          CMP BP,2
          JE find_half_2
          CMP BP,3
          JE find_half_3 


; ----Working with the first string----         
         
find_half_1:CMP BX,0 
            JE set_half_1
            MOV BX,SI
            MOV DL, occurence_array_1[BX]
            CMP DL, 0 
            JE  continue_1
            CMP DL, CL 
            JAE check_character_1 
            
           
continue_1: INC SI
            CMP SI, 53d
            JNE find_half_1 
            JE  clear_values_of_half
            

set_half_1:MOV CL,max_1 
           SHR CL,1  
           MOV BL,1
           JMP find_half_1
           
           
check_character_1:CMP BL, 26
                  JB  lower_case_half_1
                  JAE upper_case_half_1


lower_case_half_1:ADD BL, 61h 
                  MOV half_characters_1[DI], BL
                  INC DI 
                  INC SI
                  CMP SI, 53d
                  JNE find_half_1
                  JE  clear_values_of_half
                  
                  
                  
upper_case_half_1:SUB BL, 26 
                  ADD BL, 41h
                  MOV half_characters_1[DI], BL 
                  INC DI
                  INC SI
                  CMP SI, 53d
                  JNE find_half_1
                  JE  clear_values_of_half
                  

;----Working with the second string ----                  
                  
find_half_2:CMP BX,0
            JE set_half_2
            MOV BX,SI
            MOV DL, occurence_array_2[BX] 
            CMP DL, 0
            JE  continue_2
            CMP DL, CL 
            JAE check_character_2
            
            
continue_2: INC SI
            CMP SI, 53d
            JNE find_half_2 
            JE  clear_values_of_half
            

set_half_2:MOV CL,max_2 
           SHR CL,1 
           MOV BL,1
           JMP find_half_2
                  

check_character_2:CMP BL, 26
                  JB  lower_case_half_2
                  JAE upper_case_half_2


lower_case_half_2:ADD BL, 61h 
                  MOV half_characters_2[DI], BL
                  INC DI
                  INC SI 
                  CMP SI, 53d
                  JNE find_half_2
                  JE  clear_values_of_half
                  
                  
                  
upper_case_half_2:SUB BL, 26 
                  ADD BL, 41h
                  MOV half_characters_1[DI], BL 
                  INC DI
                  INC SI    
                  CMP SI, 53d
                  JNE find_half_2
                  JE  clear_values_of_half
                  
 
 
;---- Working with the third string ----                 
                  
find_half_3:CMP BX,0 
            JE set_half_1
            MOV BX,SI
            MOV DL, occurence_array_1[BX]
            CMP DL,0
            JE  continue_3
            CMP DL, CL 
            JAE check_character_3 
           
continue_3: INC SI
            CMP SI, 53d
            JNE find_half_3 
            JE  clear_values_of_half
            

set_half_3:MOV CL,max_3 
           SHR CL,1
           MOV BL,1
           JMP find_half_3
                  

check_character_3:CMP BL, 26
                  JB  lower_case_half_3
                  JAE upper_case_half_3


lower_case_half_3:ADD BL, 61h 
                  MOV half_characters_3[DI], BL
                  INC DI
                  INC SI 
                  CMP SI, 53d
                  JNE find_half_3
                  JE  clear_values_of_half
                  
                  
                  
upper_case_half_3:SUB BL, 26 
                  ADD BL, 41h
                  MOV half_characters_3[DI], BL 
                  INC DI
                  INC SI
                  CMP SI, 53d
                  JNE find_half_3
                  JE  clear_values_of_half 
   
   
   
clear_values_of_half: XOR BX,BX
                      XOR SI,SI
                      XOR CL,CL
                      XOR DI,DI
                      XOR DL,DL
                      CMP BP,3
                      JE  clear_value_of_index
                      JNE find_half
                      
clear_value_of_index:XOR BP,BP


create_strings:INC BP
               CMP BP,1
               JE  create_string_1
               CMP BP,2
               JE  create_string_2
               CMP BP,3
               JE  create_string_3
           
create_string_1:CMP SI,0 
                JE  insert_max_1
                JNE insert_half_1
                
insert_max_1:MOV CL, index_max_1
             MOV final_string_1[SI],CL
             INC SI
             MOV final_string_1[SI],20h
             INC SI
             MOV CL,max_1
             MOV final_string_1[SI],CL
             INC SI
             MOV final_string_1[SI],"$"
             INC SI 
             
insert_half_1:MOV CL,half_characters_1[DI] 
              MOV final_string_1[SI],
              CMP half_characters_1[DI], 0 
              JE  continue_insert_1
              

continue_insert_1: INC SI
                   INC DI
                   CMP DI, 53d
                   JNE create_string_1
                   JE  final_insert_string_1
                   

final_insert_string_1: MOV final_string_1[SI], "$"
                       JMP clear_indices_for_final_string
                       
                       
                       
                       
create_string_2:CMP SI,0 
                JE  insert_max_2
                JNE insert_half_2
                
insert_max_2:MOV CL, index_max_2
             MOV final_string_2[SI],CL
             INC SI
             MOV final_string_2[SI],20h
             INC SI
             MOV CL,max_2
             MOV final_string_2[SI],CL
             INC SI
             MOV final_string_2[SI],"$"
             INC SI 
             
insert_half_2:MOV CL,half_characters_2[DI] 
              MOV final_string_2[SI],CL
              CMP half_characters_2[DI], 0 
              JE  continue_insert_2
              

continue_insert_2: INC SI
                   INC DI
                   CMP DI, 53d
                   JNE create_string_2
                   JE  final_insert_string_2
                   

final_insert_string_2: MOV final_string_2[SI], "$"
                       JMP clear_indices_for_final_string
                       
                       
create_string_3:CMP SI,0 
                JE  insert_max_3
                JNE insert_half_3
                
insert_max_3:MOV CL, index_max_3
             MOV final_string_3[SI],CL
             INC SI
             MOV final_string_3[SI],20h
             INC SI
             MOV CL,max_3
             MOV final_string_3[SI],CL
             INC SI
             MOV final_string_3[SI],"$"
             INC SI 
             
insert_half_3:MOV CL,half_characters_3[DI] 
              MOV final_string_3[SI],CL
              CMP half_characters_3[DI], 0 
              JE  continue_insert_3
              

continue_insert_3: INC SI
                   INC DI
                   CMP DI, 53d
                   JNE create_string_3
                   JE  final_insert_string_3
                   

final_insert_string_3: MOV final_string_3[SI], "$"
                       JMP clear_indices_for_final_string
                   

clear_indices_for_final_string: XOR SI,SI
                                XOR DI,DI
                                XOR CL,CL
                                CMP BP,3 
                                JNE create_strings
                                JE  display
                                
                               
                               
                               
                               
                               
display:CMP BP,3 
        JE  display_1 
        CMP BP,2 
        JE  display_2 
        CMP BP,1 
        JE  display_3
        


display_1:MOV DX,offset final_string_1
          MOV AH, 09h
          int 21h
          DEC BP
          JMP display
          
          

display_2:MOV DX,offset final_string_2
          MOV AH, 09h
          int 21h
          DEC BP
          JMP display 
           

display_3:MOV DX,offset final_string_3
          MOV AH, 09h
          int 21h
          DEC BP
          JMP end_process                                 

end_process:

.exit
End 
