#####################################################################
#
# CSCB58 Fall 2020 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Luoliang Cai, 1006156703
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Scoreboard
# 2. Platforms shrink as player reaches certain scores (Dynamic difficulty)
# 3. Moving Enemies
# 4. Shield
# 5. Fragilish blocks	(blocks that degrade slowly as doodle lands on it)
# 6. Game Over and start screens that display high score in addition to cool graphics 
# 7.Dynamic messages as user reaches certain levels
#
# Link to video demonstration for final submission:
#   Demo1
# - https://play.library.utoronto.ca/74a9a3495f3b0a43fb8354c6d2026e5f
#   Demo2
# - https://play.library.utoronto.ca/593db12f2651648c376520393983774d (In this version I do not explain anything and I just try to show the features I implemented)
#   In the second version the bug in the first version is fixed
#
# Any additional information that the TA needs to know:
# - Score board only goes up to 9999
# - Bug occurs when holding down key so don't do it
# - Using the s key during game over screen will cause game go pass the start screen immediately in first
#   iteration of loop which makes it seem like the start was skipped
# - In the demo video I found a small bug where the enemy would glitch and get stuck on the right edge
#   and I fixed that later on after I had filmed the demo
#####################################################################

.data
	displayAddress:	.word	0x10008000
	#Colour array
	colours: .word 0xff0000, 0xadff2f, 0x019920, 0xffffff, 0x000000, 0x000055, 0x000099, 0x0000ff , 0x30d5c8, 0xffff00
	#Store values of the platforms as follows : x coordinate, size, type
	platform_top: .word	0, 40, 4, 2048
	platform_middle: .word  0, 40, 4, 4096
	platform_bottom: .word  0, 40, 4, 6144
	#store information for the enemies (location - 1000 indicates they do not exists  ,
	# movement direction)
	enemy1: .word	1000, 0
	enemy2: .word	1000, 0
	enemy3: .word	1000, 0
	
	#stores the remaining durations of shield and the location of the shield on the platform 
	#if it is on the screen. (1000 indicates shield is not on the screen), and the level it is on
	shield: .word	0 , 1000, 1920
	
	#THe following dictate how each number, letter or exclamation point should be printed on a 5 x 3 grid
	# The first number is the top left cell, the third is the top right and the last one is bottom right
	# 1 represents the the cell should be filled and 0 indicates it should not	
	
	#Letters
	A: .word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1
	C: .word 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1
	D: .word 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0
	E: .word 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1
	G: .word 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1
	I: .word 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0
	J: .word 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1
	L: .word 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1
	M: .word 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1
	N: .word 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1
	O: .word 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1
	P: .word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0
	R: .word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1
	S: .word 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1
	T: .word 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0
	U: .word 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1
	V: .word 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0
	W: .word 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1
	Y: .word 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0
	
	#Numbers
	Two: .word 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1
	Three: .word 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1
	Four: .word 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1
	Six: .word 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1
	Seven: .word 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1
	Eight: .word 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1
	Nine: .word 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1
	
	#Punctuation
	Colon: .word 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0
	Exclamation: .word 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0
.text

#Start screen that repeatedly prompts user to press s to start
Start:
	# $s0 stores the base address for display
	lw $s0, displayAddress	
	li $t4, 0x000000
	li $t5, 0x00ff00
	
	jal erase
	
	#Print Doodle Jump
	addi $a1, $t5, 0
	addi $a0, $s0, 1300
	la $a3, D
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, O
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, O
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, D
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, L
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, E
	jal Print_Letter
	subi $a0, $a0, 96
	addi $a0, $a0, 800
	la $a3, J
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, U
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, M
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, P
	jal Print_Letter
	
	#Draw the doodle character
	subi $a0, $a0, 48
	addi $a0, $a0, 1036
	jal Print_doodle
	
	#Loop which repeatedly prompts the user to press s key to start
	#Also constantly changes the colouring of Press S To Start to make it look
	#like words are flashing on the screen
	Start_loop:	
	addi $a1, $t4, 0
	addi $a0, $s0, 5512
	la $a3, P
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, R
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, E
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, S
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, S
	jal Print_Letter
	addi $a0, $a0, 32
	la $a3, S
	jal Print_Letter
	subi $a0, $a0, 96
	addi $a0, $a0, 764
	la $a3, T
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, O
	jal Print_Letter
	addi $a0, $a0, 28
	la $a3, S
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, T
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, A
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, R
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, T
	jal Print_Letter

	blt $t4, 0x00ff00, next
	li $t4, 0x000000
	
	next:
	addi $t4, $t4, 0x001100
	li $a0, 100
	jal Sleep
	
	lw $t3, 0xffff0000 	
	beq $t3, 0, Start_loop
	lw $t3, 0xffff0004 
	beq $t3, 0x73, Initialize
	j Start_loop

