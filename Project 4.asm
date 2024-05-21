## Project 4
## Date: 24 Oct, 2023
## Author: Esteban Ramirez
## Purpose: Implementation of a manually multiplying function (Peasant Multiplication)  

.data
# This section has prompts for user input and some strings for displaying the product / interacting with the user.
greeting: .asciiz "MANUAL MULTIPLICATION PROGRAM\n"
greeting2: .asciiz "------------------------------------\n\n"
greeting3: .asciiz "Welcome! This program will multiply 2 different numbers (producing a result up to 32 bits)\n\n"
prompt1: .asciiz "Enter the first number: "
prompt2: .asciiz "Enter the second number: "
resultStr: .asciiz "Product: "
goodbye: .asciiz "\n\nThanks for using this program! :)"

.text
# This driver procedure prompts the user for two numbers, calls the multiply procedure to multiply them, and then displays the result.
main:
    # Greeting
    li $v0, 4
    la $a0, greeting
    syscall
    la $a0, greeting2
    syscall
    la $a0, greeting3
    syscall

    # Print the first prompt
    li $v0, 4
    la $a0, prompt1
    syscall

    # Read the first integer
    li $v0, 5
    syscall
    move $t0, $v0  # multiplicand
    
    # Print the second prompt 
    li $v0, 4
    la $a0, prompt2
    syscall

    # Read the second integer
    li $v0, 5
    syscall
    move $t1, $v0  # multiplier

    # Call multiply procedure
    jal multiply
    move $t2, $v0

    # Print the result string
    li $v0, 4
    la $a0, resultStr
    syscall

    # Print the result number
    move $a0, $t2  # Move the result to $a0 for printing
    li $v0, 1
    syscall
    
    # Goodbye
    li $v0, 4
    la $a0, goodbye
    syscall

    # End the program
    li $v0, 10
    syscall
    ## jr $ra  OBSERVATION: QtSPIM crashes when I end the program this way instead of using the syscall

# This procedure implements the Peasant Multiplication algorithm to multiply two numbers. 
# It uses a loop to perform repeated doubling and halving operations, accumulating the result.
multiply:
    # Preserve the return address and other required registers
    addiu $sp, $sp, -12  # Make space on the stack for 3 registers (adjusting for $t1 as well)
    sw $ra, 8($sp)      # Save return address
    sw $t0, 4($sp)      # Save $t0 since we're modifying it
    sw $t1, 0($sp)      # Save $t1 since we're modifying it

    li $t2, 0           # Initialize result register $t2 to zero

    for_loop:
        andi $t3, $t1, 1  # Extract the least significant bit of $t1 (to check if it's odd or even)
        beq $t3, $zero, skip  # If $t1 is even (LSB is 0), skip the addition step
        add $t2, $t2, $t0  # If $t1 is odd (LSB is 1), add the value of $t0 to the accumulator $t2

    skip:
        sll $t0, $t0, 1  # Double the value of $t0 for the next iteration
        srl $t1, $t1, 1  # Halve the value of $t1 for the next iteration (ignoring any remainder)
        bnez $t1, for_loop  # If $t1 is not zero, repeat the loop

    move $v0, $t2  # Move the final result from $t2 to $v0 to return it to the caller

    # Restore the saved registers and return to caller
    lw $t1, 0($sp)      # Restore the original value of $t1 from the stack
    lw $t0, 4($sp)      # Restore the original value of $t0 from the stack
    lw $ra, 8($sp)      # Restore the return address from the stack
    addiu $sp, $sp, 12  # Deallocate the space used on the stack for the 3 saved registers

 jr $ra  # Return to the calling procedure
