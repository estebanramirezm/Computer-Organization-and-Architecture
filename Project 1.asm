## Project #1
## Purpose: MIPS Hello World 
## Author: Esteban Ramirez 
## Date: Sep 22th 2022

# Data
.data
hello_msg:  .asciiz "Hello World\n" 

# Text
.text
.globl main

# Main program
main:
    # Procedure call convention:
  	# 1. Save $fp and $ra on the stack
    	# 2. Adjust $sp to allocate space on the stack
   	# 3. Set $fp to the current $sp

    # Save $fp and $ra on the stack
    	addi $sp, $sp, -8
    	sw $fp, 4($sp)
    	sw $ra, 0($sp)

    # Set $fp to the current $sp
    move $fp, $sp

    # Print "Hello World"
    	# code for print string
    	li $v0, 4          
    	# load address of hello_msg into $a0
    	la $a0, hello_msg  
   	 syscall

    # Procedure call convention:
    	# 1. Restore $fp and $ra from the stack
    	# 2. Adjust $sp to deallocate stack space

    # Restore $fp and $ra from the stack
   	lw $fp, 4($sp)
   	lw $ra, 0($sp)

    # Adjust $sp to deallocate stack space
    	addi $sp, $sp, 8

    # Exit program
	# syscall code for exit
    	li $v0, 10         
    	syscall
