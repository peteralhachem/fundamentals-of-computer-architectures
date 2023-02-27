;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF
					
;-----------------------------Areas that are considered as the Poles of the tower--------------------------------------------					
			
				AREA	STACK,READWRITE
Pole1			SPACE	20
	
				AREA	STACK,READWRITE
Pole2			SPACE	20

				AREA	STACK,READWRITE
Pole3			SPACE	20

                AREA    |.text|, CODE, READONLY

values	DCD	9,6,3,2,1,8,7,0,5,4,0
ex3consts		DCD 	4, 3, 2, 1, 0
numdiscs		DCD		4

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler 					[WEAK]
                
;------------------------------------Adding the values to the first pole-----------------------------------------------
				

				LDR r0,=values
				LDR r1,=Pole1
				PUSH {r0,r1}
				
				
				BL fillStack
				
				POP {r0,r1}
				
				
				
;-------------------------------------Adding the values to the second pole-----------------------------------------------

				
				LDR r2,=Pole2 ; Here I just load the value of r2 without loading the value of r0 because I want to keep the value that was popped
							; from the first pole
				
				PUSH {r0,r2}
				
				BL fillStack
				
				POP {r0,r2}
				
;-------------------------------------Adding the values to the third pole--------------------------------------------------
				
				LDR r3,=Pole3	; Here I just load the value of r3 without loading the value of r0 because I want to keep the value that was popped
							; from the second pole
				
				
				PUSH {r0,r3}
				
				BL fillStack
				
				POP {r0,r3}
				
;----------------------------------Moving one disk from one pole to another------------------------------------------------

				MOV r0,#0 		; Contains the return value
								
				
				PUSH {r1}
				PUSH {r2}
				PUSH {r0}
				BL	move1
				POP {r0}
				POP	{r2}
				POP {r1}
				
				LDR r0,=ex3consts ;Loading the constants that are used in the numerous move scenario
				LDR r1,=Pole1 ;Loading the address of the source-pole
				
				PUSH {r1}
				PUSH {r0}
				
				BL fillStack ; Filling the source-pole with all the values.
				
				POP {r0,r1} 
				
				LDR r2,=Pole2 ; Loading the address of the destination pole.
				LDR r3,=Pole3 ; Loading the address of the auxiliary pole.
				LDR r0,=numdiscs ; Loading the address of the number of disks we want to move.
				LDR r0,[r0] ; Loading the value of the number of disks. 
				

				PUSH {r1}
				PUSH {r2}
				PUSH {r3}
				PUSH {r0}
				
				BL moveN
				
				POP {r0}
				POP {r3}
				POP {r2}
				POP {r1}
				
		
				
				


				
stop			B	stop              
                ENDP
					
					

fillStack		PROC
	
				PUSH {r3,r4,r5,LR}	
				LDR r3,[sp,#16]; Fetching the address of the values.
				LDR r4,[sp,#20]; Fetching the address of the pole.
				
loop			MOV r7,r5
				LDR r5,[r3],#4
				CMP r7,#0		; If r8 is 0 check if r7 is also 0 if it is that means I am starting a new pole so loop again to get rid
				BEQ check_r5	; of the zero and get a new value.
				CMP r5,#0		; Here when r7 is 0 but r8 is not 0 I need to continue
				BEQ Continue
				CMP r5,r7
				BGE Continue	; Branch to Continue if r7 is greater than r8 which means that we are also done with the pole.
				
check_r5		CMP r5,#0
				BEQ loop

				STR r5,[r4],#4  ;
				
				B	loop
				
Continue		SUBS r3,r3,#4 		; Since I am using a post-indexed addressing that means that I am updating the addressing after performing a value. so before leaving a pole I want to go back one value to use
				SUBS r4,r4,#4		; it for the checks.
				STR r3,[sp,#16] 	; I store the value to not lose in the stack pointer so I can POP it as r0.
				STR r4,[sp,#20]
				POP{r3,r4,r5,PC}
				
				
				ENDP
					

move1			PROC
	
				PUSH {r4,r5,r6,r7,r8,LR}
				
				LDR r6,[sp,#24]	; Value of the return value.
				LDR r5,[sp,#28]	; Value of the address of the destination pole.
				LDR r4,[sp,#32] ; Value of the address of the source pole.
				
				LDR r7,=Pole1
				CMP r5,r7
				BEQ perform_move_empty
				
				LDR r7,=Pole2
				CMP r5,r7
				BEQ perform_move_empty
				
				LDR r7,=Pole3
				CMP r5,r7
				BEQ perform_move_empty
				

				
perform_move	LDR r8,[r4],#-4
				STR r8,[r5,#4]!
				MOV r6,#1
				B return

perform_move_empty LDR r8,[r4],#-4
				   STR r8,[r5],#4
				   MOV r6,#1
				
return			STR r6,[sp,#24]	;Send the return value to r2
				STR r5,[sp,#28] ; Send the destination-pole address again.
				STR r4,[sp,#32]	; Send the source-pole address back.
				POP	{r4,r5,r6,r7,r8,PC}
				
				ENDP
					
/*Pseudo-code moveN:					
M = 0;
if (N == 1) 
{
move1(X, Y, a);
#a is the return value: 0-1;# 
M = M + a;
}
else {
moveN(X, Z, Y, N-1);
M = M + b;
move1(X, Y, a);
if (a == 0) return;
else M = M + 1;
moveN(Z, Y, X, N-1);
M = M + c;
}*/

					
					
					

					
moveN			PROC
				
				PUSH {r4-r9,LR}
				LDR r7,[sp,#28] ; Fetching the number of disks N.
				LDR r6,[sp,#32] ; Fetching auxiliary disk Z
				LDR r5,[sp,#36] ; Fetching the destination disk Y.
				LDR r4,[sp,#40] ; Fetching the source disk X.
				CMP r7,#1		; If (N==1) from the pseudocode
				BEQ perform_move1
				BNE perform_moveN
				
perform_move1	PUSH{r4}
				PUSH{r5}
				PUSH {r11} ; Contains the return value of if the performed move happened or not.
				BL move1
				POP {r11}
				POP {r5}
				POP {r4}
				ADD r8,r8,r11; r8 contains the value of M and it  here we are doing M=M+a
				B EndMove
				
perform_moveN	PUSH {r4} ; Containing X.
				PUSH {r6} ; Y -> Z (Destination pole is Z)
 				PUSH {r5} ; Z -> Y (Auxiliary pole is Y)
				SUB r7,r7,#1
				PUSH {r7} ; Now r5 containsc N-1.
				BL	moveN
				POP {r9} ; Getting the value of moveN
				POP {r5}
				POP {r6}
				POP {r4}
				ADD r8,r8,r9; M=M+b
				PUSH {r4}
				PUSH {r5}
				PUSH {r11}
				BL move1
				POP {r11}
				POP {r5}
				POP {r4}
				CMP r9,#0
				BEQ EndMove
				ADD r8,r8,#1 ; M=M+1
				PUSH {r6}
				PUSH {r5}
				PUSH {r4}
				SUB r7,r7,#1 ; N-1
				PUSH {r7}
				BL moveN
				POP {r9}; 
				POP {r4}
				POP {r5}
				POP {r6}
				ADD r8,r8,r9; M=M+c
				
				
				
	
				
				
				
				


EndMove			STR r4,[sp,#40]
				STR r5,[sp,#36]
				STR r6,[sp,#32]
				STR r7,[sp,#28]
				
				POP{r4-r7,PC}
				

				ENDP
					

; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
