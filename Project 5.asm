# File: Project #5
# Author: Esteban Ramirez
# Purpose: Converts a floating-point number to an 8-digit hexadecimal representation (in the IEEE 754 format)
# Date: October 30th, 2023

# Strings for program's interface
.data
    greeting: .asciiz "IEEE 754 Floating-point to Hexadecimal Converter"
    prompt: .asciiz "\n\nEnter a floating-point number: "
    hexChars: .asciiz "0123456789ABCDEF"
    hexPrefix: .asciiz "0x"
    goodbye: .asciiz "\n\nThanks for running this program!"

.text
    .globl main

# Converts a floating-point number to an 8-digit hexadecimal representation (in the IEEE 754 format) based on the user's input
main:
    # Allocate stack space for the return address (procedure frame)
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Print the prompt to ask the user for input
    li $v0, 4               # print string syscall identifier
    la $a0, greeting
    syscall

    # Print the prompt to ask the user for input
    li $v0, 4               # print string syscall identifier
    la $a0, prompt
    syscall

    # Read the floating-point number
    li $v0, 6               # read float syscall identifier
    syscall
    mov.s $f12, $f0         # Move the read float to $f12

    # Call the procedure to display the 32-bit representation
    jal displayFloat

    # Goodbye message
    li $v0, 4
    la $a0, goodbye
    syscall

    # Deallocate stack space and load the return address to finalize the program's execution
    lw $ra, 0($sp)
    addi $sp, $sp, 4

    # Exit the program
    jr $ra                  # Return using jr $ra instead of syscall


# Displays the 32-bit representation of the floating-point number
displayFloat:
    # Allocate stack space for saved registers
    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $t1, 0($sp)          # Save $t1 register

    mfc1 $t0, $f12          # Move the float from $f12 to integer register $t0

    # Print "0x" prefix
    li $v0, 4
    la $a0, hexPrefix
    syscall

    li $t1, 28              # Shift right 4 bits at a time, starting with 28 bits

# Take a binary representation of a floating-point number and convert it into a hexadecimal string 
# by processing each 4-bit segment sequentially until the entire number has been converted
hexLoop:
    # Shift the integer right by the number of positions in $t1
    srl $t2, $t0, $t1       # Shift right logical
    andi $t2, $t2, 0xF      # Isolate the rightmost 4 bits

    # Get the hexadecimal character
    la $t3, hexChars       # Load address of the hex_chars
    add $t3, $t3, $t2       # Get address of the correct character
    lb $a0, 0($t3)          # Load the byte (character) at this address

    # Print the character
    li $v0, 11              # print char syscall identifier
    syscall

    # Prepare for the next iteration
    addi $t1, $t1, -4       # Move to the next 4 bits
    bgez $t1, hexLoop      # If we have shifted less than 32 bits, repeat the loop

    # Restore saved registers and return address
    lw $t1, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    jr $ra                  # Return to the caller
