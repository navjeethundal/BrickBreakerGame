@ name: Navjeet Hundal   ID: 30004202
@ name: Jeff Datahan 	 ID: 30005464
@ name: Jaydon Fernandes ID: 30022052
@ this program is a snes controller driver 

@ Code section
.section .text


.global driver
driver:
	
	ldr	r0, =creators 		@ loads creators names into r0
	bl	printf			@ call printf function
	gBase .req r5			@ set gBase to r5
	bl getGpioPtr			@ call to getGpioPtr function
	mov gBase, r0			@ move r0 into gBase
	
	mov r0, #9   			@ line number for Latch		
	mov r1, #1   			@ function code (output)
	bl Init_GPIO 			@ function call
	
	mov r0, #10  			@ line number for Data
	mov r1, #0   			@ function code (input)
	bl Init_GPIO

	mov r0, #11  			@ line number for Clock
	mov r1, #1   			@ function code (output)
	bl Init_GPIO			@ call to Init_GPIO function 

	mov r4, #0			@ move 0 into r4
	ldr	r0, =promptPress 	@load promptPress
	bl	printf 			@ print String

tLoop:
	bl Read_SNES 			@call Read_SNES function
	mov r9, r0 			@ move the register of inputs to r9

	cmp r4, #1			@ Check if a button is still being pressed
	beq check			@ branches to check if a button is still being pressed

	mov r10, #0b1111111111111110 	@ move number of B being pressed to r10
	cmp r9, r10 			@ check if B has been pressed
	beq bPressed 			@ branch to bPressed if B was presses

	mov r10, #0b1111111111111101 	@ move number of Y being pressed to r10
	cmp r9, r10 			@ check if Y has been pressed
	beq yPressed 			@ branch to yPressed if Y was pressed

	mov r10, #0b1111111111111011 	@ move number of select being pressed to r10
	cmp r9, r10 			@ check if select has been pressed
	beq selectPressed		@ branch to tLoop if button pressed state = select button pressed

	mov r10, #0b1111111111110111 	@ move number of start being pressed to r10
	cmp r9, r10 			@ check if start has been pressed
	beq end				@ branches to end if start was pressed

	mov r10, #0b1111111111101111 	@ move number of Up Pad being pressed to r10
	cmp r9, r10 			@ check if Up Pad has been pressed
	beq upPadPressed		@ branch to upPadPressed if button pressed state = Up Pad pressed

	mov r10, #0b1111111111011111 	@ move number of Down Pad being pressed to r10
	cmp r9, r10 			@ check if Down Pad has been pressed
	beq downPadPressed		@ branch to downPadPressed if button pressed state = Down Pad  pressed

	mov r10, #0b1111111110111111 	@ move number of Left Pad  being pressed to r10
	cmp r9, r10 			@ check if Left Pad has been pressed
	beq leftPadPressed		@ branch to leftPadPressed if button pressed state = Left Pad pressed

	mov r10, #0b1111111101111111 	@ move number of Right Pad being pressed to r10
	cmp r9, r10 			@ check if Right Pad has been pressed
	beq rightPadPressed		@ branch to rightPadPressed if button pressed state = Right Pad pressed

	mov r10, #0b1111111011111111 	@ move number of A being pressed to r10
	cmp r9, r10 			@ check if A has been pressed
	beq aPressed 			@ branch to aPressed if button pressed state = A button pressed

	mov r10, #0b1111110111111111 	@ move number of X being pressed to r10
	cmp r9, r10 			@ check if X has been pressed
	beq xPressed 			@ branch to xPressed if button pressed state = X button pressed

	mov r10, #0b1111101111111111 	@ move number of left trigger being pressed to r10
	cmp r9, r10 			@ check if left trigger has been pressed
	beq leftTriggerPressed      	@ branch to leftTriggerPressed if button pressed state = left trigger pressed

	mov r10, #0b1111011111111111 	@ move number of right trigger being pressed to r10
	cmp r9, r10 			@ check if right trigger  has been pressed
	beq rightTriggerPressed		@ branch to rightTriggerPressed if button pressed state = right trigger

check:	mov r10, #0b1111111111111111	@ move number of no button being pressed to r10
	cmp r9, r10 			@ check if nothing has been pressed
	moveq r4, #0			@ move 0 in r4
	beq tLoop			@ branch to tLoop if button pressed state = no button pressed

	mov r10, #0
	cmp r9, r10
	beq tLoop


bPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =bButton	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

yPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =yButton	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

selectPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =selectButton	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

upPadPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =joypadUP	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

downPadPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =joypadDOWN	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

leftPadPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =joypadLEFT	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

rightPadPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =joypadRIGHT	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

aPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =aButton	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

xPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =xButton	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop 

leftTriggerPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =left 	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop

rightTriggerPressed:
	cmp r4, #0		 @ compare to check if button is being pressed
	moveq r4, #1		 @ moves 1 into r4 if button is pressed
	ldreq r0, =right	 @ load button action if the button was pressed
	bleq printf		 @ function call to printf
	ldreq	r0, =promptPress @ load promptPress
	bleq	printf 		 @ print String

	ldr r0, =0x5555555	 @ loads the delay time (approximately 1 second) to r0 
	bl delay$		 @ branch link to delay$

	b tLoop		 	 @ Branch to tLoop

	
 
end:	ldr	r0, =terminate	 @ loads the terminating message
	bl	printf		 @ branch links to the print function 

	haltLoop$:
		b haltLoop$	 @ Infinite loop for program end

.global Init_GPIO		 @ Make Init_GPIO visible to system
Init_GPIO:

	mov fp, sp		@ mov stack pointer to frame pointer
	sub sp, #12		@ creates three local variables

	ldr r6, =gBaseArray
	ldr gBase, [r6]

	cmp r0, #10		@ compares GPIO pin number to 0
	blt Latch		@ if r0 < 10 then branch to Latch
	beq Data		@ if r0 = 10 then branch to Data
	bgt Clock		@ if r0 > 10 branch to Clock



Latch:	ldr	r0, [gBase]	@ loads GPIO base address to r0
	mov	r2, #0b111	@ moves 7 into r2
	bic	r0, r2, lsl #27	@ bit clear pin 9 bits
	
	orr	r0, r1, lsl #27 @ set pin 9 function in r0
	str	r0, [gBase]	@ write back to GPFSEL0

	b ret			@ branch to ret

	
