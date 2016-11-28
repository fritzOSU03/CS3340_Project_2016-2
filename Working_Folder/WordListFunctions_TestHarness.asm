.data
	newLine:		.asciiz	"\n"
	enteredWord:		.space	10
	enteredWordSorted:	.space	10
	bitsRead:		.word	0
	dictionaryChars:	.word	0
	
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

	.globl main
	
	.include "WordListFunctions.asm"

main:
	jal	SetupWordFunctions
	
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
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the random number string.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, randomNumS
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the random number.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 1						# Service 1, print int
	lw	$a0, rdmWrdOfst					# $a0 = rdmWrdOfst
	divu	$a0, $a0, 10					# #a0 /= 10
	syscall							# Print previously generated random int
	
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
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the correct word list.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, dictionaryMatches
	syscall
	
	#Print a line return to screen
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
	jal	checkWord					# $a0 = enteredWord
	
	
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
	jal	checkWord					# $a0 = enteredWord
	
	
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
	jal	checkWord					# $a0 = enteredWord
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the entered word.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, result
	syscall
	
	#Print the result word to screen
	la	$a0, enteredWord
	syscall
	
	#Print a line return to screen
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	la	$a1, enteredWord				# $a1 = enteredWord address
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	jal	strCpy						# $a0 = enteredWordSorted; $a1 = enteredWord
	
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	jal	enteredWordSort					# $a0 = enteredWordSorted
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the sorted, entered word.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	li	$v0, 4
	la	$a0, enteredWordSorted
	syscall
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	la	$a1, magicLetter				# $a1 = magicLetter address
	jal	magicLetterCont					# a0 = enteredWordSorted; $a1 = magicLetter
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the letter test result.				#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	move	$a0, $v0
	li	$v0, 1
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	la	$a0, enteredWordSorted				# $a0 = enteredWordSorted address
	la	$a1, magicWordSorted				# $a1 = magicWordSorted address
	jal	magicWordCont					# a0 = enteredWordSorted; $a1 = magicWordSorted
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	#				Optional - Print the word test result.					#
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	move	$a0, $v0
	li	$v0, 1
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	
	
#	#Print the correct word list to screen
#	li	$v0, 4
#	la	$a0, dictionaryMatches
#	syscall
#	
#	#Print a line return to screen
#	la	$a0, newLine
#	syscall
	
	#Print the correct word list to screen
	li	$v0, 4
	la	$a0, givenMatches
	syscall
	
	#Print a line return to screen
	la	$a0, newLine
	syscall
		
	
	li	$v0, 10					# Syscall for terminate program
	syscall						# Execute Syscall
	