#initialize values 
Initialize:
	#erase the start screen
	jal erase
	
	#initialize shield values
	sw $zero, shield
	li $t0, 1000
	sw $t0, shield + 4
	li $t0, 1920
	sw $t0, shield + 8
	
	#load the movement direction of creature
	li $t0, 1000
	sw $t0, enemy1
	sw $t0, enemy2
	sw $t0, enemy3
	
	#load the creature locations
	sw $zero, enemy1 + 4
	sw $zero, enemy2 + 4
	sw $zero, enemy3 + 4
	
	#initialize size of platforms
	li $t2, 40
	
	#set initial sizes and types for platforms
	li $t0, 4
	sw $t0, platform_top + 8
	sw $t0, platform_middle + 8
	sw $t0, platform_bottom + 8

	sw $t2, platform_top + 4
	sw $t2, platform_middle + 4
	sw $t2, platform_bottom + 4
	
	li $t0, 2048
	sw $t0, platform_top + 12
	li $t0, 4096
	sw $t0, platform_middle + 12
	li $t0, 6144
	sw $t0, platform_bottom + 12
	
	#set the initial location of the top platform
	move $a1, $t2
	jal Random
	move $t0, $a0
	mul $t0, $t0, 4
	sw $t0, platform_top
	
	#set the initial location of the middle platform
	move $a1, $t2
	jal Random
	move $t0, $a0
	mul $t0, $t0, 4
	sw $t0, platform_middle
	
	#set the initial position of the bottom platform , It always starts in the middle
	addi $t0, $zero, 56
	sw $t0, platform_bottom
	
	#initialize start location of the doodle
	addi $t7, $s0, 6080
	
	#initialize $t6 so doodle initially moves upwards
	li $t6, -128
	
	#initialize score to 0
	li $t1, 0

