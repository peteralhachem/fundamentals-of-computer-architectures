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
					
				AREA    |.EXERCISE_2|,DATA,READWRITE
Fibonacci_space			SPACE	26
				
				AREA    |.EXERCISE_3|,DATA,READWRITE
stored_values			SPACE	16

                AREA    |.text|, CODE, READONLY
				
; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler   [WEAK]
					
				;BL Renaming_Registers ; Branch that jumps to the first exercise of value Computation.
				
;--------------------------------------------------------------------------------------------------------------
				
				;BL Fibonacci_sequence ; Subroutine that calculates the Fibonacci sequence.
				;BL Storing_Fibonacci ; Subroutine that stores the values of the Fibonacci in a data area both in pre-indexed and post-indexed way.
						   
;---------------------------------------------------------------------------------------------------------------
				
				;BL Literal_Pool ; Getting the values of a literal pool and store them in a data area.
				
;---------------------------------------------------------------------------------------------------------------

				;BL UADD8_M3; Branch that jumps to the exercise that performs UADD8 on Cortex-M3 processor
							; sums the corresponding bytes of the two registers.
				
;----------------------------------------------------------------------------------------------------------------				
				
				;BL USAD8_M3; Branch that jumps to the exercise that performs USAD8 on Cortex-M3 processor 
						;calculate the absolute value of the substraction of two registers each  4 bytes together and sum them.
				
;----------------------------------------------------------------------------------------------------------------	
			
				BL SMUAD_SMUSD_M3
		
                ENDP
					
single_value RN r1
double_value RN r2
triple_value RN r3
quadruple_value RN r4
quintuple_value RN r5

Renaming_Registers   	PROC
				
						MOV single_value,#1
						MOV double_value,single_value,LSL #1; shifting left the single value will multiply it by 2.
						ADD triple_value,double_value,single_value ; adding the double value and the single value it's like multiplying by 3.
						MOV quadruple_value,single_value,LSL #2 ; shifting left the single value 2 times is like multiplying by 4.
						ADD quintuple_value,quadruple_value,single_value; adding the quadruple value and the single value is like multiplying by 5.

						BX LR
				
						ENDP
				
				

					
Fibonacci_sequence	    PROC
						MOV r0,#1
						MOV r1,#1
						ADD r2,r1,r0
						ADD r3,r2,r1
						ADD r4,r3,r2
						ADD r5,r4,r3
						ADD r6,r5,r4
						ADD r7,r6,r5
						ADD r8,r7,r6
						ADD r9,r8,r7
						ADD r10,r9,r8
						ADD r11,r10,r9
						ADD r12,r11,r10
				
						BX LR
				
						ENDP

Storing_Fibonacci    	PROC
						LDR r14,=Fibonacci_space
