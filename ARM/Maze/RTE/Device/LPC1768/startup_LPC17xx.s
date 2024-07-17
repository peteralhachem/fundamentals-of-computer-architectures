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

NUM_ROW EQU 6
NUM_COL EQU 5
SYSTICKcontrolAndStatusRegister	EQU 0xE000E010
SYSTICKreloadValueRegister		EQU 0xE000E014
SYSTICKcurrentValueRegister		EQU 0xE000E018
SYSTICKcalibrationValue			EQU 0xE000E01C
	
 				AREA currentMap, DATA, READWRITE
maze			SPACE NUM_ROW * NUM_COL

				AREA initialMap, DATA, READONLY
initial_maze	DCB 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
				DCB 0xFF, 0, 1, 0, 0xFF
				DCB 0xFF, 0, 0, 0, 0xFF
				DCB 0xFF, 0, 0, 0, 0xFF
				DCB 0xFF, 0, 0, 0, 0xFF
				DCB 0xFF, 0xFF, 0xFF, 0xFF, 0xFF

                AREA    |.text|, CODE, READONLY
Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
					
				LDR R0, =SYSTICKcontrolAndStatusRegister
                MOV R1, #0   ; no interrupt, start timer.
                STR R1, [R0]
					
				LDR R0, =SYSTICKreloadValueRegister
                MOV R1, #0xFFFF
				LSL	R1, #4
				ADD R1, #0xF
                STR R1, [R0]
				
				
				LDR R0, =SYSTICKcurrentValueRegister
                MOV R1, #0
                STR R1, [R0]

                LDR R0, =SYSTICKcontrolAndStatusRegister
                MOV R1, #5   ; no interrupt, start timer.
                STR R1, [R0]
				
				
				; initialize the matrix
				LDR r0, =initial_maze
				LDR r1, =maze
				MOV r2, #NUM_ROW * NUM_COL
loopCopyData	LDRB r3, [r0], #1
				STRB r3, [r1], #1
				SUBS r2, r2, #1
				BNE loopCopyData
				
				LDR r0, =maze
				MOV r1, #NUM_ROW
				MOV r2, #NUM_COL
				MOV r3, #7
				BL depthFirstSearch
				
				
				
				
				
				
				
stop			B stop

                ;IMPORT  SystemInit
                ;IMPORT  __main
                ;LDR     R0, =SystemInit
                ;BLX     R0
                ;LDR     R0, =__main
                ;BX      R0
                ENDP


depthFirstSearch PROC
				EXPORT depthFirstSearch
				
				
				push {r0,r1,r2,r3,r4-r12,LR}
				MOV r4, r0
				MOV r6, r1 ; num rows
				MOV r7,r2 ; num columns
				MOV r8,r3 ; index
				MOV r10, sp; value of the stack pointer
				
begin				

check_right		ADD r9,r8,#1
				LDRB r5,[r4,r9]
				CMP r5, #0
				ITE EQ
				MOVEQ r0, #0
				MOVNE r0, #1

check_bottom 	MOV r9, #0
				ADD r9, r8, r7 
				LDRB r5,[r4,r9]
				CMP r5, #0
				ITE EQ
				MOVEQ r1, #0
				MOVNE r1, #1

check_left	 	MOV r9, #0
				SUB r9, r8, #1
				LDRB r5,[r4,r9]
				CMP r5, #0
				ITE EQ
				MOVEQ r2, #0
				MOVNE r2, #1


check_top	 	MOV r9, #0
				SUB r9, r8, r7
				LDRB r5,[r4,r9]
				CMP r5, #0
				ITE EQ
				MOVEQ r3, #0
				MOVNE r3, #1
				
				
				;BL chooseNeighbor
				BL chooseRandomNeighbor
				
				CMP r5, #1
				BEQ go_right
				CMP r5, #2
				BEQ go_bottom
				CMP r5, #3
				BEQ go_left
				CMP r5, #4 
				BEQ go_top
				CMP r5, #0
				BEQ check_visited