#draw items on the screen
Main_Loop:
	#print  dark green platforms
	lw $t0, colours + 8
	lw $t3, platform_top + 8
	bgt $t3, 3, next2
	mul $t3, $t3, 4
	addi $t3, $t3, 16 
	lw $t0, colours($t3)
	next2:
	lw $t4, platform_top
	lw $t3, platform_top + 4
	lw $t8, platform_top + 12
	add $t5, $s0, $t8
	add $t5, $t5, $t4
	add $t4, $t5, $t3
	draw_top:
	beq $t5, $t4, draw_middle
	sw $t0, 0($t5)	
	addi $t5, $t5, 4
	j draw_top	
	draw_middle:
	lw $t0, colours + 8
	lw $t3, platform_middle + 8
	bgt $t3, 3, next3 
	mul $t3, $t3, 4
	addi $t3, $t3, 16 
	lw $t0, colours($t3)
	next3:	
	lw $t4, platform_middle
	lw $t3, platform_middle + 4
	lw $t8, platform_middle + 12
	add $t5, $s0, $t8
	add $t5, $t5, $t4
	add $t4, $t5, $t3
	draw_middle_loop:
	beq $t5, $t4, draw_bottom
	sw $t0, 0($t5)
	addi $t5, $t5, 4	
	j draw_middle_loop	
	draw_bottom:
	lw $t0, colours + 8
	lw $t3, platform_bottom + 8 
	bgt $t3, 3, next4
	mul $t3, $t3, 4
	addi $t3, $t3, 16 
	lw $t0, colours($t3)
	next4:
	lw $t4, platform_bottom
	lw $t3, platform_bottom + 4
	lw $t8, platform_bottom + 12
	add $t5, $s0, $t8
	add $t5, $t5, $t4
	add $t4, $t5, $t3
	draw_bottom_loop:
	beq $t5, $t4, Draw_enemy
	sw $t0, 0($t5)	
	addi $t5, $t5, 4
	j draw_bottom_loop
	
	#draw red enemies
	Draw_enemy:
	lw $t0, colours
	Draw_enemy1:
	lw $t4, enemy1
	beq $t4, 1000, Draw_enemy2
	addi $t5, $s0, 5120
	add $t5, $t5, $t4
	sw $t0, 0($t5)
	sw $t0, 4($t5)
	sw $t0, 128($t5)
	sw $t0, 132($t5)	
	Draw_enemy2:
	lw $t4, enemy2
	beq $t4, 1000, Draw_enemy3
	addi $t5, $s0, 3072
	add $t5, $t5, $t4
	sw $t0, 0($t5)
	sw $t0, 4($t5)
	sw $t0, 128($t5)
	sw $t0, 132($t5)	
	Draw_enemy3:
	lw $t4, enemy3
	beq $t4, 1000, Draw_doodle
	addi $t5, $s0, 1024
	add $t5, $t5, $t4
	sw $t0, 0($t5)
	sw $t0, 4($t5)
	sw $t0, 128($t5)
	sw $t0, 132($t5)
	
	#print green doddle
	Draw_doodle:
	li $t0, 4
	lw $t0, colours($t0)	
	sw $t0, ($t7) 
	
	#draw shield if the doddle currently has one
	lw $t3, shield
	blez $t3, Score
	Draw_shield:
	lw $t0, colours + 32
	sw $t0, -128($t7)
	sw $t0, -124($t7)
	sw $t0, -132($t7)
	sw $t0, -4($t7)
	sw $t0, 4($t7)
	sw $t0, 128($t7)
	sw $t0, 124($t7)
	sw $t0, 132($t7)
	
	#print out the score
	Score:
	move $a2, $t1
	addi $a0, $s0, 7456
	li $t0, 12
	lw $a1 colours($t0)
	jal Draw_Score
	
	#draw the shield item if one exists
	Shield_Item:
	lw $t0, colours + 32
	lw $t4, shield + 4
	beq $t4, 1000, Collision_with_bottom
	lw $t5, shield + 8
	add $t5, $t5, $t4
	add $t5, $t5, $s0
	sw $t0, 0($t5)
	
	#detect if doodle hit the bottom of the screen
	Collision_with_bottom:
	addi $t4, $s0, 6272
	bge $t7, $t4, Game_Over
	
	#detect if doodle has reached the apex of its jump, if it has change $t6 so it starts moving downward
	Collision_with_top:
	addi $t4, $s0, 2944
	bgt $t7, $t4, Collision_with_middle
	li $t6, 128
	
	#detect if doodle has landed on the middle platform
	Collision_with_middle:
	lw $t4, platform_middle
	lw $t3, platform_middle + 4
	lw $t8, platform_middle + 12
	subi $t8, $t8, 128
	add $t5, $s0, $t8
	add $t5, $t5, $t4
	add $t4, $t5, $t3
	blt $t7, $t5, Collision_with_bottom_platform
	bge $t7, $t4, Collision_with_bottom_platform
	j Reset
	
	#detect if doddle collided with the bottom pplatform
	Collision_with_bottom_platform:
	lw $t3, platform_bottom + 8
	#ignore collision if the platform identifier indicates the platform does not exist
	beqz $t3, Edge_collision1
	lw $t4, platform_bottom
	lw $t3, platform_bottom + 4
	lw $t8, platform_bottom + 12
	subi $t8, $t8, 128
	add $t5, $s0, $t8
	add $t5, $t5, $t4
	add $t4, $t5, $t3
	blt $t7, $t5, Edge_collision1
	bge $t7, $t4, Edge_collision1
	li $t6, -128
	lw $t3, platform_bottom + 8
	bgt $t3, 3, Edge_collision1
	subi $t3, $t3, 1
	sw $t3, platform_bottom + 8
	
	#Detect if the enemy has hit the sides of the map and adjust direction accordingly
	Edge_collision1:
	lw $t0, enemy1
	beq $t0, 1000, Edge_collision2
	blez $t0, change_direction1
	bge $t0, 120, change_direction1
	j Edge_collision2
	change_direction1:
	lw $t4, enemy1 + 4
	mul $t4, $t4, -1
	sw $t4, enemy1 + 4
	
	Edge_collision2:
	lw $t0, enemy2
	beq  $t0, 1000, Edge_collision3
	blez $t0, change_direction2
	bge  $t0, 120, change_direction2
	j Edge_collision3
	change_direction2:
	lw $t4, enemy2 + 4
	mul $t4, $t4, -1
	sw $t4, enemy2 + 4
	
	Edge_collision3:
	lw $t0, enemy3
	beq $t0, 1000, Collision_with_enemy
	blez $t0, change_direction3
	bge $t0, 120, change_direction3
	j Collision_with_enemy
	change_direction3:
	lw $t4, enemy3 + 4
	mul $t4, $t4, -1
	sw $t4, enemy3 + 4
	
	#detect collision with enemy
	Collision_with_enemy:
	#do not attempt to detect collision if shield is on
	lw $t0, shield
	bnez $t0, Detect_key_press
	
	#detect collision with bottom most enemy
	Collision_with_enemy1:
	lw $t0, enemy1
	beq $t0, 1000, Collision_with_enemy2
	add $t0, $t0, $s0
	addi $t0, $t0, 5120
	beq $t0, $t7, Game_Over
	addi $t0, $t0, 4
	beq $t0, $t7, Game_Over
	addi $t0, $t0, 124
	beq $t0, $t7, Game_Over
	addi $t0, $t0, 4
	beq $t0, $t7, Game_Over
	
	#detect collision with middle enemy
	Collision_with_enemy2:
	lw $t0, enemy2
	beq $t0, 1000, Shield_collision
	addi $t0, $t0, 3072
	add $t0, $t0, $s0
	beq $t0, $t7, Game_Over
	addi $t0, $t0, 4
	beq $t0, $t7, Game_Over
	addi $t0, $t0, 124
	beq $t0, $t7, Game_Over
	addi $t0, $t0, 4
	beq $t0, $t7, Game_Over
	
	#detect if doodle makes contact with the shield on the screen
	Shield_collision:
	lw $t4, shield + 4
	beq $t4, 1000, Detect_key_press
	lw $t5, shield + 8
	add $t5, $t5, $t4
	add $t5, $t5, $s0
	bne $t7, $t5, Detect_key_press
	li $t0 , 150
	sw $t0, shield
	li $t0 , 1000
	sw $t0, shield + 4
	
	#detect if key was pressed
	Detect_key_press:
	lw $t4, 0xffff0000 	
	beq $t4, 1, keyboard_input
	return:
	
	#wait 
	li $a0, 50
	jal Sleep
	
	#erase 
	lw $t5, shield
	beqz $t5, erase_doodle
	jal erase_shield
	erase_doodle:
	move $a0, $t7
	jal erase_lp
	
	#erase enemies
	lw $a0, enemy1
	beq $a0, 1000, erase_enemy2
	addi $a0, $a0, 5120
	add $a0, $a0, $s0
	jal erase_square
	
	erase_enemy2:
	lw $a0, enemy2
	beq $a0, 1000, erase_enemy3
	addi $a0, $a0, 3072
	add $a0, $a0, $s0
	jal erase_square
	
	erase_enemy3:
	lw $a0, enemy3
	beq $a0, 1000, Shift_doodle
	addi $a0, $a0, 1024
	add $a0, $a0, $s0
	jal erase_square
	
	#move doodle up or down
	Shift_doodle:
	add $t7, $t7, $t6
	
	#update location of enemies
	lw $t4, enemy1
	lw $t5, enemy1 + 4
	add $t4, $t4, $t5
	sw $t4, enemy1
	
	lw $t4, enemy2
	lw $t5, enemy2 + 4
	add $t4, $t4, $t5
	sw $t4, enemy2
	
	lw $t4, enemy3
	lw $t5, enemy3 + 4
	add $t4, $t4, $t5
	sw $t4, enemy3
	
	#update duration of shield left if there is any
	lw $t5, shield
	beqz $t5, No_shield
	subi $t5, $t5, 1
	bnez $t5, No_shield
	li $t4, 1000
	lw $t4, shield + 4
	No_shield:
	sw $t5, shield
	
	j Main_Loop

