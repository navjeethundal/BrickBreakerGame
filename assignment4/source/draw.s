
@ Code section
.section .text



.global draw
draw:

	mov fp, sp
	sub sp, #16

loopFill:

	ldr r4, [r0,#0] @get the starting x
	ldr r5, [r0,#4] @get the starting y
	ldr r6, [r0, #8] @get width
	ldr r7, [r0, #12] @get height
	add r6, r6, r4
	add r7, r7, r5
	mov r8, r1 @get color
	mov r9, #0
	mov r10, r4

drawLoopGameBackground:

	mov r0, r4
	mov r1, r5	
	cmp r4, r6
	bge nextLine
	ldr r2, [r8,r9]
	push { lr }
	bl	DrawPixel
	pop { lr }
	add r4, #1
	add r9, #4
	b drawLoopGameBackground

nextLine:
	add r5, r5, #1
	cmp r5, r7
	beq endss
	
	mov r4, r10
	b drawLoopGameBackground

endss:	add sp, #16

	bx lr



@ Draw Pixel
@  r0 - x
@  r1 - y
@  r2 - colour

DrawPixel:
	push		{r4, r5}

	offset		.req	r4

	ldr		r5, =frameBufferInfo	

	@ offset = (y * width) + x
	
	ldr		r3, [r5, #4]		@ r3 = width
	mul		r1, r3
	add		offset,	r0, r1
	
	@ offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
	lsl		offset, #2

	@ store the colour (word) at frame buffer pointer + offset
	ldr		r0, [r5]		@ r0 = frame buffer pointer
	str		r2, [r0, offset]

	pop		{r4, r5}
	bx		lr




@ Data section
.section .data


.global arrayScreen
arrayScreen:
.word 608, 50, 704, 928


.align
.globl frameBufferInfo
frameBufferInfo:
	.int	0		@ frame buffer pointer
	.int	928		@ screen width
	.int	704		@ screen height
