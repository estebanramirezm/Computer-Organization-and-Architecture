# Project #7
# Author: Esteban Ramirez
# Date: November 15th
# Description: Establishes a local array, fills it with values from the user, and then determines and reports the maximum value in the array. From C/C++ code

.data
SIZE:   .word 15
greeting: .asciiz "Welcome!\n\n"
prompt: .asciiz "Enter an integer: "
maxMsg: .asciiz "The maximum value is "
array:  .space 60     # 15 integers (4 bytes each)
goodbye: .asciiz "\n\nThanks for running this program!!"

.text
.globl main

# Establishes a local array, fills it with values from the user, and then determines and reports the maximum value in the array. From C/C++ code
main:
    # Set up stack frame for main
    addiu $sp, $sp, -8  # Allocate space for 2 items on the stack
    sw $ra, 4($sp)      # Save return address

    # Greeting
    li $v0, 4
    la $a0, greeting
    syscall

    # Call fillArray
    jal fillArray

    # Call findMax
    jal findMax

    # Print max value
    li $v0, 4              # syscall for print string
    la $a0, maxMsg         # load max message
    syscall

    li $v0, 1              # syscall for print int
    move $a0, $t3          # move max value to $a0
    syscall

    # Goodbye
    li $v0, 4
    la $a0, goodbye
    syscall

    # Clean up the stack and exit
    lw $ra, 4($sp)       # Load the return address back into $ra
    addiu $sp, $sp, 8
    jr $ra

# Fills the array with the values the user inputs
fillArray:
    li $t0, 0              # loop index i
    la $t1, array          # address of array
    lw $t2, SIZE           # Load the value of SIZE

    fillArrayLoop:
        li $v0, 4          # syscall for print string
        la $a0, prompt     # load prompt message
        syscall

        li $v0, 5          # syscall for read int
        syscall            # read integer to $v0

        sw $v0, 0($t1)     # store the read integer in array
        addiu $t1, $t1, 4  # move to next array element
        addiu $t0, $t0, 1  # increment loop index
        blt $t0, $t2, fillArrayLoop
    jr $ra

# Finds the maximum value in the array
findMax:
    li $t0, 1              # loop index i
    la $t1, array          # address of array
    lw $t2, SIZE           # Load the value of SIZE
    lw $t3, 0($t1)         # Initialize max with first element
    addiu $t1, $t1, 4      # move to next array element

    findMaxLoop:
        lw $t4, 0($t1)     # load current array element
        bgt $t4, $t3, updateMax
        addiu $t1, $t1, 4  # increment array address
        addiu $t0, $t0, 1  # increment loop index
        blt $t0, $t2, findMaxLoop
    jr $ra

updateMax:
    move $t3, $t4          # update max
    j findMaxLoop


