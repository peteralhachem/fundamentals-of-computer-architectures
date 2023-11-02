.model small

.stack 

.data

N EQU 3 ; First dimension of the first matrix
M EQU 4 ; Intermediate dimension of both matrices
P EQU 2 ; Last dimension of the last matrix


first_matrix DW 4,-3,5,1,3,-5,0,11,-5,12,4,-5

second_matrix DW 8 -2,3,5,-1,4,3,9,-7

result_matrix DW 6 DUP(?) 

.code
.startup 



; -- TODO:  matrices should be represented as an array  of N*M elements and M*P elements.
; -- TODO: the values will be stored by rows, so find an algorithm for multiplication 
; -- TODO: after getting the final result after summation, check if the result shows an overflow or not
; by comparing the overflow flag to either 1 or 0. 
; -- TODO: In the case of an overflow check if signed or unsigned, if signed -> highest negative value
; if unsigned -> highest positive value.


;idea for multiplication, SI for first matrix and DI for second matrix

XOR SI,SI
XOR DI,DI
XOR AX,AX
XOR BX,BX
XOR CX,CX
XOR DX,DX





.exit
END