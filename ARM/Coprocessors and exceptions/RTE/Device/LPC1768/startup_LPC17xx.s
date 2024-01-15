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

SystemHandlerControlRegister EQU 0xE000ED24
UsageFaultStatusRegister EQU 0xE000ED2A
	
                AREA    |.text|, CODE, READONLY


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
					
			
				; enabling the user fault handler
				LDR r0,=SystemHandlerControlRegister
				LDR r1, [r0]
				ORR r1,#0x40000
				STR r1,[r0]
				
				; initialize the coprocessor
				CDP p0,#1,c3,c1,c2,#1
				
				MOV r4,#1
				
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
				
				; step 1 ~ recognizing coprocessor fault
				LDR r2,=UsageFaultStatusRegister
				LDRH r3, [r2]
				TEQ r3, #8
				BEQ coprocessor_usage_fault
				BNE other_usage_fault
				
; step 2 ~ recognizing offending instruction

coprocessor_usage_fault       TST LR, #0x4
							  ITE EQ
							  MRSEQ r2, MSP
							  MRSNE r2, PSP
							  LDR r3, [r2,#24]
							  LDR r1, [r3]
							  ROR r1,r1,#16
							  AND r0, r1, #0x0E100000
							  BEQ continue
							  BNE other_usage_fault
							  ; step 3 ~ changing return address
continue					  ADD r3,r3,#0x4
							  STR r3, [r2,#24]
							  
							  ; step 4 ~ accessing source registers
							  ;Op1 is bits 16-19 #0x000F0000, instruction still in r1
							  AND r3, r1, #0x000F0000
							  ROR r3, #16 ; Roll right r3 by 16 bits to get the number of register for op1, this is the integer part
							  LSL r3, #2 ; This is now the offset for the register in the stack
							  LDR r4, [SP, r3] ; r4 now holds content of op1 (integer part)
							  ;Op2 is bits 0-3 #0x0000000F
							  AND r3, r1, #0x0000000F
							  LSL r3, #2; offset in the stack
							  LDR r5, [SP, r3] ; r5 now holds content of op2 (fractional part)
							  
							  ; exponent calculation 
							  ; step 5 ~ calculate the result
							  AND r3, r1, #2_00000000000000000000000000010000
							  ROR r3, #4; r3 is now the value of the sign bit
				              MOV r7, r3; r7 holds the sign bit
							  
							  ;Use r3 as counter, rotate left through integer part until you find a 1, decrementing the counter each time, counter is the number of first bit set to 1
							  LDR r3, =32; Set to 32 to start (32 bits)
exponentLoop				  SUB r3, #1;
							  ;maybe check here if r3 is less than 0 and break out, should throw an error or something?
							  LSLS r4, r4, #1; move bit 31 into carry flag
							  BCC exponentLoop ; Branch to the loop if the carry flag does not hold a 1.
							  ADD r8, r3, #127 ; r8 holds E = index + 127
							  LDR r9, =23;
							  sub r9, r3 ; r9 holds N (number of remaining bits to fill with fractional part)
				
							  ;Mantissa calculation
							  LDR r10, =0; initialise r10 to 0 to store mantissa
				              ;X is fractional part in r5, P is lowest power of 10 higher than X 
							  ; start at P = 10, check P > X, if not times 10 again and continue till P > X
							  LDR r3, =1; start P at 1
							  
							  LDR r11, =10;
pLoop						  MUL r3, r11; 
							  CMP r3, r5;
							  BLS pLoop; If r3 less than r5 (P < X) keep looping, P finishes in r3
							  
							  
							  ;Mantissa loop, counter is r9 (N)
mantissaLoop				  LSL r10, #1 ; Shift left to go to next bit (first shift doesn't matter since all zeros)
							  LSL r5, #1; X is doubled
							  CMP r5, r3; compare X and P
							  ITT HS ; If X >= P
							  ADDHS r10, r10, #1 ;set bit to 1
							  SUBHS r5, r3; X = X-P
							  SUB r9, #1; reduce counter
							  CMP r9, #0;
							  BHI mantissaLoop; loop until N doesn to 0, Mantissa stored in r10
				
							  ;Storing result in destination register, use r11 for result first, then put in stack
							  LSL r11, r7, #31; Sign bit to most significant bit of result
							  LSL r8, #23; Exponent in bits 30 - 23 
							  ADD r11, r8; add exponent to result register
							  
						      ;Need to roll back r4 to start at bit 22 (the first bits of the mantissa)
							  ROR r4, #9;	 r4 in msbs, roll 9 to go from 31 to 22
							  ADD r11, r4; add to result
							  ADD r11, r10; add rest of mantissa, result now fully in r11
				
							  ;Store in dest register on stack
							  ;Dest register is bits 15-12 #0x0000F000 of instruction in r2
							  AND r3, r1, #0x0000F000
							  ROR r3, #12 ; roll right to get register
							  LSL r3, #2 ; offset in the stack
							  STR r11, [SP, r3] ; Result now in stack in place of destination register
				
							  ;Return
							  POP{r4, r5, r6, r7, r8, r9, r10, r11}
							 
							  BX LR
							  
									  
							
				
other_usage_fault B       .
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
