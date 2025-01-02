.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw s0, 16(sp)
    sw s1, 20(sp)
    sw s2, 24(sp)
    sw s3, 28(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    # open the file, set to only read
    li a1, 0
    jal fopen
    # if a0 == -1, open fail
    li t0, -1
    beq a0, t0, error_open
    
    mv a1, s1
    # prologue
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    # read the number of rows
    li s3, 4
    mv a2, s3
    jal fread
    # if read fail, jump
    bne a0, s3, error_read
    
    # epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
    
    # prologue
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    #read the number of column
    mv a1, s2
    mv a2, s3
    jal fread
    # if read fail, jump
    bne a0, s3, error_read
    
    # epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
    # load the number of rows and columns
    lw t1, 0(s1)
    lw t2, 0(s2)
    ebreak
    # calculate the number of bytes to malloc, store it to s3 for next read
    mul s3, t1, t2
    slli s3, s3, 2
    
    # prologue
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t1, 12(sp)
    sw t2, 16(sp)
    
    mv a0, s3 # set a0 as number of bytes to malloc
    
    jal malloc
    
    # if malloc fail, jump
    beq a0, x0, error_malloc
    # set s0 to a pointer to the allocated memory
    mv s0, a0
    
    # epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t1, 12(sp)
    lw t2, 16(sp)
    
    addi sp, sp, 20
    
    
    
    # prologue
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    
    mv a1, s0
    mv a2, s3
    
    jal fread
    
    # if read fail, jump
    bne a0, s3, error_read
    # epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
    
    # close the file
    jal fclose
    li t0, -1
    beq a0, t0, error_close
    mv t3, s0
    # Epilogue
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw s0, 16(sp)
    lw s1, 20(sp)
    lw s2, 24(sp)
    lw s3, 28(sp)
    addi sp, sp, 32
    mv a0, t3
    jr ra
error_malloc:
    li a0, 26
    j exit
error_open:
    li a0, 27
    j exit
error_close:
    li a0, 28
    j exit
error_read:
    li a0, 29
    j exit