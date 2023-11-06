.model small

.stack 

.data

N EQU 3 ; First dimension of the first matrix
M EQU 4 ; Intermediate dimension of both matrices
P EQU 2 ; Last dimension of the last matrix


first_matrix DB 4,-3,5,1,3,-5,0,11,-5,12,4,-5

second_matrix DB -2,3,5,-1,4,3,9,-7

result_matrix DW 6 DUP(?) 

length_A DB ?
length_B DB ? 

initial_index_A DB ? 
initial_index_B DB ? 

stopping_criterion_A DB N DUP(?) 
stopping_criterion_B DB P DUP (?)

current_row DW 0
current_column DW 0  

.code
.startup 




XOR SI,SI
XOR DI,DI
XOR AX,AX
XOR BX,BX
XOR CX,CX
XOR DX,DX


; ---- A NxM matrix is a N*M array so I compute the length of the arrays ----

set_length:MOV AL,N
           MOV DL,M
           IMUL DL
           MOV length_A,AL
           XOR AX,AX
           XOR DX,DX
           MOV AL,M
           MOV DL,P
           IMUL DL 
           MOV length_B,AL
           XOR AX,AX
           XOR DX,DX
           MOV DL,N
           
           
;--- getting the stopping criterion for each row, it is the index of the last element of each row ----      

set_stopping_A:ADD DL,AL
               MOV stopping_criterion_A[BX],DL
               MOV AL,M
               INC BL
               CMP BL,N
               JNE set_stopping_A
                          


XOR AX,AX
XOR BX,BX
XOR DX,DX


; ---- getting the stopping criterion for each column, it is the index of the last element of each column ----

set_stopping_B:MOV DL,length_B
               MOV AL,P
               SUB AL,BL
               SUB DL,AL
               MOV stopping_criterion_B[BX],DL
               INC BL
               CMP BL,P
               JNE set_stopping_B
               


                         
                         
XOR AX,AX
XOR BX,BX
XOR DX,DX


; ---- initialize two variables that will tell us the row of the first matrix and the column of the second matrix ----

MOV current_row,0
MOV current_column,0



; ---- I fetch the stopping criterion of the row matrix in order to use it for multiplication ----

set_stopping_value_A:MOV SI,current_row
                     CMP SI,N   ; if SI == N this is means that we have finished the rows, remember that rows go from 0,...,n-1
                     JE  finish
                     MOV DI,current_column
                     MOV BL,stopping_criterion_A[SI]
                     JMP set_initial_values
                     
;---- Here I initialize the indices for the two matrices, since I may need to jump between indices ----                     

set_initial_values:CMP SI,0
                  JE  set_0
                  MOV CL,stopping_criterion_A[SI-1]
                  MOV SI,CX
                  ADD SI,1
                  JMP reset_values
                  
; ---- Initialize the first pair of indices ----                  

set_0:CMP DI,0
      JNE reset_values
      XOR SI,SI
      XOR DI,DI
      XOR AX,AX
      XOR DX,DX
      XOR CX,CX
      JMP multiply
      
      
reset_values:XOR AX,AX
             XOR DX,DX
             XOR CX,CX
                  
; ---- This function performs an element by element multiplication ----

multiply: MOV AL,first_matrix[SI]
          MOV DL,second_matrix[DI]
          IMUL DL
          ADD CX,AX
          JO check_overflow
          CMP SI,BX
          JE save_value
          INC SI
          ADD DI,P
          XOR AX,AX
          XOR DX,DX
          JMP multiply
          
          
; ---- Check for overflow whether it is positive or negative you insert the corresponding value ----          
          
check_overflow:CMP CX,0
               JA  positive_overflow
               JB  negative_overflow
               
positive_overflow:MOV CX,32767
                  JMP save_value
                  
negative_overflow:MOV CX,-32768
                  JMP save_value
          

; ---- save the values in the result matrix ----          

save_value:MOV BP,current_column
           MOV SP,current_row
           CMP SP,0
           JNE save_value_1
           ADD BP,SP
           MOV result_matrix[BP],CX
           XOR CX,CX
           JMP check_column
           

; ---- save the results for values in the array when row>0 ----
; ---- in order to get the index of the array, we do current_row + current_column + (P-1)* current_row ---- 
           
save_value_1: XOR AX,AX
              XOR SI,SI
              ADD BP,SP
              MOV AX,P-1
              IMUL SP
              ADD BP,AX
              MOV result_matrix[BP],CX
              XOR CX,CX
              JMP check_column
              
              
; ---- for each row we need to update the column if the current_column < last_column ----          

check_column:MOV DX,current_column
             CMP DX,P-1
             JB  update_column
             JAE update_row_column
             
  

update_column:INC DX
              MOV current_column,DX
              JMP set_stopping_value_A
              


; ---- Rows and columns are updated everytime I reach the last column ----


update_row_column:MOV DX,current_column
                  SUB DX,P-1
                  MOV current_column,DX
                  XOR DX,DX
                  MOV DX,current_row
                  INC DX
                  MOV current_row,DX
                  XOR DX,DX
                  JMP set_stopping_value_A
          
          
          


finish:     
                                                   

.exit
END