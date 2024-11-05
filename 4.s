/*
C# equivalent code:

using System;

class Program
{
    static void Main()
    {
        long num1 = 12;
        long num2 = 5;
        long result = num1 * num2;
        
        Console.Write("Result of multiplication: ");
        Console.WriteLine(result);
    }
}
*/

// ARM64 assembly program to multiply two numbers
.global _start            // Make _start visible to linker

.section .data
num1:    .quad 12         // First number
num2:    .quad 5          // Second number
result:  .quad 0          // Storage for result

msg:     .ascii "Result of multiplication: "
msglen = . - msg
newline: .ascii "\n"

.section .text
_start:
    // Load the address of num1 into X3 and then load value into X0
    adr     x3, num1
    ldr     x0, [x3]
    
    // Load the address of num2 into X3 and then load value into X1
    adr     x3, num2
    ldr     x1, [x3]
    
    // Multiply X0 by X1 and store in X2
    mul     x2, x0, x1
    
    // Store the result
    adr     x3, result   // Load address of result
    str     x2, [x3]     // Store X2 to address in X3
    
    // Print "Result of multiplication: "
    mov     x0, #1              // File descriptor 1 (stdout)
    adr     x1, msg             // Address of message
    mov     x2, msglen          // Length of message
    mov     x8, #64             // sys_write system call
    svc     #0                  // Make system call
    
    // Convert result to ASCII and print
    adr     x3, result          // Load address of result
    ldr     x0, [x3]            // Load result into X0
    bl      print_num
    
    // Print newline
    mov     x0, #1              // File descriptor 1 (stdout)
    adr     x1, newline         // Address of newline
    mov     x2, #1              // Length of newline
    mov     x8, #64             // sys_write system call
    svc     #0                  // Make system call
    
    // Exit program
    mov     x0, #0              // Return code 0
    mov     x8, #93             // sys_exit system call
    svc     #0                  // Make system call

// Function to print a number
print_num:
    // Save link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Prepare buffer for ASCII conversion
    sub     sp, sp, #16
    mov     x1, sp              // Buffer address
    mov     x2, #10             // Base 10
    
    // Convert to ASCII
    mov     x4, #0              // Counter for digits
convert_loop:
    mov     x3, x0              // Copy number
    udiv    x0, x3, x2          // Divide by 10
    msub    x3, x0, x2, x3      // Get remainder
    add     x3, x3, #'0'        // Convert to ASCII
    strb    w3, [x1, x4]        // Store digit
    add     x4, x4, #1          // Increment counter
    cbnz    x0, convert_loop    // Continue if quotient not zero
    
    // Print digits in reverse order
print_loop:
    sub     x4, x4, #1          // Decrement counter
    mov     x0, #1              // File descriptor 1 (stdout)
    add     x1, sp, x4          // Address of current digit
    mov     x2, #1              // Length 1
    mov     x8, #64             // sys_write system call
    svc     #0                  // Make system call
    cbnz    x4, print_loop      // Continue if more digits
    
    // Restore stack and return
    add     sp, sp, #16
    ldp     x29, x30, [sp], #16
    ret
