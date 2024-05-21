# Project #6
# Author: Esteban Ramirez
# Date: Nov 8th, 2023
# Purpose: Calculates and returns an approximation of the value of PI using a series

.data
greeting: .asciiz "Welcome to this PI approximator!\n"
prompt: .asciiz "\nEnter the number of terms to approximate PI (less than 1 to exit): "
result: .asciiz "Approximation of PI: "
goodbye: .asciiz "\nThanks for running this program!"

.text
.globl main

# Calculates and returns an approximation of the value of PI using a series
main:
    # Set up stack frame for main
    addiu $sp, $sp, -8  # Allocate space for 2 items on the stack
    sw $ra, 4($sp)      # Save return address

    # Save the return address in $s0
    move $s0, $ra

    # Greeting message
    li $v0, 4
    la $a0, greeting
    syscall

    # Run the program
    jal input

    # Goodbye message
    li $v0, 4
    la $a0, goodbye
    syscall

    # Restore the return address from $s0 before exiting
    move $ra, $s0

    # Clean up the stack and exit
    lw $ra, 4($sp)       # Load the return address back into $ra
    addiu $sp, $sp, 8
    jr $ra

# Gathers input from the user
input:
    addiu $sp, $sp, -4  # Allocate space on the stack for the return address
    sw $ra, 0($sp)      # Save the return address on the stack

    # Loops the user input prompt while keeping the return address safe out of the loop
    inputLoop:
        # Prompt the user for input
        li $v0, 4
        la $a0, prompt
        syscall

        # Read the user's input (number of terms)
        li $v0, 5
        syscall

        # If it's more than 0, run the pi algorithm
        bgtz $v0, runAlgorithm

        # Return to main
        lw $ra, 0($sp)      # Restore the return address from the stack
        addiu $sp, $sp, 4   # Deallocate space from the stack
        jr $ra              # Return to the caller

# If input is greater than 0, then proceeds to run the PI approximator and displays the result
runAlgorithm:
    # Save number of terms to $a0 for the procedure call
    move $a0, $v0
            
    # Call the PI approximation procedure
    jal approximatePi

    # Display the result
    li $v0, 4
    la $a0, result
    syscall

    # Display the value of PI
    mov.s $f12, $f0
    li $v0, 2
    syscall
        
    # New line
    li $v0, 11
    li $a0, 0x0A
    syscall

    # Repeat procedure
    j inputLoop

# Algorithm that calculates the PI approximation with the given series
approximatePi:
    # Set up stack frame for approximatePi
    addiu $sp, $sp, -20  # Allocate space for 5 items on the stack
    sw $ra, 16($sp)      # Save return address
    sw $a0, 12($sp)      # Save the number of terms
    sw $t1, 8($sp)       # Save temporary register
    sw $t2, 4($sp)       # Save temporary register
    sw $t3, 0($sp)       # Save temporary register

    # Initialize the variables
    li.s $f2, 0.0    # pi = 0.0
    li $t1, 1        # den = 1
    li $t2, 0        # i = 0

    # Loop that iteratively approximates PI using the formula
    loopApprox:
        # Check if the loop is done
        bge $t2, $a0, endApprox

        # Convert denominator to float
        mtc1 $t1, $f4
        cvt.s.w $f4, $f4

        # Calculate 4.0 / den
        li.s $f6, 4.0
        div.s $f4, $f6, $f4

        # Determine if we should add or subtract
        andi $t3, $t2, 1
        beqz $t3, addTerm
        sub.s $f2, $f2, $f4
        j updateTerms

    # Add the current term to the PI approximation
    addTerm:
        add.s $f2, $f2, $f4

    # Update the terms for the next iteration of the loop
    updateTerms:
        addi $t1, $t1, 2
        addi $t2, $t2, 1
        j loopApprox

    # Finish the PI approximation and clean up the stack
    endApprox:
        # Return the result
        mov.s $f0, $f2

        # Restore registers and return
        lw $ra, 16($sp)
        lw $a0, 12($sp)
        lw $t1, 8($sp)
        lw $t2, 4($sp)
        lw $t3, 0($sp)
        addiu $sp, $sp, 20
        jr $ra
 