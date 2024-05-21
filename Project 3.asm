# Project #3
# Author: Esteban Ramirez
# Date: October 9th, 2023
# Purpose: Runs a Hanoi Tower algorithm

# Text-strings labels
.data
    moveMsg:   .asciiz "Move disk"
    fromMsg:   .asciiz "from peg"
    toMsg:     .asciiz "to peg"
    newline:   .asciiz ".\n"
    prompt:    .asciiz "Enter number of disks: "
    welcomeMsg: .asciiz "Welcome! This is a Hanoi Tower Puzzle solver program.\n"
    thankYouMsg: .asciiz "Thanks for running this program!\n"

.text

# Hanoi Function Algorithm
hanoi:
    # Save registers and return address
    addiu $sp, $sp, -20     # make room on stack for 5 words
    sw $ra, 16($sp)         # save return address
    sw $a0, 0($sp)         # save n
    sw $a1, 4($sp)         # save start
    sw $a2, 8($sp)         # save finish
    sw $a3, 12($sp)        # save extra

    # Base case: if n == 0, return
    beq $a0, $zero, end_hanoi

    # Call hanoi(n-1, start, extra, finish)
    addi $a0, $a0, -1
    sw $a2, 8($sp)         # switch finish and extra
    sw $a3, 12($sp)
    jal hanoi

    # Print the move message
    la $a0, moveMsg
    jal print_string

    lw $a0, 0($sp)         # Load n
    jal print_int

    la $a0, fromMsg
    jal print_string

    lw $a0, 4($sp)         # Load start
    jal print_int

    la $a0, toMsg
    jal print_string

    lw $a0, 8($sp)         # Load finish
    jal print_int

    la $a0, newline
    jal print_string

    # Call hanoi(n-1, extra, finish, start)
    lw $a0, 0($sp)         # Load n back
    addi $a0, $a0, -1
    lw $a1, 12($sp)        # Load extra
    lw $a2, 8($sp)         # Load finish
    lw $a3, 4($sp)         # Load start
    jal hanoi

end_hanoi:
    # Restore registers and return
    lw $ra, 16($sp)        # restore return address
    addiu $sp, $sp, 20     # restore stack pointer
    jr $ra                 # return to caller

# Print string pointed by $a0
print_string:
    li $v0, 4      # load syscall code for print_string
    syscall        # make the system call
    jr $ra         # return to caller

# print_int function: print integer in $a0
print_int:
    li $v0, 1      # load syscall code for print_int
    syscall        # make the system call
    jr $ra         # return to caller

# read_int function: read an integer and return in $v0
read_int:
    li $v0, 5      # load syscall code for read_int
    syscall        # make the system call
    move $v0, $v0  # the read integer is already in $v0
    jr $ra         # return to caller

# Asks the user for a number of disks, runs the Hanoi Tower algorithm, and returns the values
main:
    # Greeting
    la $a0, welcomeMsg
    jal print_string
    la $a0, newline
    jal print_string

    # Ask the user for input
    la $a0, prompt
    jal print_string
    jal read_int
    move $a0, $v0          # Copy the value of n from $v0 to $a0

    # Call hanoi with n, 1, 2, 3
    li $a1, 1      # a1 = 1 (start peg)
    li $a2, 2      # a2 = 2 (finish peg)
    li $a3, 3      # a3 = 3 (extra peg)
    jal hanoi

    # Goodbye
    la $a0, newline
    jal print_string
    la $a0, thankYouMsg
    jal print_string

    # End of main function
    jr $ra