#erase the shield if the doodele has one
erase_shield:
	li $t0, 16
	lw $t0, colours($t0)
	sw $t0, -128($t7)
	sw $t0, -124($t7)
	sw $t0, -132($t7)
	sw $t0, -4($t7)
	sw $t0, 4($t7)
	sw $t0, 128($t7)
	sw $t0, 124($t7)
	sw $t0, 132($t7)
	jr $ra

#erase one point	
erase_lp:		
	lw $t0, colours + 16	
	move $t4, $a0
	sw $t0, ($t4)
	jr $ra

#erase a 2x2 square
erase_square:
	lw $t0, colours + 16
	move $t3, $a0
	sw $t0, ($t3)
	sw $t0, 4($t3)
	sw $t0, 128($t3)
	sw $t0, 132($t3)
	jr $ra

#erase the entire screen	
erase:
	lw $t0, colours + 16
	move $t3, $s0
	addi $t4, $s0, 8192
	erase_loop:
	bge $t3, $t4, end_erase
	sw $t0, 0($t3)
	addi $t3, $t3, 4
	j erase_loop
	end_erase:
	jr $ra
	
#Sleep
Sleep:
	li $v0, 32
	syscall
	jr $ra
	
#Change the location of each platform along with the doodle when it hits the middle platform. Only resets if doodle is moving 
#downward at time of impact
Reset:
	#does not reset any values if the doodle is moving upwards at point of collision
	beq $t6, -128, Collision_with_bottom_platform
	
	#Shift creature positions down
	lw $t0, enemy2
	sw $t0, enemy1
	lw $t0, enemy3
	sw $t0, enemy2
	li $t0, 1000
	sw $t0, enemy3
	
	#Shift creature directions down
	lw $t0, enemy2 + 4
	sw $t0, enemy1 + 4
	lw $t0, enemy3 + 4
	sw $t0, enemy2 + 4
	li $t0, 0
	sw $t0, enemy3 + 4
	
	#create a creature
	li $a1, 116
	jal Random3
	andi $t5, $a0, 3
	bnez  $t5, Change_score
	#
	#bug fix below
	#
	bnez $a0, nex
	li $a0, 4
	nex:
	sw $a0, enemy3
	li $t0, 4
	sw $t0, enemy3 + 4
	
	#increase score by 1
	Change_score:
	addi $t1, $t1, 1
	
	#skip any adjustment if score gets to 45 or above
	bge $t1, 40, Change_Platforms
	#adjust platform size
	div $t5, $t1, 5
	mul $t5, $t5, 4
	li $t4, 40
	sub $t4, $t4, $t5
	la $t2, ($t4)
	
	#shift platforms down	along with their sizes and id
	Change_Platforms:
	lw $t0, platform_middle
	sw $t0, platform_bottom
	lw $t0, platform_middle + 4
	sw $t0, platform_bottom + 4
	lw $t0, platform_middle + 8
	sw $t0, platform_bottom + 8
	
	lw $t0, platform_top
	sw $t0, platform_middle
	lw $t0, platform_top + 4
	sw $t0, platform_middle + 4
	lw $t0, platform_top + 8
	sw $t0, platform_middle + 8
	
	#create new top platform and set size and id
	sw $t2, platform_top + 4
	move $a1, $t2
	jal Random
	addi $t0, $a0, 0
	mul $t0, $t0, 4
	sw $t0, platform_top
	jal Random2
	sw $a0, platform_top + 8
	
	lw $t4, shield
	bnez $t4, Do_not_generate_shield
	lw $t4, shield + 4
	bne $t4, 1000, Do_not_generate_shield
	li $a1, 3
	jal Random3
	bne $a0, 1, Do_not_generate_shield
	li $t0, 1920
	sw $t0, shield + 8
	lw $zero, shield
	lw $t0, platform_top
	div $t4, $t2, 2
	#check if $t4 is still a multiple of 4
	andi $t5, $t4, 3
	beqz $t5, No_adjust
	subi $t4, $t4, 2
	No_adjust:
	add $t0, $t4, $t0
	sw $t0, shield + 4
	j Doodle_down
	
	Do_not_generate_shield:
	lw $t4, shield
	bnez $t4, Doodle_down
	lw $t4, shield + 8
	addi $t4, $t4, 2048
	sw $t4, shield + 8
	ble $t4, 6144, Doodle_down
	li $t5, 1000
	sw $t5, shield + 4
	
	#shift doodle down 
	Doodle_down:
	addi $t7, $t7, 2048
	
	#make it so doodle now goes up
	li $t6, -128
	
	#erase the entire screen (paint it black)
	addi $a0, $s0, 0
	jal erase
	
	#Dynamiclly print out on screen notifications
	bne $t1, 5, Yay
	lw $a1, colours + 36
	li, $a0, 24
	jal Print_Nice
	Yay:
	bne $t1, 10, Wow
	lw $a1, colours + 36
	li, $a0, 32
	jal Print_Yay
	Wow:
	bne $t1, 15, Poggers
	lw $a1, colours + 36
	li, $a0, 32
	jal Print_Wow
	Poggers:
	bne $t1, 20, Nothing
	lw $a1, colours + 36
	li, $a0, 16
	jal Print_Poggers
	Nothing:
	
	j Collision_with_bottom_platform

