# Project #8
# Author: Esteban Ramirez
# Description: This is a linked list implementation based on C code
# Date: December 6th, 2023

.data
    greeting: .asciiz "Welcome!\n"
    prompt: .asciiz "\nLinked-list Program\n\n1. Add an integer\n2. Remove an integer\n3. Print the list\n4. Quit\nSelect option: "
    enterInt: .asciiz "\nEnter integer to add: "
    enterPos: .asciiz "Enter position (1, 2, etc.): "
    invalid: .asciiz "\nInvalid option\n\n"
    enterPosRemove: .asciiz "\nEnter position of item to remove: "
    separator: .asciiz " "
    endSymbol: .asciiz "//\n"
    list: .asciiz "\nList: "
    goodbye: .asciiz "\nThanks for running this program!"

.text
.globl main

# This is a linked list implementation based on C code
main:
    # Set up stack frame for main
    addiu $sp, $sp, -8  # Allocate space for 2 items on the stack
    sw $ra, 4($sp)      # Save return address

    # Greeting message
    li $v0, 4
    la $a0, greeting
    syscall

    # Node* head = 0;
    li $t0, 0  # $t0 will be used as the head pointer

    # Main loop
    mainLoop:
        # Display menu
        li $v0, 4
        la $a0, prompt
        syscall

        # Read option
        li $v0, 5
        syscall
        move $t1, $v0  # $t1 will hold the user's option

        # Option handling
        beq $t1, 1, addItem
        beq $t1, 2, removeItem
        beq $t1, 3, printList
        bne $t1, 4, invalidOption

        # Goodbye
        li $v0, 4
        la $a0, goodbye
        syscall

        # Clean up the stack and exit
        addiu $sp, $sp, 8
        jr $ra

# Adds an item to the linked list
addItem:
    # Read integer to add
    li $v0, 4
    la $a0, enterInt
    syscall

    # Read integer system call
    li $v0, 5
    syscall
    move $t2, $v0  # Store integer in $t2

    # Read position
    li $v0, 4
    la $a0, enterPos
    syscall

    # Read integer
    li $v0, 5  
    syscall
    move $t3, $v0  # Store position in $t3

    # Allocate memory for new node
    li $v0, 9       # sbrk system call
    li $a0, 8       # Assuming size of Node is 8 bytes (4 bytes for int and 4 for pointer)
    syscall
    move $t4, $v0   # Address of new node in $t4

    # Initialize new node
    sw $t2, 0($t4)  # Set item
    sw $zero, 4($t4) # Set next to NULL

    # Special case: insertion at the head of the list
    li $t5, 1       # Load 1 in $t5 for comparison
    beq $t3, $t5, insertAtHead

    # General case: insertion at a given position
    move $t6, $t0   # Current node pointer starts at head ($t0)
    move $t7, $zero # Previous node pointer
    li $t8, 1       # Index

    # Iterates through a linked list to find the correct insertion position for a new node.
    findPosition:
        beq $t6, $zero, insertAtEnd # End of list reached before position
        bge $t8, $t3, doInsert       # Position found
        move $t7, $t6                 # Update previous node pointer
        lw $t6, 4($t6)                # Move to next node
        addi $t8, $t8, 1              # Increment index
        j findPosition

    # Inserts a new node at the beginning of the linked list.
    insertAtHead:
        sw $t0, 4($t4)   # New node's next points to current head
        move $t0, $t4    # Head points to new node
        j returnFromAdd
    
    # Inserts a new node at a found position within the linked list.
    doInsert:
        sw $t6, 4($t4)   # New node's next points to current node
        beq $t7, $zero, updateHead   # If previous is NULL, update head
        sw $t4, 4($t7)   # Previous node's next points to new node
        j returnFromAdd

    # Inserts a new node at the end of the linked list.
    insertAtEnd:
        beq $t7, $zero, updateHead   # If list is empty, update head
        sw $t4, 4($t7)   # Previous node's next points to new node
        j returnFromAdd

    # Updates the head of the linked list.
    updateHead:
        move $t0, $t4    # Update head to new node

    # Returns control to the main loop after insertion operation.
    returnFromAdd:
        j mainLoop

# Removes an item from the linked list
removeItem:
    # Prompt user to enter the position of the item to remove
    li $v0, 4
    la $a0, enterPosRemove
    syscall

    # Read the position
    li $v0, 5   
    syscall
    move $t2, $v0  # Store position in $t2

    # Check for empty list or invalid position
    blez $t2, endRemoveItem # Position is less than or equal to 0, invalid
    beq $t0, $zero, endRemoveItem  # List is empty

    # Special case: removing the head of the list
    li $t3, 1       
    beq $t2, $t3, removeHead

    # General case: removing from a given position
    move $t8, $t0   # Current node (cur) pointer starts at head ($t0)
    move $t9, $zero # Previous node (prev) pointer
    li $t6, 1       # Index (starting from 1)

    # Iterates through a linked list to find the correct position for removal.
    findRemovePosition:
        beq $t8, $zero, endRemoveItem # End of list reached, position not found
        beq $t6, $t2, doRemove         # Position found
        move $t9, $t8                   # prev = cur
        lw $t8, 4($t8)                  # cur = cur->next
        addi $t6, $t6, 1                # Increment index
        j findRemovePosition

    # Removes the head node from the linked list.
    removeHead:
        lw $t7, 4($t0)    # $t7 = head->next
        move $t0, $t7     # head = head->next
        j endRemoveItem

    # Removes a node from a specified position in the linked list.
    doRemove:
        lw $t7, 4($t8)    # $t7 = cur->next
        sw $t7, 4($t9)    # prev->next = cur->next
        j endRemoveItem

    # Concludes the item removal process and returns to the main loop.
    endRemoveItem:
        j mainLoop

# Prints the entire linked list.
printList:
    # Print list heading
    li $v0, 4
    la $a0, list
    syscall

    # Start from the head of the list using a temporary register
    move $t8, $t0 

    # Iterates through the linked list to print each node's data.
    printLoop:
        beq $t8, $zero, endPrint  # If the current node is NULL, end the loop
        lw $t1, 0($t8)  # Load the item from the node
        li $v0, 1       # Print integer
        move $a0, $t1   # Move the item to $a0 for printing
        syscall

        # Print separator
        li $v0, 4
        la $a0, separator
        syscall

        # Move to the next node
        lw $t8, 4($t8)
        j printLoop

    # Marks the end of the printing process and returns to the main loop.
    endPrint:
        li $v0, 4
        la $a0, endSymbol
        syscall

        j mainLoop

# Handles invalid inputs in the selection meny
invalidOption:
    li $v0, 4
    la $a0, invalid
    syscall

    j mainLoop

