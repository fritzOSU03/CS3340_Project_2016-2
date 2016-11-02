.data
	newLine:		.asciiz	"\n"
	nineList:		.asciiz	"9List"
	dictionaryName:		.asciiz	""
	magicWord:		.space	10
	magicWordSorted:	.space	10
	magicLetter:		.space	1
	enteredWord:		.space	10
	enteredWordSorted:	.space	10
	fileDesc:		.word	0
	buffer:			.space	500000
	dictionary:		.space	500000
	bitsRead:		.word	0
	charsRead:		.word	0
	wordsRead:		.word	0
	dictionaryWords:	.word	0
	rdmWrdOfst:		.word	0
	
	bitsReadS:		.asciiz "Number of bits read:  "
	charsReadS:		.asciiz "Number of chars read: "
	wordsReadS:		.asciiz "Number of words read: "
	randomNumS:		.asciiz "Random number value:  "
	rdmWrdOfstS:		.asciiz "Size of word offset:  "
	magicLetterS:		.asciiz "Magic Letter:         "
	magicWordS:		.asciiz "Magic Word:           "
	magicWordSS:		.asciiz "Sorted Magic Word:    "
	
	prompt:			.asciiz "Please enter a word: "
	result:			.asciiz "The entered word is: "
	

.text
	# Open the 9-letter word file.
	
	# Open the file
	li	$v0, 13						# Syscall for open file
	la	$a0, nineList					# Load file name address
	li	$a1, 0						# Read Only
	li	$a2, 0						# Mode 0, ignored
	syscall							# Execute Syscall ($v0 = file descriptor)
	sw	$v0, fileDesc					# Store the file descriptor
	move	$s6, $v0					# Store the file descriptor
	
	# Read from the file
	li	$v0, 14						# Syscall for read from file
	#la	$a0, fileDesc					# Load address of the file descriptor
	move	$a0, $s6					# file descriptor
	la	$a1, buffer					# Load address of input buffer
	li	$a2, 500000					# Max number of characters to read
	syscall							# Execute Syscall ($v0 = No. of characters read)
	
	# Count the number of entries.
	sw	$v0, charsRead					# Store the number of characters read
	divu	$v0, $v0, 10					# $v0 = $v0 / 10
	sw	$v0, wordsRead					# Store the number of words read
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the number of characters read.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, charsReadS
	syscall
	
	li	$v0, 1
	lw	$a0, charsRead
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the number of words read.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, wordsReadS
	syscall
	
	li	$v0, 1
	lw	$a0, wordsRead
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	# Close the file 
	li	$v0, 16						# Syscall for close file
	#la	$a0, fileDesc					# Load address of file descriptor
	move	$a0, $s6					# File descriptor to close
	syscall							# Execute Syscall
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the random number string.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, randomNumS
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	li	$v0, 42						# Syscall for bounded, random int
	add	$a0, $zero, $zero				# Select random generator >= 0
	lw	$a1, wordsRead					# And <= wordsRead
	addi	$a1, $a1, -1					# Decrement $a1
	syscall							# Generate random int (returns in $a0)
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the random number.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 1						# Service 1, print int
	syscall							# Print previously generated random int
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	mul	$a0, $a0, 10
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#			Optional - Lock the random number offset for testing.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#li	$a0, 61930					# Sets rdmWrdOfst = "ligaments"
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	sw	$a0, rdmWrdOfst					# Store random word offset bits
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the random number.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the random word offset.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, rdmWrdOfstS
	syscall
	
	li	$v0, 1
	lw	$a0, rdmWrdOfst
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	lw	$s0, charsRead					# $s0 = number of characters read
	sll	$s0, $s0, 3					# $s0 = number of characters read * 2
	sw	$s0, bitsRead					# Store number of bits read
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the number of bits read.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, bitsReadS
	syscall
	
	li	$v0, 1
	lw	$a0, bitsRead
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	la	$s0, buffer					# $s0 = buffer address
	lw	$s1, rdmWrdOfst					# $s1 = rdmWrdOfst
	add	$s0, $s0, $s1					# $s0 = buffer address + rdmWrdOfst
	li	$s1, 0						# $s1 = 0
	lb	$t0, ($s0)					# $t0 = (buffer address + rdmWrdOfst) letter
	sb	$t0, magicLetter				# magicLetter = $t0
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the magic letter.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, magicLetterS
	syscall
	
	la	$a0, magicLetter
	syscall
	
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	la	$a1, buffer					# $a1 = buffer address
	lw	$s1, rdmWrdOfst					# $s1 = rdmWrdOfst
	add	$a1, $a1, $s1					# $a1 = buffer address + rdmWrdOfst
	li	$s1, 0						# $s1 = 0
	la	$a0, magicWord					# $a0 = magicWord address
	jal	strCpy						# $a0 = magicWord; $a1 = buffer + rdmWrdOfst
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the magic word.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, magicWordS
	syscall
	
	la	$a0, magicWord
	syscall
	
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	la	$a1, magicWord					# $a1 = magicWord address
	la	$a0, magicWordSorted				# $a0 = magicWordSorted
	jal	strCpy						# $a0 = magicWordSorted; $a1 = magicWord
	jal	magicWordSort					# $a0 = magicWord
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the sorted magic word.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, magicWordSS
	syscall
	
	la	$a0, magicWordSorted
	syscall
	
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	#Print the entry prompt to screen
	li	$v0, 4						# Setup string print to screen
	la	$a0, prompt					# Print this string
	syscall							# Execute
	
	#Read in an entered string
	li	$v0, 8						# Setup read string
	la	$a0, enteredWord				# Load byte space into address
	li	$a1, 10						# Allot the byte space for string
	syscall							# Execute
	
	la	$a0, enteredWord				# $a0 = enteredWord address
	jal	wordToLowerCase					# $a0 = enteredWord
	
	#Print the result string to screen
	li	$v0, 4
	la	$a0, result
	syscall
	
	#Print the result word to screen
	la	$a0, enteredWord
	syscall
	
	#Print a line return to screen
	la	$a0, newLine
	syscall
	
	
	la	$a1, enteredWord				# $a1 = enteredWord address
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	jal	strCpy						# $a0 = enteredWordSorted; $a1 = enteredWord
	
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	jal	enteredWordSort					# $a0 = enteredWordSorted
	
	li	$v0, 4
	la	$a0, enteredWordSorted
	syscall
	la	$a0, newLine
	syscall
	
	
	
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	la	$a1, magicLetter				# $a1 = magicLetter address
	jal	magicLetterCont					# a0 = enteredWordSorted; $a1 = magicLetter
	
	move	$a0, $v0
	li	$v0, 1
	syscall
	
	
		
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	la	$a1, magicWordSorted				# $a1 = magicWordSorted address
	jal	magicWordCont					# a0 = enteredWordSorted; $a1 = magicWordSorted
	
	move	$a0, $v0
	li	$v0, 1
	syscall
	
	
	lb	$t1, magicLetter
	sw	$t1, dictionaryName
	
	# Open the file
	li	$v0, 13						# Syscall for open file
	la	$a0, dictionaryName				# Load file name address
	li	$a1, 0						# Read Only
	li	$a2, 0						# Mode 0, ignored
	syscall							# Execute Syscall ($v0 = file descriptor)
	sw	$v0, fileDesc					# Store the file descriptor
	move	$s6, $v0					# Store the file descriptor
	
	# Read from the file
	li	$v0, 14						# Syscall for read from file
	#la	$a0, fileDesc					# Load address of the file descriptor
	move	$a0, $s6					# file descriptor
	la	$a1, dictionary					# Load address of input buffer
	li	$a2, 500000					# Max number of characters to read
	syscall							# Execute Syscall ($v0 = No. of characters read)
	
	# Close the file 
	li	$v0, 16						# Syscall for close file
	#la	$a0, fileDesc					# Load address of file descriptor
	move	$a0, $s6					# File descriptor to close
	syscall							# Execute Syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	
	li	$v0, 11
	la	$s0, dictionary
	addi	$s0, $s0, 600
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	lb	$a0, 0($s0)
	addi	$s0, $s0, 1
	syscall
	
	
	
	
	
	
	li	$v0, 10
	syscall
	
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					strCpy Procedure						#
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
	addi	$t1, $t1, 1				# Source[i++]
	addi	$t3, $t3, 1				# Destination[i++]
	xor	$t2, $t2, $t2				# Clear $t2
	j	strCpy.Loop				# Jump to strCpy.Loop