#typical random number generator that generates location of platform
#upper bound adjusted to make sure platform remains on screen
Random:
	li $v0, 42
	li $a0, 0
	div $a1, $a1, 4
	li $t8, 31
	sub $a1, $t8, $a1
	syscall
	jr $ra

#random number generator that generates the value of the platform
Random2:
	li $v0, 42
	li $a0, 0
	li $a1, 10
	syscall
	bge $a0, 3, endr
	li $a0, 3
	endr:
	jr $ra

#controls the probability 
Random3:
	li $v0, 42
	li $a0, 0
	syscall
	jr $ra
	
#detect if j or k key was pressed
keyboard_input:
	lw $t4, 0xffff0004 
	beq $t4, 0x6A, respond_to_j
	beq $t4, 0x6B, respond_to_k
	j return

#move doodle left if j is press
respond_to_j:	
	move $a0, $t7
	jal erase_lp
	jal erase_shield
	subi $t7, $t7, 4
	j return

#move doodle right if k is pressed
respond_to_k:
	move $a0, $t7
	jal erase_lp
	jal erase_shield
	addi $t7, $t7, 4
	j return

#Draw Score at a certain position on the screen:
#a0 = position
#a1 = colour
#a2 = score
Draw_Score:
	move $t8, $ra
	move $t3, $a2
	div $t4, $t3, 1000
	move $a2, $t4
    	li $t5, 12	
    	jal Print_number
    	mul $t4, $t4, 1000
    	sub $t3, $t3 , $t4
    	div $t4, $t3, 100
	move $a2, $t4
	addi $a0, $a0, 16
    	jal Print_number   	
    	mul $t4, $t4, 100
    	sub $t3, $t3 , $t4
    	div $t4, $t3, 10
	move $a2, $t4
	addi $a0, $a0, 16
    	jal Print_number 
    	mul $t4, $t4, 10
    	sub $t3, $t3, $t4
    	move $a2, $t3
    	addi $a0, $a0, 16
    	jal Print_number
    	
    	jr $t8
   