;-----------------------Pre_Indexed Addressing technique to store Fibonacci in data area-----------------
						STRB r0,[r14,#1]!
						STRB r1,[r14,#1]!
						STRB r2,[r14,#1]!
						STRB r3,[r14,#1]!
						STRB r4,[r14,#1]!
						STRB r5,[r14,#1]!
						STRB r6,[r14,#1]!
						STRB r7,[r14,#1]!
						STRB r8,[r14,#1]!
						STRB r9,[r14,#1]!
						STRB r10,[r14,#1]!
						STRB r11,[r14,#1]!
						STRB r12,[r14,#1]!
;-----------------------Post_Indexed Addressing technique to store Fibonacci in data area-----------------
						ADD  r14,r14,#1
						STRB r12,[r14],#1
						STRB r11,[r14],#1
						STRB r10,[r14],#1
						STRB r9,[r14],#1
						STRB r8,[r14],#1
						STRB r7,[r14],#1
						STRB r6,[r14],#1
						STRB r5,[r14],#1
						STRB r4,[r14],#1
						STRB r3,[r14],#1
						STRB r2,[r14],#1
						STRB r1,[r14],#1
						STRB r0,[r14],#1
				
				BX LR
				
				ENDP
					
Literal_Pool	PROC
				LDR r0,=Values
				LDR r1,=stored_values
				MOV r12,r0
				
loop			LDRH r3,[r0],#2 ; Since it is post_indexed the address of the literal pool is always rewritten after we use and then we perform the addition.
				LDRH r4,[r0],#2
				ADD  r5,r3,r4
				STR	 r5,[r1],#4
				SUBS r11,r0,r12
				CMP r11,#16 ; see the difference between the beggining of the literal pool and the end if we have an offset of 16 to get out of the loop.
				BNE loop
					
				
stop			B	stop;
Values			DCW 57721,56649, 15328,60606, 51209, 8240, 24310, 42159;

				ENDP
					

UADD8_M3		PROC
	
				MOV32 r0,#0x7A30458D
				MOV32 r1,#0xC3159EAA
				MOV   r12,#4
				MOV   r11,#0xFF ; This is the mask that we are going to use.
						
Check_1		AND r3,r0,r11	; Keep only the HALFWORD (8 bits) 2 Hexadecimal values that you need.
				AND	r4,r1,r11	; Same as above
				ADD r5,r5,r3	; Perform the addition
				ADD r5,r5,r4	; Perform the addition
				ADD r6,r6,r11	; We go from: 0xFF -> 0xFFFF -> 0xFFFFFF ...
				AND r5,r5,r6	; We only want to keep an even number of bytes and the carry goes.
				LSL r11,r11,#8	; We go from: 0xFF -> 0xFF00 -> 0xFF0000 ...
				SUBS r12,r12,#1	; Decrement r12
				CMP  r12,#0		; Compare r12 with 0.
				BNE Check_1
				
				BX LR
				
				ENDP

USAD8_M3		PROC
				
				MOV32 r0,#0x7A30458D
				MOV32 r1,#0xC3159EAA
				MOV	r11,#0xFF
				
				
Check_2			AND r2,r0,r11 ; When you mask with 0xFF you will keep the last two bytes and put to 0 everything else.
				AND r3,r1,r11 ; For example: 0xFF for r1 -> 0xAA for the first iteration. 
				CMP r2,r3
				ITE GE		;If then else with greater or equal
				SUBGE r4,r2,r3	;Substract if r2>r3
				SUBLT r4,r3,r2	; substract if r2<r3
				ADD r5,r5,r4
				LSR r0,r0,#8 ;I need to shift right the values to be able to add them.
				LSR r1,r1,#8 ; I need to shift right the values to be able to add them
				CMP r0,#0; Jump out the loop when r0 is empty after I do all the right shifts it will get to 0.
				BNE Check_2
				
				BX LR
				
				
				ENDP
					
SMUAD_SMUSD_M3	PROC
				
				MOV32 r0,#0x7A30458D
				MOV32 r1,#0xC3159EAA
				MOV32 r11,#0xFFFF0000 ; The mask to get the upper the 4 bytes of r0,r1.
				
Check_3			AND r3,r0,r11 ;Getting the upper halfword of r0.
				AND r4,r1,r11 ;Getting the upper halfword of r1.
				LSR r3,r3,#16 ;Shift right the value of r3 so now it is represented in the Least Significant bits (LSB).
				LSR r4,r4,#16 ; Shift right the value of r3 so now it is represented in the Least Significant 4 bits (LSB).
				ADD r4,r4,r11 ; Adding the mask to the upper-part of r4 to change it into its two's compliment.
				MUL r5,r3,r4  ; Multiply the two values.
				ADD r6,r6,r5  ; this performs the SMUAD (which is the addition of the two values by multiplying the two values in upper and lower bits).
				SUB r7,r5,r7  ; Performing the substraction between the two values obtained by the two multiplications. 
				LSL r0,r0,#16 ; Getting the LSBs in r0 and r1 to be in the uppermost so we can perform the same thing on it.
				LSL r1,r1,#16
				CMP r0,#0	  ; When r0 becomes zero that means I have passed through all the values possible.
				BNE Check_3
				
		
	
	
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
