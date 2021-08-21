@ Code section
.section .text

.global main
main:
	@ ask for frame buffer information
	ldr 		r0, =frameBufferInfo 	@ frame buffer information structure
	bl		initFbInfo

	@ load the base adress of gpio then store into gBaseArray
	ldr r7, =gBaseArray
	bl getGpioPtr
	str r0, [r7]

	mov r0, #9   			@ line number for Latch		
	mov r1, #1   			@ function code (output)
	bl Init_GPIO 			@ function call
	
	mov r0, #10  			@ line number for Data
	mov r1, #0   			@ function code (input)
	bl Init_GPIO

	mov r0, #11  			@ line number for Clock
	mov r1, #1   			@ function code (output)
	bl Init_GPIO			@ call to Init_GPIO function 




@ Loop for Main Menu State

@ Loop for the main menu
menuLoop:

	ldr r0, =brickWallGone
	mov r1, #0
	str r1, [r0]

	

	@ delay for 40000 microseconds to get 25 fps ~~
	mov r0, #40000
	bl delayMicroseconds

	@ draw current menu
	bl menuDraw

	@ get SNES input
	bl Read_SNES

	@ get current menu state
	ldr r8, =menuState
	ldr r9, [r8]

	@ Inputs for menu Start State
	cmp r9, #0
	moveq r10, #0b1111111011111111 @aPressed goes to gameState
	cmpeq r0, r10 
	beq initGrid
	cmp r9, #0
	moveq r10, #0b1111111111011111 @downPad changes menu State to quit
	cmpeq r0, r10
	moveq r0, #1
	bleq changeMenu

	@ Inputs for menu quit State
	cmp r9, #1
	moveq r10, #0b1111111011111111 @aPressed quits game
	cmpeq r0, r10 
	beq next
	cmp r9, #1
	moveq r10, #0b1111111111101111 @upPad changes menu State to Start
	cmpeq r0, r10
	moveq r0, #0
	bleq changeMenu
	
	b menuLoop
	

@ initialize grid	
initGrid:
	
	
	bl drawCells

@ handles frame rate
frames:

	@Delay for frames per seconds
	mov r0, #40000
	bl delayMicroseconds
	

@ Check the ball collisions	