#Game Over screen that fades in and displays score with skull graphic	
Game_Over:
	jal erase
	li $t6, 0x110000
	li $t7, 0x111111
	
	while:
	#print game over
	move $a1, $t6
	addi $a0, $s0, 1312
	la $a3, G
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, A
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, M
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, E
	jal Print_Letter
	subi $a0, $a0, 48
	addi $a0, $a0, 768
	la $a3, O
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, V
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, E
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, R
	jal Print_Letter
	
	#Print Score
	subi $a0, $a0, 48
	addi $a0, $s0, 5008
	la $a3, S
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, C
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, O
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, R
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, E
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, Colon
	jal Print_Letter
	
	#print out the score
	addi $a0, $a0, 832
	move $a2, $t1
	jal Draw_Score
	
	#Print Skull
	move $a1, $t7
	addi $a0, $s0, 2996
	jal Print_Skull
	
	#Fade in until fully faded in
	beq $t6, 0xff0000, Wait
	addi $t6, $t6, 0x110000
	addi $t7, $t7, 0x111111
	
	#Sleep
	li $a0, 100
	jal Sleep
	j while

#wait a set amount of time before going from game over screen to start screen
Wait:
	li $a0, 2000
	jal Sleep
	j Start

#Below are simply instructions that specify how to print a specific number, letter or word pixels. 
# What object is being printed is specified in the title 
Print_Poggers:
	move $t4, $ra
	move $a0, $s0
	la $a3, P
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, O
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, G
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, G
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, E
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, R
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, S
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, Exclamation
	jal Print_Letter
	jr $t4
	
Print_Yay:
	move $t4, $ra
	add $a0, $a0, $s0
	la $a3, Y
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, A
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, Y
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, Exclamation
	jal Print_Letter
	jr $t4
	
Print_Wow:
	move $t4, $ra
	add $a0, $a0, $s0
	la $a3, W
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, O
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, W
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, Exclamation
	jal Print_Letter
	jr $t4
	
Print_Nice:
	move $t4, $ra
	add $a0, $a0, $s0
	la $a3, N
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, I
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, C
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, E
	jal Print_Letter
	addi $a0, $a0, 16
	la $a3, Exclamation
	jal Print_Letter
	jr $t4
	
