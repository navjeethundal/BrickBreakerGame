
.global UpdatePowerUp1
@ Update the power up 1
UpdatePowerUp1:

	mov fp, sp
	sub sp, #16
	
	ldr r0, =powerUp1Delay
	ldr r1, [r0]
	add r1, #1
	str r1, [r0]
	cmp r1, #6
	blt dontUpdate

	
	ldr r0, =powerUp1
	ldr r1, =array2Dmap
	ldr r3, [r0, #16]
	ldr r4, [r0, #4]
	cmp r3, #1
	cmpne r4, #1
	movne r2, #1
	strne r2, [r0]
	mov r3, #88
	str r3, [r0, #12]
	



	ldr r2, [r0, #8] @power up location
	mov r3, #0
	str r3, [r1, r2] @make current location 0

	ldr r3, [r0, #12]
	add r2, r3       @ power up future location

	ldr r4, [r1, r2] @ 

	
	cmp r4, #0
	streq r2, [r0, #8]
	moveq r5, #1
	streq r5, [r1, r2]
	
	cmp r4, #-1
	moveq r5, #1
	streq r5, [r0, #16]
	moveq r5, #0
	streq r5, [r0, #12]
	
  		
	ldreq r3, [r0, #8]
	streq r5, [r1, r3]
	moveq r7, #0
	streq r7, [r0]
	

	


	cmp r4, #4
	moveq r5, #1
	streq r5, [r0, #4]
	moveq r5, #0
	streq r5, [r0, #12]
	moveq r7, #0
	streq r7, [r0]
	
	ldreq r5, [r0, #8]
	addeq r5, #176
	streq r5, [r0, #8]
	push { lr }
	bleq updateScore
	pop { lr }




	cmp r4, #5
	moveq r5, #1
	streq r5, [r0, #4]
	moveq r5, #0
	streq r5, [r0, #12]
	moveq r7, #0
	streq r7, [r0]

	ldreq r5, [r0, #8]
	addeq r5, #176
	streq r5, [r0, #8]
	push { lr }
	bleq updateScore
	pop { lr }

	cmp r4, #6
	moveq r5, #1
	streq r5, [r0, #4]
	moveq r5, #0
	streq r5, [r0, #12]
	moveq r7, #0
	streq r7, [r0]

	ldreq r5, [r0, #8]
	addeq r5, #176
	streq r5, [r0, #8]
	push { lr }
	bleq updateScore
	pop { lr }

	ldr r0, =powerUp1Delay
	mov r1, #0
	str r1, [r0]

@ call if update not needed
dontUpdate:

	add sp, #16
	bx lr

@ update power up 2
.global updatePowerUp2
updatePowerUp2:

	mov fp, sp
	sub sp, #16
	
	ldr r0, =powerUp1Delay
	ldr r1, [r0]
	add r1, #1
	str r1, [r0]
	cmp r1, #6
	blt dontUpdates

	
	ldr r0, =powerUp2
	ldr r1, =array2Dmap
	ldr r3, [r0, #16]
	ldr r4, [r0, #4]
	cmp r3, #1
	cmpne r4, #1
	movne r2, #1
	strne r2, [r0]
	mov r3, #88
	str r3, [r0, #12]
	



	ldr r2, [r0, #8] @power up location
	mov r3, #0
	str r3, [r1, r2] @make current location 0

	ldr r3, [r0, #12]
	add r2, r3       @ power up future location

	ldr r4, [r1, r2] @ 

	
	cmp r4, #0
	streq r2, [r0, #8]
	moveq r5, #2
	streq r5, [r1, r2]
	
	cmp r4, #-1
	moveq r5, #1
	streq r5, [r0, #16]
	moveq r5, #0
	streq r5, [r0, #12]
	
  		
	ldreq r3, [r0, #8]
	streq r5, [r1, r3]
	moveq r7, #0
	streq r7, [r0]
	

	


	cmp r4, #4
	moveq r5, #1
	streq r5, [r0, #4]
	moveq r5, #0
	streq r5, [r0, #12]
	moveq r7, #0
	streq r7, [r0]
	
	ldreq r5, [r0, #8]
	addeq r5, #176
	streq r5, [r0, #8]
	push { lr }
	bleq updateScore
	pop { lr }




	cmp r4, #5
	moveq r5, #1
	streq r5, [r0, #4]
	moveq r5, #0
	streq r5, [r0, #12]
	moveq r7, #0
	streq r7, [r0]

	ldreq r5, [r0, #8]
	addeq r5, #176
	streq r5, [r0, #8]
	push { lr }
	bleq updateScore
	pop { lr }

	cmp r4, #6
	moveq r5, #1
	streq r5, [r0, #4]
	moveq r5, #0
	streq r5, [r0, #12]
	moveq r7, #0
	streq r7, [r0]

	ldreq r5, [r0, #8]
	addeq r5, #176
	streq r5, [r0, #8]
	push { lr }
	bleq updateScore
	pop { lr }

	ldr r0, =powerUp1Delay
	mov r1, #0
	str r1, [r0]

@ dont update if not needed
dontUpdates:

	add sp, #16
	bx lr

@Ball movement
.global ballMovement
ballMovement:

	mov fp, sp
	sub sp, #16
	
	ldr r0, =powerUp1
	ldr r1, [r0, #4]
	cmp r1, #1
	beq doDelay
	

	
	
@ Updates ball	
ball:
	ldr r0, =ballObject
	ldr r1, [r0, #4]
	ldr r2, [r0, #8]
	ldr r3, [r0, #12]

	@clears ball's old spot
	ldr r4, =array2Dmap
	mov r5, #0
	cmp r1, #940
	strne r5, [r4, r1]
	
	@update ball's location
	add r6, r3, r2
	add r6, r6, r1
	str r6, [r0, #4]

	@add ball to map
	mov r5, #8
	cmp r6, #940 @+88
	strne r5, [r4, r6]

	ldr r0, =ballDelay
	mov r1, #0
	str r1, [r0]
	b delayAdded

@delays ball
doDelay:
	
	ldreq r2, =ballDelay
	ldreq r3, [r2]
	addeq r3, #1
	streq r3, [r2]
	cmpeq r3, #2
	beq ball
@ delay has been added
delayAdded:
	add sp, #16

	bx lr


@adds 1 to score	
.global updateScore
updateScore:
	mov fp, sp

	sub sp, #16

	ldr r5, =scoreDisplay
	ldr r4, [r5]
	ldr r6, [r5, #4]
	
	add r6, #1
	@str r6, [r5, #4]
	cmp r6,#70
	moveq r6, #60
	addeq r4, #1
	streq r4, [r5]
	streq r6, [r5, #4]

	str r6, [r5, #4]
	
	@update score
	ldr r0, =array2Dmap
	str r4, [r0, #168]
	str r6, [r0, #172]

	add sp, #16
	bx lr


@ check how many lives are left
.global checkLives
checkLives:
	mov fp, sp

	sub sp, #16

	ldr r0, =livesCounter
	ldr r1, [r0]
	ldr r2, =array2Dmap

	mov r3, #0
		

	cmp r1, #3
	streq r3, [r2, #96]
	
	cmp r1, #2
	streq r3, [r2, #92]

	cmp r1, #1
	streq r3, [r2, #88]

	sub r1, #1
	str r1, [r0]
		

	add sp, #16
	bx lr

@ restart game states

.global restartGame
restartGame:

	mov fp, sp
	sub sp, #16

	mov r2, #0
	mov r4, #2552
@ loop for restart
restartLoop:
	@ reset array2Dmap
	cmp r2, r4
	ldrlt r0, =array2Dinit
	ldrlt r1, =array2Dmap

	ldrlt r3, [r0, r2]
	strlt r3, [r1, r2]
	addlt r2, #4
	blt restartLoop


	ldr r0, =ballObject
	mov r2, #0
	str r2, [r0]
	str r2, [r0, #8]
	str r2, [r0, #12]
	mov r2, #2156
	str r2, [r0, #4]

	ldr r0, =paddleCoords
	mov r2, #2236
	str r2, [r0]
	mov r2, #2240
	str r2, [r0, #4]
	mov r2, #2244
	str r2, [r0, #8]
	mov r2, #2248
	str r2, [r0, #12]

	ldr r0, =scoreDisplay
	mov r1, #60
	str r1, [r0]
	str r1, [r0, #4]

	ldr r0, =score
	mov r1, #0
	str r1, [r0]

	ldr r0, =livesCounter
	mov r1, #3
	str r1, [r0]

	ldr r0, =powerUp1
	mov r1, #0
	str r1, [r0]
	str r1, [r0, #4]
	str r1, [r0, #12]
	str r1, [r0, #16]
	mov r1, #940
	str r1, [r0, #8]

	ldr r0, =powerUp2
	mov r1, #0
	str r1, [r0]
	str r1, [r0, #4]
	str r1, [r0, #12]
	str r1, [r0, #16]
	mov r1, #900
	str r1, [r0, #8]

	ldr r0, =powerUp1Delay
	ldr r1, [r0]
	mov r2, #0
	str r2, [r0]

	ldr r0, = ballDelay
	ldr r1, [r0]
	mov r2, #0
	str r2, [r0]
	




	add sp, #16

	bx lr