strCpy.End:
	sb	$zero, 0($t3)				# Destination[9] = 0 (null string terminator)
	
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	lw	$a1, 8($sp)				# Restore $a1
	addi	$sp, $sp, 12				# Restore the stack pointer
	
	# Return to the caller.
	jr	$ra					# Set PC = $ra
	

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					magicWordSort Procedure						#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
magicWordSort:						# a0 = magicWordSorted
	addi	$sp, $sp, -8				# Move the stack pointer to allocate space
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	li	$s0, 0					# Initialize $s0 to 0 for counter
	
magicWordSort.Loop:
	add	$t0, $a0, $zero				# $t0 = magicWordSorted
	
magicWordSort.Inner.Loop.Start:
	lb	$t1, 0($t0)				# $t1 = 0($t0)
	lb	$t2, 1($t0)				# $t2, 1($t0)
	beqz	$t2, magicWordSort.Inner.Loop.End	# If($t2 == 0) branch to magicWordSort.Inner.Loop.End
	blt	$t2, $t1, magicWordSort.Swap		# If($t2 < $t1) branch to magicWordSort.Swap
magicWordSort.NoSwap:
	addi	$t0, $t0, 1				# Increment the address pointer
	j	magicWordSort.Inner.Loop.Start		# Jump to magicWordSort.Inner.Loop.Start