#determine which number to write based on value of $a2
Print_number:	
	move $t9, $ra
	beq $a2, 0, Print_zero
	beq $a2, 1, Print_one
	beq $a2, 2, Print_two
	beq $a2, 3, Print_three
	beq $a2, 4, Print_four
	beq $a2, 5, Print_five
	beq $a2, 6, Print_six
	beq $a2, 7, Print_seven
	beq $a2, 8, Print_eight
	beq $a2, 9, Print_nine
	potato:
	jr $t9
	
Print_one:
	la $a3, I
	jal Print_Letter
	j potato 

Print_two:
	la $a3, Two
	jal Print_Letter
	j potato 

Print_three:
	la $a3, Three
	jal Print_Letter
	j potato 

Print_four:
	la $a3, Four
	jal Print_Letter
	j potato  

Print_five:
	la $a3, S
	jal Print_Letter
	j potato 

Print_six:
	la $a3, Six
	jal Print_Letter
	j potato  

Print_seven:
	la $a3, Seven
	jal Print_Letter
	j potato 

Print_eight:
	la $a3, Eight
	jal Print_Letter
	j potato 

Print_nine:	
	la $a3, Nine
	jal Print_Letter
	j potato 

Print_zero:	
	la $a3, O
	jal Print_Letter
	j potato 

#Prints out the actual number
Print_Letter:
	here:
	lw $t0, 0($a3)
	beqz $t0, here1
	sw $a1, 0($a0)
	here1:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here2
	sw $a1, 4($a0)
	here2:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here3
	sw $a1, 8($a0)
	here3:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here4
	sw $a1, 128($a0)
	here4:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here5
	sw $a1, 132($a0)
	here5:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here6
	sw $a1, 136($a0)
	here6:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here7
	sw $a1, 256($a0)
	here7:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here8
	sw $a1, 260($a0)
	here8:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here9
	sw $a1, 264($a0)
	here9:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here10
	sw $a1, 384($a0)
	here10:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here11
	sw $a1, 388($a0)
	here11:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here12
	sw $a1, 392($a0)
	here12:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here13
	sw $a1, 512($a0)
	here13:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here14
	sw $a1, 516($a0)
	here14:
	addi $a3, $a3, 4
	lw $t0, 0($a3)
	beqz $t0, here15
	sw $a1, 520($a0)
	here15:
	jr $ra
		