Clock:	ldr 	r0, [gBase, #0x4]	@ loads address for GPFSEL1 to r0
	mov	r2, #0b111		@ Moves 7 into r2
	bic	r0, r2, lsl #3		@ bit clear pin 11 bits

	orr	r0, r1, lsl #3		@ set pin 11 function in r0
	str	r0, [gBase, #0x4]	@ write back to GPFSEL1

	b ret				@ branch to ret

Data:	ldr	r0, [gBase, #0x4]	@ loads address for GPFSEL1 to r0
	mov	r2, #0b111		@ Moves 7 into r2
	bic	r0, r2			@ bit clear pin 10 bits

	orr	r0, r1			@ set pin 10 function in r0
	str	r0, [gBase, #0x4]	@ write back to GPFSEL1


ret:	add sp, #12			@ removes three local vaiables from stack 
	mov pc, lr			@ return to function 

.global Write_Latch
Write_Latch:
	mov fp, sp			@ move sp to fp 
	sub sp, #12			@ adds three local variables 

	ldr r6, =gBaseArray
	ldr gBase, [r6]

	mov r2, #1			@ move 1 into r2
	lsl r2, #9			@ logical shift left by 9 and then store into r9
	teq r0, #0			@ test eq if r0 is equal to 0
	streq r2, [gBase, #40] 		@ GPCLR0
	strne r2, [gBase, #28]		@ GPSET0
	
	add sp, #12			@ remove three local variables 

	mov pc, lr			@ return to function 

.global Write_Clock
Write_Clock:

	mov fp, sp			@ move sp to fp
	sub sp, #12			@ adds three local variables 

	ldr r6, =gBaseArray
	ldr gBase, [r6]

	mov r2, #1			@ move 1 into r2
	lsl r2, #11			@ logical shift left by 11 then store into r2
	teq r0, #0			@ test eq r0 by 0
	streq r2, [gBase, #40]		@ GPCLR0
	strne r2, [gBase, #28]		@ GPSET0

	add sp, #12			@ removes three local variables 

	mov pc, lr			@ return to function 

.global Read_Data
Read_Data:
	mov fp, sp			@ move sp to fp
	sub sp, #12			@ adds three local variables

	ldr r6, =gBaseArray
	ldr gBase, [r6]

	ldr r1, [gBase, #52]		@ loads the address of GPLEVO to r1
	mov r2, #1			@ moves 1 into r2
	lsl r2, #10 			@ logical shift left r2 by 10 bits
	and r1, r2			@ AND r1 and r2
	teq r1, #0			@ test equalls r0 and #0
	moveq r0, #0			@ moves 0 into r0 if r0 = 0
	movne r0, #1			@ move 0 into r0 if not equal

	add sp, #12			@ remove three local variables 
	mov pc, lr			@ return to function

.global Read_SNES
Read_SNES:
	mov fp, sp			@ move sp to fp
	sub sp, #16			@ adds three local variables 
	i .req r8			@ setting i as r8 

reset:	
	mov r7, #0			@ move 0 into r7

	mov r0, #1			@ move 1 into r0
	push	{ lr }			@ push lr
	bl	Write_Clock		@ call Write_Clock function 
	pop	{ lr }			@ pop lr

	mov r0, #1			@ move 1 into r0
	push	{ lr }			@ push lr
	bl	Write_Latch		@ call to Write_Latch function
	pop	{ lr }			@ pop lr
	
	mov r0, #12			@ move 12 into r0
	push	{ lr }			@ push lr
	bl	delayMicroseconds	@ go to delayMicroseconds
	pop	{ lr }			@ pop lr 

	mov r0, #0			@ move 0 into r0
	push	{ lr }			@ push lr
	bl	Write_Latch		@ call to Write_Latch function
	pop	{ lr }			@ pop lr

	mov i, #0 			@ mov 0 into i(r8)
	
pulseLoop:

	

	mov r0, #6			@ move 6 into r0
	push	{ lr }			@ push lr
	bl	delayMicroseconds	@ call to delayMicroseconds function
	pop	{ lr }			@ pop lr

	mov r0, #0			@ move 0 into r0
	push	{ lr }			@ push lr
	bl	Write_Clock		@ call Write_Clock function 
	pop	{ lr }			@ pop lr

	mov r0, #6			@ move 6 into r0
	push	{ lr }			@ push lr
	bl	delayMicroseconds	@ call delayMicroseconds
	pop	{ lr }			@ pop lr 


	push	{ lr }			@ push lr
	bl	Read_Data		@ call Read_Data
	pop	{ lr }			@ pop lr

	cmp r0, #1			@ compare r0 with 1
	moveq r3, #1			@ if equal move 1 into r3
	lsleq r2, r3, i 		@ if equal logical shift left r3 by i then store into r2
	addeq r7, r2 			@ if equal add r7 by r2

	
	mov r0, #1			@ move 1 into r0
	push	{ lr }			@ push lr
	bl	Write_Clock		@ call Write_Clock
	pop	{ lr }			@ pop lr


	add i, #1			@ increase i by 1

	cmp i, #16			@ compare i with 16
	blt pulseLoop			@ if less than go to pulseLoop




leave:
	mov r0, r7			@ mov r7 into r0

	add sp, #16			@ add four local variables

	mov pc, lr			@ return to function 

.global delay$
delay$:
	subs r0, #1			@ subtract and set flags r0 by 1
	bne delay$			@ if not equal go to delay$
	bx lr				@ return to function 
	
	



@ Data section
.section .data

creators:
.asciz	"Created by: Jeff Datahan, Navjeet Hundal and Jaydon Fernandes\n\n"	@ name string

promptPress:
.asciz	"Please press a button...\n\n"						@ prompt string 

terminate:
.asciz	"Program is terminating...\n\n"						@ terminate string

bButton:
.asciz	"You have pressed B \n\n"						@ b button string

yButton:
.asciz	"You have pressed Y \n\n"						@ y button string

selectButton:
.asciz	"You have pressed Select \n\n"						@ select button string

joypadUP:
.asciz	"You have pressed Joy-pad UP \n\n"					@ up-pad string

joypadDOWN:
.asciz	"You have pressed Joy-pad DOWN \n\n"					@ down-pad string

joypadLEFT:
.asciz	"You have pressed Joy-pad LEFT \n\n"					@ left-pad  string

joypadRIGHT:
.asciz	"You have pressed Joy-pad RIGHT \n\n"					@ right-pad string

aButton:
.asciz	"You have pressed A \n\n"						@ a button string

xButton:
.asciz	"You have pressed X \n\n"						@ x button string

left:
.asciz	"You have pressed LEFT \n\n"						@ left button string

right:		
.asciz	"You have pressed RIGHT \n\n"						@ right button string
