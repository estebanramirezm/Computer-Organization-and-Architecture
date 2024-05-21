## Project 2
## Date: 2 Oct, 2023
## Author: Esteban Ramirez
## Purpose: AtoI function in MIPS from C code 

.data
line:      .space 20
msg_demo:  .asciiz "Demonstrate ascii to integer\n\n"
msg_input: .asciiz "Enter a string of digits: "
msg_output:.asciiz "Integer value is: "

.text
.globl main

# This converts an ascii number to an integer
    ## int atoi(char s[])
    ## Arguments: $a0 = address of string s[]
    ## Returns: $v0 = integer result
atoi:
    li   $v0, 0           # result = 0
    li   $t1, 0           # i = 0
    
atoi_loop:
    lbu  $t0, 0($a0)       # Load byte from s[i] to $t0 (unsigned)
    addi $t2, $zero, 10
    beq  $t0, $t2, atoi_done # If s[i] == '\0', exit loop
    
    mul  $v0, $v0, 10     # result *= 10
    sub  $t0, $t0, 48     # s[i] - '0'
    add  $v0, $v0, $t0    # result += s[i] - '0'
    addi $a0, $a0, 1      # Increment address for next byte (i++)
    j    atoi_loop        # Go to the beginning of the loop
    
atoi_done:
    jr   $ra              # Return with result in $v0

# This is the main driver
main:
    la   $a0, msg_demo
    jal  print_string     # print demo message
    
    la   $a0, msg_input
    jal  print_string     # print input message
    
    la   $a0, line
    jal  read_string      # read input to line array
    
    la   $a0, line
    jal  atoi             # n = atoi(line), result will be in $v0
    
    add $t4, $zero, $v0

    la   $a0, msg_output
    jal  print_string     # print output message
    
    move $a0, $t4         # move result of atoi to $a0
    jal  print_int        # print integer value
    
    li   $v0, 10          # syscall for program exit
    syscall

# This function prints text  
print_string:
    # void print_string(char* s)
    # Arguments: $a0 = address of string s
    li   $v0, 4           # syscall code for print string
    syscall
    jr   $ra              # return

# This function reads a string of characters  
read_string:
    # void read_string(char* s)
    # Arguments: $a0 = address of buffer
    li   $v0, 8           # syscall code for read string
    li   $a1, 20          # size of the buffer
    syscall
    jr   $ra              # return

# This function prints an integer value  
print_int:
    # void print_int(int n)
    # Arguments: $a0 = integer n
    li   $v0, 1           # syscall code for print integer
    syscall
    jr   $ra              # return
