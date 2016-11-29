.text

.globl	strCpy
.globl	strCpyNewLine
.globl	strContains
.globl	wordToLowerCase
.globl	strLen
.globl	strLenNull


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					strCpy Procedure						#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#	This procedure takes two addresses, the source address in $a1, and the destination in $a0. 	#
#	The content of the source address is copied, biy by bit, to the destination address. The copy	#
#	process completes when either a new line character (10) or the null character (0) is found.	#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
strCpy:
	addi	$sp, $sp, -12				# Move the stack pointer to allocate space
	sw	$a1, 8($sp)				# Store $a1 on the stack
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	add	$t1, $zero, $a1				# $t1 = Address of Source[0]
	add	$t3, $zero, $a0				# $t3 = Address of Destination[0]
strCpy.Loop:
	lb	$t2, 0($t1)				# $t2 = Source[i]
	beq	$t2, 10, strCpy.End			# if(Source[i]==10) leave loop
	beqz	$t2, strCpy.End				# if(Source[i]==0)  leave loop
	sb	$t2, 0($t3)				# Destination[i] = Source[i]
	addi	$t1, $t1, 1				# Increment Source counter
	addi	$t3, $t3, 1				# Increment Destination counter
	li	$t2, 0					# Clear $t2
	j	strCpy.Loop				# Jump to strCpy.Loop
strCpy.End:
	sb	$zero, 0($t3)				# Destination[i] = 0 (null string terminator)
	
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	lw	$a1, 8($sp)				# Restore $a1
	addi	$sp, $sp, 12				# Restore the stack pointer
	
	jr	$ra					# Set PC = $ra
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					strCpyNewLine Procedure						#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#	This procedure takes two addresses, the source address in $a1, and the destination in $a0. 	#
#	The content of the source address is copied, biy by bit, to the destination address. The copy	#
#	process completes when either a new line character (10) or the null character (0) is found.	#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
strCpyNewLine:
	addi	$sp, $sp, -12				# Move the stack pointer to allocate space
	sw	$a1, 8($sp)				# Store $a1 on the stack
	add	$t1, $zero, $a1				# $t1 = Address of Source[0]
	sw	$a0, 4($sp)				# Store $a0 on the stack
	add	$t3, $zero, $a0				# $t3 = Address of Destination[0]
	sw	$ra, 0($sp)				# Store $ra on the stack
strCpyNewLine.Loop:
	lb	$t2, 0($t1)				# $t2 = Source[i]
	beq	$t2, 10, strCpyNewLine.End		# if(Source[i]==10) leave loop
	beqz	$t2, strCpyNewLine.End			# if(Source[i]==0)  leave loop
	sb	$t2, 0($t3)				# Destination[i] = Source[i]
	addi	$t1, $t1, 1				# Increment Source counter
	addi	$t3, $t3, 1				# Increment Destination counter
	li	$t2, 0					# Clear $t2
	j	strCpyNewLine.Loop			# Jump to strCpyNewLine.Loop
strCpyNewLine.End:
	li	$t2, 10					# $t2 = "\n"
	sb	$t2, 0($t3)				# Destination[i] = 10 (new line character)
	sb	$zero, 1($t3)				# Destination[i+1] = 0 (null character)
	
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	lw	$a1, 8($sp)				# Restore $a1
	addi	$sp, $sp, 12				# Restore the stack pointer
	
	jr	$ra					# Set PC = $ra
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					strContains Procedure						#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#	This procedure takes two addresses, the string address in $a0, and the string array (new line	#
#	delimited) address in $a1. The string is checked for presence in the string array as a sub-	#
#	string. A 1 is returned if the string array contains the string. Othersize, 0 is returned.	#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
strContains:
	addi	$sp, $sp, -16				# Move the stack pointer to allocate space
	sw	$s0, 12($sp)				# Store $s0 on the stack
	sw	$a1, 8($sp)				# Store $a1 on the stack
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	add	$s0, $zero, $a0				# $s0 = Address of string (original)
	add	$t0, $zero, $a0				# $t0 = Address of string
	add	$t1, $zero, $a1				# $t1 = Address of string array
strContains.Loop.Start:
	lb	$t2, 0($t0)				# $t2 = 0(string[i])
	beq	$t2, 10, strContains.True.Conf		# If(string[i]==10) branch to strContains.True.Conf
	beqz	$t2, strContains.True.Conf		# If(string[i]==0) branch to strContains.True.Conf
	lb	$t3, 0($t1)				# $t3 = 0(string array[i])
	beqz	$t3, strContains.False			# If(string array[i]==0) branch to strContains.False
	bne	$t2, $t3, strContains.Loop.NoMatch	# If(string[i]!=string array[i]) branch to strContains.Loop.NoMatch
strContains.Loop.Match:
	addi	$t0, $t0, 1				# Increment string pointer
	addi	$t1, $t1, 1				# Increment string array pointer
	j	strContains.Loop.Start			# Jump to strContains.Loop.Start
strContains.Loop.NoMatch:
	add	$t0, $zero, $s0				# Reset string pointer
