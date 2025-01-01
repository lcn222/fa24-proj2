.globl matmul
.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    ebreak
    # Error checks
    li t0, 1
    blt a1, t0, exception
    blt a2, t0, exception
    blt a4, t0, exception
    blt a5, t0, exception
    bne a1, a5, exception

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    # Set loop parameter
    mv t0, x0
    mv t1, x0
    
outer_loop_start:
    bge t0, a1, outer_loop_end



inner_loop_start:
    bge t1, a5, inner_loop_end

    # Prologue
    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw t0, 20(sp)
    sw t1, 24(sp)
    
    # set argument
    mv a1, a3
    li a3, 1
    mv a4, a5
    # call dot
    jal dot
    
    # set dot result to t2
    mv t2, a0
    
    # Epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw t0, 20(sp)
    lw t1, 24(sp)
    addi sp, sp, 28
    
    # store t2 to a6
    mv t3, t0
    addi t3, t3, 1
    mul t4, t3, t1
    slli t4, t4, 2
    add t4, t4, a6
    sw t2, 0(t4)


    addi t1, t1, 1
    j inner_loop_start

inner_loop_end:
    
    addi t0, t0, 1
    j outer_loop_start

outer_loop_end:


    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4

    jr ra
exception:
    li a0, 38
    j exit