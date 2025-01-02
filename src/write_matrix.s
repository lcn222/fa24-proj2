.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -40
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw s0, 16(sp)
    sw s1, 20(sp)
    sw s2, 24(sp)
    sw s3, 28(sp)
    sw s4, 32(sp)
    sw ra, 36(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    
    li a1, 1
    jal fopen
    li t0, -1
    beq a0, t0, error_open
    
    mv s4, a0 # s4 store the return code of fopen
    li a0, 8
    jal malloc
    
    mv s0, a0
    sw s2, 0(s0)
    sw s3, 4(s0)
    
    # write rows and columns
    mv a0, s4
    mv a1, s0
    li a2, 2
    li a3, 4
    jal fwrite
    li t0, 2
    bne a0, t0, error_write
    
    
    # write matrix
    mv a0, s4
    mv a1, s1
    mul a2, s2, s3
    li a3, 4
    jal fwrite
    mul t0, s2, s3
    bne a0, t0, error_write
    
    # close file
    mv a0, s4
    jal fclose
    blt a0, x0, error_close


    # Epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw s0, 16(sp)
    lw s1, 20(sp)
    lw s2, 24(sp)
    lw s3, 28(sp)
    lw s4, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    
    jr ra

error_open:
    li a0, 27
    j exit
error_close:
    li a0, 28
    j exit
error_write:
    li a0, 30
    j exit