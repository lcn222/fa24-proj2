.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    
    li t0, 1
    blt a2, t0, error_number
    blt a3, t0, error_stride
    blt a4, t0, error_stride

    mv t0, x0
    mv t6, x0
loop_start:
    bge t0, a2, loop_end
    
    # Calculate the address of arr0[t0] using stride a3
    slli t1, t0, 2  
    mul t1, t1, a3
    add t1, t1, a0                
    lw t2, 0(t1)             
    
    # Calculate the address of arr1[t0] using stride a4
    slli t3, t0, 2     
    mul t3, t3, a4    
    add t3, t3, a1           
    lw t4, 0(t3)       
    
    # Compute dot product increment
    mul t5, t2, t4           # t5 = arr0[t0] * arr1[t0]
    add t6, t6, t5           # Add result to current dot product

    addi t0, t0, 1
    j loop_start
loop_end:

    
    # Epilogue
    
    mv a0, t6

    jr ra
error_number:
    li a0, 36
    j exit
error_stride:
    li a0, 37
    j exit