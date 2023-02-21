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
myspace			SPACE	26
				
				AREA    |.EXERCISE_3|,DATA,READWRITE
mydataspace		SPACE	16

                AREA    |.text|, CODE, READONLY
				
; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler   [WEAK]
					
				;BL Exercice_1
				;BL Exercice_2
				;BL Exercice_2_1
				;BL Exercice_3
				;BL Exercice_4_1
				;BL Exercice_4_2
				BL Exercice_4_3
		
                ENDP
					
single_value RN r1
double_value RN r2
triple_value RN r3
quadruple_value RN r4
quintuple_value RN r5

Exercice_1   	PROC 
				
				MOV single_value,#1
				MOV double_value,single_value,LSL #1; shifting left the single value will multiply it by 2.
				ADD triple_value,double_value,single_value ; adding the double value and the single value it's like multiplying by 3.
				MOV quadruple_value,single_value,LSL #2 ; shifting left the single value 2 times is like multiplying by 4.
				ADD quintuple_value,quadruple_value,single_value; adding the quadruple value and the single value is like multiplying by 5.

				BX LR
				
				ENDP
				
				

					
Exercice_2      PROC
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

Exercice_2_1    PROC
				LDR r14,=myspace
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
					
Exercice_3		PROC
				LDR r0,=myConstants
				LDR r1,=mydataspace
				MOV r12,#4
				
loop			LDRH r3,[r0],#2
				LDRH r4,[r0],#2
				ADD  r5,r3,r4
				STR	 r5,[r1],#4
				SUBS r12,r12,#1
				BNE loop
					
				
stop			B	stop;
myConstants 	DCW 57721,56649, 15328,60606, 51209, 8240, 24310, 42159;

				ENDP
					

Exercice_4_1	PROC
	
				MOV32 r0,#0x7A30458D
				MOV32 r1,#0xC3159EAA
				MOV   r12,#4
				MOV   r11,#0xFF ; This is the mask that we are going to use.
						
UADD8_M3		AND r3,r0,r11	; Keep only the HALFWORD (8 bits) 2 Hexadecimal values that you need.
				AND	r4,r1,r11	; Same as above
				ADD r5,r5,r3	; Perform the addition
				ADD r5,r5,r4	; Perform the addition
				ADD r6,r6,r11	; We go from: 0xFF -> 0xFFFF -> 0xFFFFFF ...
				AND r5,r5,r6	; We only want to keep an even number of bytes and the carry goes.
				LSL r11,r11,#8	; We go from: 0xFF -> 0xFF00 -> 0xFF0000 ...
				SUBS r12,r12,#1	; Decrement r12
				CMP  r12,#0		; Compare r12 with 0.
				BNE UADD8_M3
				
				BX LR
				
				ENDP

Exercice_4_2	PROC
				
				MOV32 r0,#0x7A30458D
				MOV32 r1,#0xC3159EAA
				MOV	r11,#0xFF
				MOV r12,#4
				
USAD8_M3		AND r2,r0,r11
				AND r3,r1,r11
				CMP r2,r3
				ITE GE
				SUBGE r4,r2,r3
				SUBLT r4,r3,r2
				ADD r5,r5,r4
				LSR r0,r0,#8 ;I need to shift right the values to be able to add them.
				LSR r1,r1,#8 ; I need to shift right the values to be able to add them
				SUBS r12,r12,#1
				CMP r12,#0
				BNE USAD8_M3
				
				BX LR
				
				
				ENDP
					
Exercice_4_3	PROC
				
				MOV32 r0,#0x7A30458D
				MOV32 r1,#0xC3159EAA
				MOV32 r11,#0xFFFF
				MOV r12,#2
				
SMUAD_SMUSD_M3	AND r3,r0,r11
				AND r4,r1,r11
				LSL r4,r4,#16
				ASR r4,r4,#16
				MUL r5,r3,r4
				ADD r6,r6,r5
				SUB r7,r5,r7
				LSR r0,r0,#16
				LSR r1,r1,#16
				SUBS r12,r12,#1
				CMP r12,#0
				BNE SMUAD_SMUSD_M3
				
				

				
				
	
	
	
	
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