checkCollision:
	
	@Get ball's future location
	ldr r0, =ballObject
	ldr r1, [r0, #4]
	ldr r2, [r0, #8]
	ldr r3, [r0, #12]
	
	add r4, r1, r3	@y movement
	add r6, r1, r2	@x movement
	add r10, r2, r3
	add r10, r1	@diagonal movment

	
	
	ldr r5, =array2Dmap
	ldr r7, [r5, r4]@vert
	ldr r8, [r5, r6]@horz
	ldr r10, [r5, r10]@diagonal
	
	
	
	
	cmp r8, #10
	bleq sideWallCollision
	cmp r8, #10
	beq checkCollision

	cmp r7, #15
	bleq TopWallCollision
	cmp r7, #15
	beq checkCollision

	cmp r7,#5
	bleq innerPaddleCollision
	cmp r7,#5
	beq checkCollision

	cmp r7, #4
	bleq outerPaddleCollision
	cmp r7, #4
	beq checkCollision

	cmp r7, #6
	bleq outerPaddleCollision
	cmp r7, #6
	beq checkCollision

	
	
	

	

	cmp r7, #101
	bleq greenRightVerticalCollision
	cmp r7, #101
	beq checkCollision

	cmp r7, #100
	bleq greenLeftVerticalCollision
	cmp r7, #100
	beq checkCollision

	cmp r8, #100
	bleq greenLeftHorizontalCollision
	cmp r8, #100
	beq checkCollision

	cmp r8, #101
	bleq greenRightHorizontalCollision
	cmp r8, #101
	beq checkCollision

	cmp r7, #200
	bleq orangeYellowLeftVerticalCollision
	cmp r7, #200
	beq checkCollision

	cmp r7, #201
	bleq orangeYellowRightVerticalCollision
	cmp r7, #201
	beq checkCollision

	mov r9, #300
	cmp r7, r9
	bleq orangeYellowLeftVerticalCollision
	cmp r7, r9
	beq checkCollision

	mov r9, #301
	cmp r7, r9
	bleq orangeYellowRightVerticalCollision
	cmp r7, r9
	beq checkCollision

	cmp r10, #100
	bleq greenLeftDiagonalCollision
	cmp r10, #100
	beq checkCollision

	cmp r10, #101
	bleq greenRightDiagonalCollision
	cmp r10, #101
	beq checkCollision

	cmp r10, #200
	bleq orangeYellowLeftDiagonalCollision
	cmp r10, #200
	beq checkCollision

	cmp r10, #201
	bleq orangeYellowRightDiagonalCollision
	cmp r10, #201
	beq checkCollision

	mov r9, #300
	cmp r10, r9
	bleq orangeYellowLeftDiagonalCollision
	cmp r10, r9
	beq checkCollision

	mov r9, #301
	cmp r10, r9
	bleq orangeYellowRightDiagonalCollision
	cmp r10, r9
	beq checkCollision

	cmp r10, #4
	bleq paddleDiagonalCollision
	cmp r10, #4
	beq checkCollision

	cmp r10, #5
	bleq paddleDiagonalCollision
	cmp r10, #5
	beq checkCollision

	cmp r10, #6
	bleq paddleDiagonalCollision
	cmp r10, #6
	beq checkCollision	

	cmp r7, #-1
	bleq voidCollision


		
	
	@check no lives left
	ldr r0, =livesCounter
	ldr r1, [r0]
	cmp r1, #0
	bleq restartGame
	beq gameOverLoop

	@check win condition
	mov r5, #616
	ldr r0, =array2Dmap

@ Checks if you won
checkWin:
	

	ldr r1, [r0, r5]

	cmp r1, #10
	bne checkBrick
	beq loopBack

@Check if its a brick
checkBrick:
	cmp r1, #0
	bne notWon

@ Iterate loop
loopBack:
	add r5, #4

	cmp r5, #876
	ldrle r8, =brickWallGone
	movle r7, #1
	strle r7, [r8]
	blt checkWin
	bleq restartGame
	beq gameOverLoop
	
	
@ did not win
notWon:

	ldr r8, =brickWallGone
	mov r7, #0
	str r7, [r8]

	bl ballMovement
	

	ldr r0, =array2Dmap
	mov r1, #852
	ldr r2, [r0, r1]
	cmp r2, #0
	bleq UpdatePowerUp1
	
	ldr r0, =array2Dmap
	mov r1, #812
	ldr r2, [r0, r1]
	cmp r2, #0
	bleq updatePowerUp2
	

	



	
	
	


	


@ gets Userinput while in gameState
userInput:
	bl Read_SNES

	moveq r10, #0b1111111111110111  @start Pressed goes to pause menu State
	cmp r0, r10
	moveq r9, #1
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r9, #1
	beq pauseMenuLoop
	
	mov r10, #0b1111111110111111 	@leftPad Pressed
	cmp r0, r10
	beq paddleMoveLeft		@ Change the values of the paddle to make it move left	



	mov r10, #0b1111111010111111    @leftPad + a
	cmp r0, r10
	moveq r5, #1
	ldreq r6, =holdingA
	streq r5, [r6]
	beq paddleMoveLeft		@ Change the values of the paddle to make it move left	


	mov r10, #0b1111111101111111 	@rightPad Pressed
	cmp r0, r10
	beq paddleMoveRight

	mov r10, #0b1111111001111111    @rightPad + a
	cmp r0, r10
	moveq r5, #1
	ldreq r6, =holdingA
	streq r5, [r6]
	beq paddleMoveRight		@ Change the values of the paddle to make it move right

	@ get the ball object and if the ball hasn't been launched, then launch the ball
	ldr r1, =ballObject
	ldr r1, [r1]
	cmp r1, #0
	moveq r10, #0b1111111111111110 @bPressed
	cmp r0, r10
	beq bPress

	


	bl drawCells @ branch to draw cells
	b frames

@ b was pressed
bPress:
	@Update ball launched to true (1)
	cmpeq r0, r10
	ldreq r1, =ballObject
	moveq r2, #1
	streq r2, [r1]

	@Set Ball movement vector
	ldr r1, =ballObject
	mov r2, #4
	mov r3, #-88
	str r2, [r1, #8]
	str r3, [r1, #12]

	b userInput
	

@ change values then draw
paddleMoveLeft:
	bl moveLeft
	bl drawCells
	b frames

@ change values then draw
paddleMoveRight:
	bl moveRight
	bl drawCells
	b frames



@ loop for the pause menu
pauseMenuLoop:

	@ delay for 40000 microseconds to get 25 fps ~~
	mov r0, #40000
	bl delayMicroseconds

	@ draw current menu
	bl pauseMenuDraw

	@ get SNES input
	bl Read_SNES

	@ get current menu state
	ldr r8, =pauseMenuState
	ldr r9, [r8]

	@ Inputs for pause menu Restart State
	cmp r9, #0
	moveq r10, #0b1111111111110111 @start Pressed resumes Game
	cmpeq r0, r10
	moveq r0, #0
	bleq changePause
	beq frames

	cmp r9, #0
	moveq r10, #0b1111111011111111 @aPressed restarts game
	cmpeq r0, r10 
	bleq restartGame
	beq initGrid

	cmp r9, #0
	moveq r10, #0b1111111111011111 @downPad changes pause menu State to quit
	cmpeq r0, r10
	moveq r0, #1
	bleq changePause

	@ Inputs for pause menu Quit State

	cmp r9, #1
	moveq r10, #0b1111111111110111 @start Pressed resumes Game
	cmpeq r0, r10
	moveq r0, #0
	bleq changePause
	beq frames

	cmp r9, #1
	moveq r10, #0b1111111011111111 @aPressed quits game
	cmpeq r0, r10
	moveq r5, #1
	bleq restartGame
	cmp r5, #1 
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #1
	beq menuLoop
	cmp r9, #1
	moveq r10, #0b1111111111101111 @upPad changes pause menu State to Restart
	cmpeq r0, r10
	moveq r0, #0
	bleq changePause
	
	b pauseMenuLoop

@loop for the game over
gameOverLoop:

	@ delay for 40000 microseconds to get 25 fps ~~
	mov r0, #40000
	bl delayMicroseconds

	@ draw current menu
	bl GameOverDraw

	@ get SNES input
	bl Read_SNES

	
	
	mov r10, #0b1111111111111110 	@ move number of B being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop
	


	mov r10, #0b1111111111111101 	@ move number of Y being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop


	mov r10, #0b1111111111111011 	@ move number of select being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop

	
	mov r10, #0b1111111111110111 	@ move number of start being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop


	mov r10, #0b1111111111101111 	@ move number of Up Pad being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop

	
	mov r10, #0b1111111111011111 	@ move number of Down Pad being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop

	mov r10, #0b1111111110111111 	@ move number of Left Pad  being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop
	


	mov r10, #0b1111111101111111 	@ move number of Right Pad being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop


	mov r10, #0b1111111011111111 	@ move number of A being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop

	
	mov r10, #0b1111110111111111 	@ move number of X being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop


	mov r10, #0b1111101111111111 	@ move number of left trigger being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop

	
	mov r10, #0b1111011111111111 	@ move number of right trigger being pressed to r10
	cmp r0, r10
	moveq r5, #0
	moveq r0, #0x40000
	bleq delayMicroseconds
	cmp r5, #0
	beq menuLoop

	

	
	
	b gameOverLoop
	
@ end program	
next:
	ldr r0, =arrayScreen
	ldr r1, =quitScreen
	bl draw
	
	@ stop
	haltLoop$:
		b	haltLoop$

@Change the pause state
changePause:
	mov fp, sp
	sub sp, #8


	ldr r1, =pauseMenuState
	str r0, [r1]


	add sp, #8

	bx lr	

@ change the menu state
changeMenu:

	mov fp, sp
	sub sp, #8


	ldr r1, =menuState
	str r0, [r1]


	add sp, #8

	bx lr

@move paddle left
moveLeft:
	mov fp, sp
	sub sp, #16

movingLeft:

	ldr r3, =holdingA
	ldr r4, [r3]
	cmp r4, #0
	bne updatePaddleLeft
	
	ldreq r0, =moveDelay
	ldreq r1, [r0]
	addeq r1, #1
	streq r1, [r0]
	cmpeq r1, #2
	blt outOfLeft
	moveq r2, #0
	streq r2, [r0]

	


updatePaddleLeft:	
	ldr r1, =paddleCoords
	ldr r2, [r1]
	mov r3, #2204
	cmp r2, r3
	ble outOfLeft
	
	ldr r2, =array2Dmap
	ldr r3, =paddleCoords

	ldr r1, =ballObject
	ldr r8, [r1]
	cmp r8, #0
	ldreq r4, [r1, #4]
	moveq r5, #0
	streq r5, [r2, r4]
	subeq r4, #4
	moveq r5, #8
	streq r5, [r2, r4]
	streq r4, [r1, #4]

	ldr r4, [r3]
	ldr r5, [r3, #4]	
	ldr r6, [r3, #8]
	ldr r7, [r3, #12]

	mov r1, #0
	str r1, [r2, r4]
	str r1, [r2, r5]
	str r1, [r2, r6]
	str r1, [r2, r7]

	sub r4, #4
	sub r5, #4
	sub r6, #4
	sub r7, #4

	mov r1, #4
	str r1, [r2, r4]
	str r4, [r3] 
	mov r1, #5
	str r1, [r2, r5]
	str r1, [r2, r6]
	str r5, [r3, #4]
	str r6, [r3, #8]
	mov r1, #6
	str r1, [r2, r7]
	str r7, [r3, #12]

@ end left
outOfLeft:

	ldr r0, =holdingA
	@ldr r1, [r0]
	mov r2, #0
	str r2, [r0]

	add sp, #16

	bx lr






@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@




@move the paddle right
moveRight:
	mov fp, sp
	sub sp, #16

movingRight:

	ldr r3, =holdingA
	ldr r4, [r3]
	cmp r4, #0
	bne updatePaddleRight
	
	ldreq r0, =moveDelay
	ldreq r1, [r0]
	addeq r1, #1
	streq r1, [r0]
	cmpeq r1, #2
	blt outOfRight
	moveq r2, #0
	streq r2, [r0]
	
	

updatePaddleRight:
	ldr r1, =paddleCoords
	ldr r2, [r1]
	mov r3, #2268
	cmp r2, r3
	bge outOfRight


	ldr r2, =array2Dmap
	ldr r3, =paddleCoords

	ldr r1, =ballObject
	ldr r8, [r1]
	cmp r8, #0
	ldreq r4, [r1, #4]
	moveq r5, #0
	streq r5, [r2, r4]
	addeq r4, #4
	moveq r5, #8
	streq r5, [r2, r4]
	streq r4, [r1, #4]


	ldr r4, [r3]
	ldr r5, [r3, #4]	
	ldr r6, [r3, #8]
	ldr r7, [r3, #12]

	mov r1, #0
	str r1, [r2, r4]
	str r1, [r2, r5]
	str r1, [r2, r6]
	str r1, [r2, r7]

	add r4, #4
	add r5, #4
	add r6, #4
	add r7, #4

	mov r1, #4
	str r1, [r2, r4]
	str r4, [r3] 
	mov r1, #5
	str r1, [r2, r5]
	str r1, [r2, r6]
	str r5, [r3, #4]
	str r6, [r3, #8]
	mov r1, #6
	str r1, [r2, r7]
	str r7, [r3, #12]

@Exit the move right subroutine	
outOfRight:
	ldr r0, =holdingA
	@ldr r1, [r0]
	mov r2, #0
	str r2, [r0]

	
	

	add sp, #16

	bx lr


	

	

@Handle if ball hits the void
voidCollision:

	mov fp, sp
	sub sp, #16

	@clear ball from map
	ldr r0, =ballObject
	ldr r1, =array2Dmap
	ldr r2, [r0, #4]
	mov r6, #0
	str r6, [r1, r2]

	@clear paddle from map
	ldr r0, =paddleCoords
	ldr r2, [r0]
	str r6, [r1, r2]
	add r2, #4
	str r6, [r1, r2]
	add r2, #4
	str r6, [r1, r2]
	add r2, #4
	str r6, [r1, r2]

		

	@reset ball
	ldr r0, =ballObject	
	mov r1, #0
	str r1, [r0]
	str r1, [r0, #8]
	str r1, [r0, #12]
	mov r1, #2156
	str r1, [r0, #4]

	@reset paddle
	ldr r0, = paddleCoords
	mov r1, #2236
	str r1, [r0]
	mov r2, #2240
	str r2, [r0, #4]
	mov r3, #2244
	str r3, [r0, #8]
	mov r4, #2248
	str r4, [r0, #12]

	ldr r0, =array2Dmap
	mov r5, #4
	str r5, [r0, r1]
	mov r5, #5
	str r5, [r0, r2]
	mov r5, #5
	str r5, [r0, r3]
	mov r5, #6
	str r5, [r0, r4]
	
	push { lr }
	bl checkLives
	pop { lr }
	
	
	


	add sp, #16
	
	bx lr
	
@Handles if ball hits the side walls
sideWallCollision:

	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #8]
	mvn r1, r1
	add r1, #1
	str r1, [r0, #8]

	add sp, #16
	
	bx lr

@Handles if ball hits the top wall	
TopWallCollision:

	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #12]
	mvn r1, r1
	add r1, #1
	str r1, [r0, #12]

	add sp, #16
	
	bx lr

@Handles if the ball hits the inside of the paddle	
innerPaddleCollision:
	
	mov fp, sp
	sub sp, #16

checkCaughtFlagInner:
	ldr r0, =powerUp2
	ldr r1, [r0,#4]
	cmp r1, #1
	beq catchballInner 	
	
	ldr r0, =ballObject
	ldr r1, [r0, #12]
	mvn r1, r1
	add r1, #1
	str r1, [r0, #12]
	b endPaddleInner
	

catchballInner:
	ldr r0, =ballObject
	ldr r3, [r0, #4]
	mov r2, #0
	str r2, [r0]
	str r2, [r0, #8]
	str r2, [r0, #12]
	mov r2, r3
	str r2, [r0, #4]

	
	



endPaddleInner:

	add sp, #16
	
	bx lr

@handles if the ball hits the outside of the paddle	
outerPaddleCollision:
	
	mov fp, sp
	sub sp, #16

checkCaughtFlagOuter:
	ldr r0, =powerUp2
	ldr r1, [r0, #4]
	cmp r1, #1
	beq catchballOuter 	
	
	ldr r0, =ballObject
	ldr r1, [r0, #12]
	mvn r1, r1
	add r1, #1
	str r1, [r0, #12]
	b endPaddleOuter

catchballOuter:
	ldr r0, =ballObject
	ldr r3, [r0, #4]
	mov r2, #0
	str r2, [r0]
	str r2, [r0, #8]
	str r2, [r0, #12]
	mov r2, r3
	str r2, [r0, #4]
	



endPaddleOuter:

	add sp, #16
	
	bx lr	

@ handles if the ball hits the right side of an orange or yellow brick verticaly 
orangeYellowRightVerticalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #12]
	mov r5, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #12]

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	add r3, r5
	ldr r4, [r2, r3]
	sub r4, #100
	str r4, [r2, r3]
	sub r3, #4
	ldr r4, [r2, r3]
	sub r4, #100
	str r4, [r2, r3]

	

	push { lr }
	bl updateScore
	pop { lr }
	
	add sp, #16
	
	bx lr	

@ handles if the ball hits the left side of an orange or yellow brick verticaly 	
orangeYellowLeftVerticalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #12]
	mov r5, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #12]	

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	add r3, r5
	ldr r4, [r2, r3]
	sub r4, #100
	str r4, [r2, r3]
	add r3, #4
	ldr r4, [r2, r3]
	sub r4, #100
	str r4, [r2, r3]



	push { lr }
	bl updateScore
	pop { lr }

	


	add sp, #16
	
	bx lr	

@ handles if the ball hits the right side of an green brick verticaly 
greenRightVerticalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #12]
	mov r5, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #12]

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	mov r4, #0
	add r3, r5
	str r4, [r2, r3]
	sub r3, #4
	str r4, [r2, r3]


	push { lr }
	bl updateScore
	pop { lr }

	

	
	add sp, #16
	
	bx lr	

@ handles if the ball hits the left side of an orange or yellow brick verticaly 
greenLeftVerticalCollision:
	
	mov fp, sp
	sub sp, #16

	@change ball's direction
	ldr r0, =ballObject
	ldr r1, [r0, #12]
	mov r5, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #12]	

	@ delete the hit brick
	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	mov r4, #0
	add r3, r5
	str r4, [r2, r3]
	add r3, #4
	str r4, [r2, r3]


	
	push { lr }
	bl updateScore
	pop { lr }




	add sp, #16
	
	bx lr	

@ handles if the ball hits the right side of an green brick horizontally
greenRightHorizontalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #8]
	mov r5, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #8]

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	mov r4, #0
	add r3, r5
	str r4, [r2, r3]
	sub r3, #4
	str r4, [r2, r3]

	push { lr }
	bl updateScore
	pop { lr }


	

	add sp, #16
	
	bx lr	

@ handles if the ball hits the right side of an green brick horizontally 
greenLeftHorizontalCollision:
	
	mov fp, sp 		@ move fp to sp
	sub sp, #16		@ get 4 local variables

	@ Gets the ball object then negate the x direction  

	ldr r0, =ballObject	
	ldr r1, [r0, #8]	
	mov r5, r1		
	mvn r1, r1		
	add r1, #1		
	str r1, [r0, #8]	

	@ Gets the map and then deletes the brick that was hit

	ldr r2, =array2Dmap	
	ldr r3, [r0, #4]	
	mov r4, #0		
	add r3, r5		
	str r4, [r2, r3]	
	add r3, #4		
	str r4, [r2, r3]

	push { lr }
	bl updateScore
	pop { lr }



	add sp, #16		
	
	bx lr			@ return to caller

@ handles if the ball hits the right side of a green brick diagonally 	
greenRightDiagonalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #8]
	ldr r6, [r0, #12]
	add r5, r6, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #8]

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	mov r4, #0
	add r3, r5
	str r4, [r2, r3]
	sub r3, #4
	str r4, [r2, r3]

	push { lr }
	bl updateScore
	pop { lr }



	
	add sp, #16
	
	bx lr	
@ handles if the ball hits the left side of a green brick diagonally 	
greenLeftDiagonalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #8]
	ldr r6, [r0, #12]
	add r5, r6, r1
	mov r5, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #8]

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	mov r4, #0
	add r3, r5
	str r4, [r2, r3]
	add r3, #4
	str r4, [r2, r3]

	push { lr }
	bl updateScore
	pop { lr }

	

	add sp, #16
	
	bx lr	

@ handles if the ball hits the left side of an orange or yellow brick diagonally 		
orangeYellowLeftDiagonalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #8]
	ldr r6, [r0, #12]
	ldr r7, [r0, #4]
	add r5, r6, r1
	add r5, r7, r5
	mov r8, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #8]

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	ldr r4, [r2, r5]
	sub r4, #100
	@add r3, r5
	str r4, [r2, r5]
	add r5, #4
	ldr r4, [r2, r5]
	sub r4, #100
	str r4, [r2, r5]

	push { lr }
	bl updateScore
	pop { lr }



	
	add sp, #16
	
	bx lr	

@ handles if the ball hits the right side of an orange or yellow brick diagonally 		
orangeYellowRightDiagonalCollision:
	
	mov fp, sp
	sub sp, #16

	
	ldr r0, =ballObject
	ldr r1, [r0, #8]
	ldr r6, [r0, #12]
	ldr r7, [r0, #4]
	add r5, r6, r1
	add r5, r7, r5
	mov r8, r1
	mvn r1, r1
	add r1, #1
	str r1, [r0, #8]

	ldr r2, =array2Dmap
	ldr r3, [r0, #4]
	ldr r4, [r2, r5]
	sub r4, #100
	@add r3, r5
	str r4, [r2, r5]
	sub r5, #4
	ldr r4, [r2, r5]
	sub r4, #100
	str r4, [r2, r5]

	push { lr }
	bl updateScore
	pop { lr }

	

	add sp, #16
	
	bx lr	

@ handles if the ball hits the paddle diagonally 		
paddleDiagonalCollision:
	
	mov fp, sp
	sub sp, #16

checkCaughtFlag:
	ldr r0, =powerUp2
	ldr r1, [r0,#4]
	cmp r1, #1
	beq catchball 	

	ldr r0, =ballObject
	ldr r1, [r0, #8]
	ldr r6, [r0, #12] 
	add r5, r6, r1
	mov r5, r6
	mvn r6, r6
	add r6, #1
	str r6, [r0, #12]
	b endPaddleDiagonal

catchball:

	ldr r5, =paddleCoords
	ldr r6, [r5,#8]
	sub r6, #88
	
	ldr r0, =ballObject
	ldr r3, [r0, #4]
	
	@clears ball's old spot
	ldr r4, =array2Dmap
	mov r5, #0
	str r5, [r4, r3]
	

	mov r2, #0
	str r2, [r0]
	str r2, [r0, #8]
	str r2, [r0, #12]
	mov r2, r6
	str r2, [r0, #4]

	
	



endPaddleDiagonal:

	add sp, #16
	
	bx lr	

@ draws the main menu
menuDraw:
	mov fp, sp
	sub sp, #16
	
	ldr r8, =menuState
	ldr r6, [r8]

	cmp r6, #0
	ldr r0, =arrayScreen
	ldreq r1, =mainMenuStart
	ldrne r1, =mainMenuQuit
	push { lr }
	bl draw
	pop { lr }

	add sp, #16

	bx lr

@ Draws the pause menu	
pauseMenuDraw:

	mov fp, sp
	sub sp, #16
	
	ldr r8, =pauseMenuState
	ldr r6, [r8]

	cmp r6, #0
	ldr r0, =arrayScreen
	ldreq r1, =pauseMenuRestart
	ldrne r1, =pauseMenuQuit
	push { lr }
	bl draw
	pop { lr }

	add sp, #16

	bx lr

@draws the game over screens	
GameOverDraw:

	mov fp, sp
	sub sp, #16
	
	
	ldr r2, =brickWallGone
	ldr r4, [r2]
	ldr r0, =arrayScreen
	cmp r4, #1
	ldrne r1, =GameOverScreen
	ldreq r1, =winScreen	


	push { lr }
	bl draw
	pop { lr }

	add sp, #16

	bx lr
	
@draw the cells of the screen
drawCells:

	mov fp, sp
	sub sp, #16	

@ Loop for the draw	
drawCellsLoop:
	@ 
	ldr r5, =cellIndex
	ldr r6, [r5]
	ldr r7, =array2Dmap
	ldr r0, =cellArray
	ldr r2, [r7, r6]

	


	cmp r2, #1
	ldreq r4, =powerUp1
	ldreq r3, [r4]
	cmp r3, #1
	ldreq r1, =powerUpLeft
	ldrne r1, =gameBackground
	

	cmp r2, #2
	ldreq r4, =powerUp2
	ldreq r3, [r4]
	cmp r3, #1
	ldreq r1, =powerUpLeft
	ldrne r1, =gameBackground
	 
	

	cmp r2, #300
	ldreq r1, =orangeBrickLeft

	mov r3, #301
	cmp r2, r3
	ldreq r1, =orangeBrickRight
	cmp r2, #200
	ldreq r1, =yellowBrickLeft
	cmp r2, #201
	ldreq r1, =yellowBrickRight
	cmp r2, #100
	ldreq r1, =greenBrickLeft
	cmp r2, #101
	ldreq r1, =greenBrickRight

	cmp r2, #8
	ldreq r1, =ball

	cmp r2, #5
	ldreq r1, =paddleInner
	cmp r2, #4
	ldreq r1, =paddleOuterLeft
	cmp r2, #6
	ldreq r1, =paddleOuterRight

	cmp r2, #10
	ldreq r1, =wallSide
	cmp r2, #15
	ldreq r1, =wallTop
	cmp r2, #20
	ldreq r1, =wallCornerLeft
	cmp r2, #25
	ldreq r1, =wallCornerRight

	cmp r2, #0
	ldreq r1, =gameBackground
	cmp r2, #-1
	ldreq r1, =gameBackground

	cmp r2, #40
	ldreq r1, =livesLeft
	cmp r2 , #45
	ldreq r1, =livesRight

	cmp r2, #50
	ldreq r1, =scoreLeft
	cmp r2, #55
	ldreq r1, =scoreRight

	cmp r2, #60
	ldreq r1, =num0
	cmp r2, #61
	ldreq r1, =num1
	cmp r2, #62
	ldreq r1, =num2
	cmp r2, #63
	ldreq r1, =num3	
	cmp r2, #64
	ldreq r1, =num4
	cmp r2, #65
	ldreq r1, =num5
	cmp r2, #66
	ldreq r1, =num6
	cmp r2, #67
	ldreq r1, =num7
	cmp r2, #68
	ldreq r1, =num8
	cmp r2, #69
	ldreq r1, =num9

	


	
	




	push { lr }
	bl draw
	pop { lr }

	ldr r0, =cellArray
	ldr r1, [r0]
	add r1, #32
	str r1, [r0]

	ldr r5, =cellIndex
	ldr r6, [r5]
	add r6, #4
	ldr r7, [r5, #4]
	
	
	


	cmp r6, r7
	ldreq r0, =cellArray
	ldreq r1, [r0, #4]
	addeq r1, #32
	streq r1, [r0, #4]
	moveq r1, #608
	streq r1, [r0]
	addeq r7, #88
	streq r7, [r5, #4]


	mov r8, #2552
	cmp r6, r8
	str r6, [r5]
	movge r6, #0
	strge r6, [r5]
	ldreq r0, =cellArray
	moveq r1, #608
	moveq r2, #50
	streq r1, [r0]
	streq r2, [r0, #4]



	
	blt drawCellsLoop

	ldr r3, =cellIndex
	mov r4, #0
	str r4, [r3]
	mov r4, #88
	str r4, [r3, #4]

	add sp, #16

	bx lr








@ Data section
.section .data

@ index of cell
cellIndex:
.word 0, 88

@ dimensions of the screen
cellArray:
.word 608, 50, 32, 32

@background = 0
@wall = 1
@orange = 30
@yellow = 20
@green = 10
@end = 2
@middle = 3
@ball = 5

@object for ball
.global ballObject
ballObject:
.word 0, 2156, 0, 0


@paddleCoords
.global paddleCoords
paddleCoords:
.word 2236, 2240, 2244, 2248

@initial map
.global array2Dinit
array2Dinit:
.word 40, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 50, 55, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 60, 60, 20, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 25, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 10, 10, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 10, 10, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 10, 10, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 6, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ,-1, -1, -1, -1, 10

@ game map
.global array2Dmap
array2Dmap:
.word 40, 45, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 50, 55, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 60, 60, 20, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 25, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 300, 301, 10, 10, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 200, 201, 10, 10, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 100, 101, 10, 10, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 4, 5, 5, 6, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 10, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 ,-1, -1, -1, -1, 10

@ lives
.global livesCounter
livesCounter:
.word 3

@score
.global score
score:
.word 0

@score to be displayed
.global scoreDisplay
scoreDisplay:
.word 60, 60

.global brickWallGone
brickWallGone:
.word 0

@ index of brick
arrayBrickIndex:
.word 0 

@ Array of the box
.global arrayBox
arrayBox:
.word 656, 882, 8, 8

@ array for test
.global arrayTest
arrayTest:
.word 656, 882, 160, 32

@ Array for paddle
.global arrayPaddle
arrayPaddle:
.word 650, 750, 100, 30

@ array for brick health
arrayBrickHealth:
.word 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2 ,2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

@Array for brick placement
arrayBrickPlace:
.word 405, 400, 55, 20

@ powerUp1 object
.global powerUp1
powerUp1:
.word 0,0,940, 88, 0 

@powerUp2 object
.global powerUp2
powerUp2:
.word 0,0,900, 88, 0

@delay for power up droping
.global powerUp1Delay
powerUp1Delay:
.word 0

@delay for ball
.global ballDelay
ballDelay:
.word 0

@ flag for main menu
menuState:
.word 0

@ flag for pause menu
pauseMenuState:
.word 0

.global holdingA
holdingA:
.word 0

.global moveDelay
moveDelay:
.word 0

@ gBaseArrays
.global gBaseArray
gBaseArray:
.word	0