magicWordSort.Swap:
	sb	$t1, 1($t0)				# Store the greater character second
	sb	$t2, 0($t0)				# Store the lesser character first
	addi	$t0, $t0, 1				# Increment the address pointer
	j	magicWordSort.Inner.Loop.Start		# Jump to magicWordSort.Inner.Loop.Start
magicWordSort.Inner.Loop.End:
	addi	$s0, $s0, 1				# Increment the outer loop counter
	bgt	$s0, 7, magicWordSort.End		# If($s0 > 7) branch to agicWordSort.End
	j	magicWordSort.Loop			# Else Jump to magicWordSort.Loop
	
magicWordSort.End:
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	addi	$sp, $sp, 8				# Restore the stack pointer
	
	# Return to the caller.
	jr	$ra					# Set PC = $ra
	

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					enteredWordSort Procedure					#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
enteredWordSort:					# a0 = enteredWordSorted
	addi	$sp, $sp, -8				# Move the stack pointer to allocate space
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	li	$s0, 0					# Initialize $s0 to 0 for counter
	jal	strLen					# Call string length function
	add	$s1, $v0, $zero				# $s1 = string length
	
enteredWordSort.Loop:
	add	$t0, $a0, $zero				# $t0 = enteredWordSorted
	
enteredWordSort.Inner.Loop.Start:
	lb	$t1, 0($t0)				# $t1 = 0($t0)
	lb	$t2, 1($t0)				# $t2 = 1($t0)
	beqz	$t2, enteredWordSort.Inner.Loop.End	# If($t2 == 0) branch to enteredWordSort.Inner.Loop.End
	blt	$t2, $t1, enteredWordSort.Swap		# If($t2 < $t1) branch to enteredWordSort.Swap
enteredWordSort.NoSwap:
	addi	$t0, $t0, 1				# Increment the address pointer
	j	enteredWordSort.Inner.Loop.Start	# Jump to enteredWordSort.Inner.Loop.Start
enteredWordSort.Swap:
	sb	$t1, 1($t0)				# Store the greater character second
	sb	$t2, 0($t0)				# Store the lesser character first
	addi	$t0, $t0, 1				# Increment the address pointer
	j	enteredWordSort.Inner.Loop.Start	# Jump to enteredWordSort.Inner.Loop.Start
enteredWordSort.Inner.Loop.End:
	addi	$s0, $s0, 1				# Increment the outer loop counter
	#ble	$s0, $s1, enteredWordSort.Loop		# If($s0 <= $s1) branch to enteredWordSort.End
	
	bgt	$s0, $s1, enteredWordSort.End		# If($s0 > $s1) branch to enteredWordSort.End
	j	enteredWordSort.Loop			# Else Jump to enteredWordSort.Loop
	
