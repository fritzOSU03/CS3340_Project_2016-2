.data
	newLine:		.asciiz "\n"
	timer:			.word 60
	
	timeLeft:		.asciiz "Time left: "
	timeOut:		.asciiz "You're out of time!"
	
	prompt:			.asciiz "Enter 1 or 0: "

.text
	lw $s6, timer						# Setup initial timer length
	
	li $v0, 4				
	la $a0, timeLeft
	syscall
	
	li $v0, 1
	lw $a0, timer						# Display time left
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	jal setInitialTime

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#	The test loops are just to test that my timer algorithm works	       #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#	
testLoop:
	li $v0, 4
	la $a0, prompt						# Asking user for an input
	syscall							# Input anything above '1' to end the program
	
	li $v0, 5
	syscall
	move $t6, $v0
	
	jal setCurrentTime
								# Check the user's input
	beq $t6, 1, testLoop.Increment				# If '1' we'll treat it as they got a right answer, hence increment
	beqz $t6, testLoop.Wrong				# If '0' we treat as if the got an incorrect word
	bgt $t6, 1, testLoop.End				# This only exists for purpose of testing to exit the program quickly.
	
testLoop.Increment:
	jal incrementTime
	
	li $v0, 4
	la $a0, timeLeft
	syscall
	
	li $v0, 1
	lw $a0, timer						# Show how much time is left
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	jal setInitialTime					# Update the initial time 
	
	j testLoop

testLoop.Wrong:
	jal updateTime
	
	li $v0, 4
	la $a0, timeLeft
	syscall
	
	li $v0, 1
	lw $a0, timer						# Show how much time is left
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	jal setInitialTime					# Update the initial time
	
	j testLoop

testLoop.End:
	li $v0, 10
	syscall

#
#	This procedure is used to set up the first time read
#	i.e. one would use this at the beginning of the game
#	and any time after the updated time has been displayed
#

setInitialTime:
	li $v0, 30						# This reads in the current time from the CPU clock
	syscall
								# Time is stored into $a0, and $a1
	move $t0, $a0						# So we move these values into temporaries
	move $t1, $a1
	
	addu $s0, $t0, $t1					# Use 64-bit addition to get the full time read from $v0, 30
	
	jr $ra

#
#	This procedure is used to read the time directly after
#	the user has input a word. We need this second time so
#	that we can calculate how much time has passed.

setCurrentTime:
	li $v0, 30
	syscall
	
	move $t0, $a0						# Again like before store the time into temporaries
	move $t1, $a1
	
	addu $s1, $t0, $t1					# Add them together with 64-bit addition
	
	jr $ra

#
#	This procedure calculates how much time has passed since
#	our initial time reading, then updates the timer.
#

updateTime:
	subu $s2, $s1, $s0					# Subtracting the initial time from the current time
	divu $s2, $s2, 1000					# Converting from miliseconds to seconds
	
	sub $s6, $s6, $s2					# Subtract how much time has passed from the original timer
	sw $s6, timer						# Update the timer variable
	
	blt $s6, $zero, outOfTime				# Check to see if timer is less than 0, if so end the program
	
	jr $ra

#
#	This procedure is used for when the user inputs a correct 
#	word for the game.
#

incrementTime:
	subu $s2, $s1, $s0					# Subtract initial time from current time
	divu $s2, $s2, 1000					# Convert from miliseconds to seconds
	
	sub $s6, $s6, $s2					# Subtract how much time has passed from the original timer
	blt $s6, $zero, outOfTime				# Check that the timer hasn't gone below 0
	
	addi $s6, $s6, 20					# Add 20 seconds to the timer
	sw $s6, timer						# Update the timer variable
	
	jr $ra

#
#	This procedure is used for when the player has ran out of
#	time. It will end the program, but we can change this if 
# 	we decide to have the game be loop based.
#

outOfTime:
	li $v0, 4
	la $a0, timeOut
	syscall
	
	li $v0, 10
	syscall