strContains.Loop.ArrayNext:
	addi	$t1, $t1, 1				# Increment string array pointer
	lb	$t3, -1($t1)				# $t3 = -1(string array[i])
	beq	$t3, 10, strContains.Loop.Start		# If(string array[i]==10) branch to strContains.Loop.Start
	beqz	$t3, strContains.False			# If(string array[i]==0) branch to strContains.False
	j	strContains.Loop.ArrayNext		# Jump to strContains.Loop.ArrayNext
strContains.True.Conf:
	lb	$t3, 0($t1)				# $t2 = 0(string array[i])
	ble	$t3, 10, strContains.True		# If(string array[i]<=10) branch to strContains.True
	j	strContains.Loop.NoMatch		# Else jump to strContains.Loop.NoMatch
strContains.True:
	li	$v0, 1					# $v0 = 1 (True)
	j	strContains.End				# Jump to strContains.End
strContains.False:
	li	$v0, 0					# $v0 = 0 (False)
	j	strContains.End				# Jump to strContains.End
strContains.End:
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	lw	$a1, 8($sp)				# Restore $a1
	lw	$s0, 12($sp)				# Restore $s0
	addi	$sp, $sp, 16				# Restore the stack pointer
	
	jr	$ra					# Set PC = $ra
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					wordToLowerCase procedure					#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#	This procedure takes one address in $a0. The procedure checks each character to see if it falls	#
#	within the range of lower case ascii characters (97 - 122) and adds 32 to any character outside	#
#	of that range. The conversion process completes when either a new line character (10) or	#
#	the null character (0) is found.								#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
wordToLowerCase:
	addi	$sp, $sp, -8				# Move the stack pointer to allocate space
	sw	$a0, 4($sp)				# Store $a0 on the stack
	add	$t0, $a0, $zero				# $t0 = enteredWord
	sw	$ra, 0($sp)				# Store $ra on the stack
wordToLowerCase.Loop:
	lb	$t1, 0($t0)				# $t1 = 0($t0)
	addi	$t0, $t0, 1				# Increment the address pointer
	beqz	$t1, wordToLowerCase.End		# If($t1 ==  0) branch to wordToLowerCase.End
	beq	$t1, 10, wordToLowerCase.End		# If($t1 == 10) branch to wordToLowerCase.End
	bge	$t1, 97, wordToLowerCase.Loop		# If($t1 >= 97) branch to wordToLowerCase.Loop
wordToLowerCase.ToLower:
	addi	$t1, $t1, 32				# Convert upper to lower
	sb	$t1, -1($t0)				# Store the converted character
	j	wordToLowerCase.Loop			# Jump to wordToLowerCase.Loop
wordToLowerCase.End:
	sb	$zero, 0($t0)				# Null string terminator
	
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	addi	$sp, $sp, 8				# Restore the stack pointer
	
	jr	$ra					# Set PC = $ra
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					strLen Function							#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#	This function takes the address of a string in $a0 and iterates through the string to obtain	#
#	length of the string. The function completes when either the new line character (10) or the	#
#	null terminator character (0) is found. The integer length of the string is returned.		#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
strLen:
	addi	$sp, $sp, -8				# Move the stack pointer to allocate space
	sw	$a0, 4($sp)				# Store $a0 on the stack
	add	$t0, $a0, $zero				# $t0 = enteredWord
	sw	$ra, 0($sp)				# Store $ra on the stack
	li	$t2, 0					# Initialize the counter to zero
strLen.Loop:
	lb	$t1, 0($t0)				# Load the next character into t1
	beqz	$t1, strLen.Exit			# Check for the null character
	beq	$t1, 10, strLen.Exit			# Check for the line feed character
	addi	$t0, $t0, 1				# Increment the string pointer
	addi	$t2, $t2, 1				# Increment the counter
	j	strLen.Loop				# Return to the top of the loop
strLen.Exit:
	add	$v0, $t2, $zero				# Move the count to $v0
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	addi	$sp, $sp, 8				# Restore the stack pointer
	
	jr	$ra					# Set PC = $ra
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					strLenNull Function						#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#	This function takes the address of a string in $a0 and iterates through the string to obtain	#
#	length of the string. The function completes only when the null terminator character (0) is	#
#	found. The integer length of the string is returned.						#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
strLenNull:
	addi	$sp, $sp, -8				# Move the stack pointer to allocate space
	sw	$a0, 4($sp)				# Store $a0 on the stack
	add	$t0, $a0, $zero				# $t0 = enteredWord
	sw	$ra, 0($sp)				# Store $ra on the stack
	li	$t2, 0					# Initialize the counter to zero
strLenNull.Loop:
	lb	$t1, 0($t0)				# Load the next character into t1
	beqz	$t1, strLenNull.Exit			# Check for the null character
	addi	$t0, $t0, 1				# Increment the string pointer
	addi	$t2, $t2, 1				# Increment the counter
	j	strLenNull.Loop				# Return to the top of the loop
strLenNull.Exit:
	add	$v0, $t2, $zero				# Move the count to $v0
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	addi	$sp, $sp, 8				# Restore the stack pointer
	
	jr	$ra					# Set PC = $ra
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