enteredWordSort.End:
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	addi	$sp, $sp, 8				# Restore the stack pointer
	
	# Return to the caller.
	jr	$ra					# Set PC = $ra


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					wordToLowerCase procedure					#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
wordToLowerCase:
	addi	$sp, $sp, -8				# Move the stack pointer to allocate space
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	add	$t0, $a0, $zero				# $t0 = enteredWord
	
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
	
	# Return to the caller.
	jr	$ra					# Set PC = $ra

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					magicLetterCont Function					#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
magicLetterCont:					# a0 = enteredWordSorted; $a1 = magicLetter
	addi	$sp, $sp, -12				# Move the stack pointer to allocate space
	sw	$a1, 8($sp)				# Store $a1 on the stack
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	add	$s0, $a0, $zero				# $s0 = enteredWordSorted
	lb	$s1, 0($a1)				# $s1 = magicLetter
	
	jal	strLen
	li	$s4, 0					# $s4 = 0 (enteredWordSorted counter)
	add	$s5, $v0, $zero				# $s5 = string length (enteredWordSorted)
	li	$v0, 0					# $v0 = 0
	
magicLetterCont.Loop:
	lb	$s2, 0($s0)
	beqz	$s2, magicLetterCont.End
	seq	$v0, $s1, $s2
	beq	$v0, 1, magicLetterCont.End
	addi	$s4, $s4, 1
	addi	$s0, $s0, 1
	j	magicLetterCont.Loop
	
magicLetterCont.End:
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	lw	$a1, 8($sp)				# Restore $a0
	addi	$sp, $sp, 12				# Restore the stack pointer
	
	# Return to the caller.
	jr	$ra					# Set PC = $ra

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					magicWordCont Function						#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
magicWordCont:						# a0 = enteredWordSorted; $a1 = magicWordSorted
	addi	$sp, $sp, -12				# Move the stack pointer to allocate space
	sw	$a1, 8($sp)				# Store $a0 on the stack
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	add	$s0, $a0, $zero				# $s0 = enteredWordSorted
	add	$s1, $a1, $zero				# $s1 = magicWordSorted
	
	jal	strLen
	li	$s2, 0					# $s2 = 0 (enteredWord counter)
	li	$s3, 0					# $s3 = 0 (magicWord counter)
	add	$s4, $v0, $zero				# $s4 = string length (enteredWord)
	addi	$s5, $zero, 9				# $s5 = string length (magicWord)
	
magicWordCont.Loop:
	lb	$t0, 0($s0)
	lb	$t1, 0($s1)
	seq	$v0, $t0, 0
	beq	$v0, 1, magicWordCont.End
	beqz	$t1, magicWordCont.End
	bne	$t0, $t1, magicWordCont.NoLetter
magicWordCont.HasLetter:
	addi	$s0, $s0, 1
	addi	$s1, $s1, 1
	addi	$s2, $s2, 1
	addi	$s3, $s3, 1
	j	magicWordCont.Loop
magicWordCont.NoLetter:
	addi	$s1, $s1, 1
	addi	$s3, $s3, 1
#	ble	$s3, $s5, magicWordCont.Loop
	j	magicWordCont.Loop
	
magicWordCont.End:
	lw	$ra, 0($sp)				# Restore $ra
	lw	$a0, 4($sp)				# Restore $a0
	lw	$a1, 8($sp)				# Restore $a0
	addi	$sp, $sp, 12				# Restore the stack pointer
	
	# Return to the caller.
	jr	$ra					# Set PC = $ra

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#					strLen Function							#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
strLen:
	addi	$sp, $sp, -8				# Move the stack pointer to allocate space
	sw	$a0, 4($sp)				# Store $a0 on the stack
	sw	$ra, 0($sp)				# Store $ra on the stack
	
	li	$t2, 0					# Initialize the counter to zero
	add	$t0, $a0, $zero				# $t0 = enteredWord
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
	
	# Return to the caller.
	jr	$ra					# Set PC = $ra
	
	
	# Open a text file by letter.
	# Store the words.
	# Close the text file.
	