go_right		PUSH {r8}
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x2 ; set bit 1 to 1 
				STRB r9, [r4,r8]
				ADD r8,r8,#1
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x1
				ORR r9, r9, #0x8 ; set bit 3 to 1 
				STRB r9, [r4,r8]
				B begin

go_bottom		PUSH {r8}
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x4 ; set bit 2 to 1
				STRB r9, [r4,r8]
				ADD r8,r8,r7
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x1
				ORR r9, r9, #0x10 ; set bit 4 to 1
				STRB r9, [r4,r8]
				B begin

go_left			PUSH {r8}
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x8 ; set bit 3 to 1 
				STRB r9, [r4,r8]
				SUB	r8,r8,#1
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x1
				ORR r9, r9, #0x2 ; set
				STRB r9, [r4,r8]
				B begin
				

go_top			PUSH {r8}
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x10 ; set bit 4 to 1
				STRB r9, [r4,r8]
				SUB	 r8,r8,r7
				LDRB r9, [r4,r8]
				ORR r9, r9, #0x1
				ORR r9, r9, #0x4 ; set bit 4 to 1
				STRB r9, [r4,r8]
				B begin
				


				
				
				
				
; current cell does not change, pop a value from the stack			


check_visited  POP {r8}
			   CMP sp, r10
			   BEQ return
			   BNE begin
			   
			   
return		   POP {r0,r1,r2,r3,r4-r12,PC}

				ENDP
					


chooseNeighbor PROC
			   EXPORT chooseNeighbor

check_r0		CMP r0, #0
				BEQ handle_r0
				BNE check_r1
				
handle_r0		MOV r5, #1
				BX LR
				
		
check_r1		CMP r1, #0
				BEQ handle_r1
				BNE check_r2
				
handle_r1		MOV r5, #2
				BX LR
				

check_r2		CMP r2, #0
				BEQ handle_r2
				BNE check_r3
				
handle_r2		MOV r5, #3
				BX LR
				
				
check_r3		CMP r3, #0
				BEQ handle_r3
				BNE finish
				
handle_r3		MOV r5, #4
				BX LR
				
finish			MOV r5, #0
				BX LR
				

				ENDP
					

chooseRandomNeighbor PROC
					EXPORT chooseRandomNeighbor


					push {r4,r6-r12, LR}
					
					MOV     r4, #0          ; counts how many 0s they are
					MOV     r5, #0          ; th
					
					
					              
check_0			CMP     r0, #0
				BNE     check_1
				ADD     r4, r4, #1      
				MOV     r6, #1
			    PUSH 	{r6}
                

check_1        	CMP     r1, #0
                BNE     check_2
                ADD     r4, r4, #1      
                MOV     r6, #2 
				PUSH	{r6}
     

check_2         CMP     r2, #0
                BNE     check_3
                ADD     r4, r4, #1      
                MOV     r6, #3 
				PUSH    {r6}
 

check_3         CMP     r3, #0
                BNE     check_systick
                ADD     r4, r4, #1
                MOV     r6, #4          
				PUSH	{r6}
				

check_systick   CMP     r4, #0
                BEQ     no_neighbors
                LDR     r0, =SYSTICKcurrentValueRegister
                LDR     r1, [r0]
				MOV 	r3, r1

				; index = systickTimer % count
                UDIV    r3, r3, r4      ; R1 = systickTimer / count
				MUL		r3,r4
                SUB		r1,r3
				MOV		r2,r1
				
				
				LDR		r5, [sp,r2]
				
clear_stack		CMP r4, #0
				BNE pop_value
				BEQ  return_value


pop_value		POP {r6}
				SUB r4,r4,#1
				B clear_stack
				
				
no_neighbors    MOV r5, #0

return_value 	pop{r4,r6-r12, PC}
				
          		
				
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