Print_Skull:
	sw $a1, 0($a0)
	sw $a1, 4($a0)
	sw $a1, 8($a0)
	sw $a1, 12($a0)
	sw $a1, 16($a0)
	
	sw $a1, 120($a0)
	sw $a1, 124($a0)
	sw $a1, 128($a0)
	sw $a1, 132($a0)
	sw $a1, 136($a0)
	sw $a1, 152($a0)
	sw $a1, 140($a0)
	sw $a1, 144($a0)
	sw $a1, 148($a0)
	
	sw $a1, 244($a0)
	sw $a1, 248($a0)
	sw $a1, 252($a0)
	sw $a1, 256($a0)
	sw $a1, 260($a0)
	sw $a1, 264($a0)
	sw $a1, 268($a0)
	sw $a1, 272($a0)
	sw $a1, 276($a0)
	sw $a1, 280($a0)
	sw $a1, 284($a0)
	
	sw $a1, 372($a0)
	sw $a1, 376($a0)
	sw $a1, 380($a0)
	sw $a1, 384($a0)
	sw $a1, 388($a0)
	sw $a1, 392($a0)
	sw $a1, 396($a0)
	sw $a1, 400($a0)
	sw $a1, 404($a0)
	sw $a1, 408($a0)
	sw $a1, 412($a0)
	
	sw $a1, 496($a0)
	sw $a1, 500($a0)
	sw $a1, 504($a0)	
	sw $a1, 516($a0)
	sw $a1, 520($a0)
	sw $a1, 524($a0)	
	sw $a1, 536($a0)
	sw $a1, 540($a0)
	sw $a1, 544($a0)
	
	sw $a1, 624($a0)
	sw $a1, 628($a0)
	sw $a1, 632($a0)
	sw $a1, 644($a0)
	sw $a1, 648($a0)
	sw $a1, 652($a0)
	sw $a1, 664($a0)
	sw $a1, 668($a0)
	sw $a1, 672($a0)
	
	sw $a1, 752($a0)
	sw $a1, 756($a0)
	sw $a1, 760($a0)
	sw $a1, 764($a0)
	sw $a1, 768($a0)
	sw $a1, 772($a0)
	sw $a1, 776($a0)
	sw $a1, 780($a0)
	sw $a1, 784($a0)
	sw $a1, 788($a0)
	sw $a1, 792($a0)
	sw $a1, 796($a0)
	sw $a1, 800($a0)
	
	sw $a1, 884($a0)
	sw $a1, 888($a0)
	sw $a1, 892($a0)
	sw $a1, 896($a0)
	sw $a1, 900($a0)
	sw $a1, 904($a0)
	sw $a1, 908($a0)
	sw $a1, 912($a0)
	sw $a1, 916($a0)
	sw $a1, 920($a0)
	sw $a1, 924($a0)
	
	sw $a1, 1016($a0)
	sw $a1, 1020($a0)
	sw $a1, 1024($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	sw $a1, 1036($a0)
	sw $a1, 1040($a0)
	sw $a1, 1044($a0)
	sw $a1, 1048($a0)
	
	sw $a1, 1016($a0)
	sw $a1, 1020($a0)
	sw $a1, 1024($a0)
	sw $a1, 1028($a0)
	sw $a1, 1032($a0)
	sw $a1, 1036($a0)
	sw $a1, 1040($a0)
	sw $a1, 1044($a0)
	sw $a1, 1048($a0)

	sw $a1, 1148($a0)
	sw $a1, 1152($a0)
	sw $a1, 1156($a0)
	sw $a1, 1160($a0)
	sw $a1, 1164($a0)
	sw $a1, 1168($a0)
	sw $a1, 1172($a0)
	
	sw $a1, 1276($a0)
	sw $a1, 1284($a0)
	sw $a1, 1292($a0)
	sw $a1, 1300($a0)
	
	sw $a1, 1404($a0)
	sw $a1, 1420($a0)
	sw $a1, 1412($a0)
	sw $a1, 1428($a0)
	jr $ra
	
Print_doodle:
	lw $a1, colours + 4
	sw $a1, 8($a0)
	sw $a1, 12($a0)
	sw $a1, 16($a0)
	sw $a1, 132($a0)
	sw $a1, 136($a0)
	sw $a1, 140($a0)
	sw $a1, 144($a0)
	sw $a1, 148($a0)
	sw $a1, 256($a0)
	sw $a1, 260($a0)
	sw $a1, 264($a0)
	sw $a1, 268($a0)
	sw $a1, 272($a0)
	sw $a1, 276($a0)
	sw $a1, 280($a0)
	sw $a1, 384($a0)
	sw $a1, 388($a0)
	sw $a1, 392($a0)
	sw $a1, 400($a0)
	sw $a1, 408($a0)
	sw $a1, 420($a0)
	sw $a1, 512($a0)
	sw $a1, 516($a0)
	sw $a1, 520($a0)
	sw $a1, 524($a0)
	sw $a1, 528($a0)
	sw $a1, 532($a0)
	sw $a1, 536($a0)
	sw $a1, 540($a0)
	sw $a1, 544($a0)
	sw $a1, 548($a0)
	sw $a1, 640($a0)
	sw $a1, 644($a0)
	sw $a1, 648($a0)
	sw $a1, 652($a0)
	sw $a1, 656($a0)
	sw $a1, 660($a0)
	sw $a1, 664($a0)
	sw $a1, 676($a0)
	sw $a1, 768($a0)
	
	li $a1, 0x017722
	sw $a1, 768($a0)
	sw $a1, 772($a0)
	sw $a1, 776($a0)
	sw $a1, 780($a0)
	sw $a1, 784($a0)
	sw $a1, 788($a0)
	sw $a1, 792($a0)
	sw $a1, 896($a0)
	sw $a1, 900($a0)
	sw $a1, 904($a0)
	sw $a1, 908($a0)
	sw $a1, 912($a0)
	sw $a1, 916($a0)
	sw $a1, 920($a0)
	sw $a1, 1024($a0)
	sw $a1, 1032($a0)
	sw $a1, 1040($a0)
	sw $a1, 1048($a0)
	sw $a1, 1152($a0)
	sw $a1, 1160($a0)
	sw $a1, 1168($a0)
	sw $a1, 1176($a0)
	jr $ra

End: 
	li $v0, 10
	syscall
