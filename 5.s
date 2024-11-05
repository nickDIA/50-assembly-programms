/*
C# equivalent code:

using System;

class Program
{
    static void Main()
    {
        long num1 = 100;  // dividend
        long num2 = 5;    // divisor
        
        long quotient = num1 / num2;
        long remainder = num1 % num2;
        
        Console.Write("Quotient: ");
        Console.WriteLine(quotient);
        Console.Write("Remainder: ");
        Console.WriteLine(remainder);
    }
}

// More robust version with error checking:
class ProgramWithErrorChecking
{
    static void Main()
    {
        long num1 = 100;  // dividend
        long num2 = 5;    // divisor
        
        try
        {
            if (num2 == 0)
                throw new DivideByZeroException();
                
            long quotient = num1 / num2;
            long remainder = num1 % num2;
            
            Console.Write("Quotient: ");
            Console.WriteLine(quotient);
            Console.Write("Remainder: ");
            Console.WriteLine(remainder);
        }
        catch (DivideByZeroException)
        {
            Console.WriteLine("Error: Cannot divide by zero!");
        }
    }
}
*/

// ARM64 assembly program to divide two numbers
.global _start            // Make _start visible to linker

.section .data
num1:    .quad 100        // First number (dividend)
num2:    .quad 5          // Second number (divisor)
result:  .quad 0          // Storage for quotient
remain:  .quad 0          // Storage for remainder

msg1:    .ascii "Quotient: "
msg1len = . - msg1
msg2:    .ascii "\nRemainder: "
msg2len = . - msg2
newline: .ascii "\n"

.section .text
_start:
    // Load the address of num1 into X3 and then load value into X0
    adr     x3, num1
    ldr     x0, [x3]
    
    // Load the address of num2 into X3 and then load value into X1
    adr     x3, num2
    ldr     x1, [x3]
    
    // Divide X0 by X1
    udiv    x2, x0, x1      // X2 = X0 ÷ X1 (quotient)
    
    // Calculate remainder using msub (multiply and subtract)
    msub    x4, x2, x1, x0  // X4 = X0 - (X2 * X1) remainder
    
    // Store the results
    adr     x3, result
    str     x2, [x3]        // Store quotient
    adr     x3, remain
    str     x4, [x3]        // Store remainder
    
    // Print "Quotient: "
    mov     x0, #1          // File descriptor 1 (stdout)
    adr     x1, msg1        // Address of message
    mov     x2, msg1len     // Length of message
    mov     x8, #64         // sys_write system call
    svc     #0
    
    // Print quotient
    adr     x3, result
    ldr     x0, [x3]        // Load quotient into X0
    bl      print_num
    
    // Print "Remainder: "
    mov     x0, #1          // File descriptor 1 (stdout)
    adr     x1, msg2        // Address of message
    mov     x2, msg2len     // Length of message
    mov     x8, #64         // sys_write system call
    svc     #0
    
    // Print remainder
    adr     x3, remain
    ldr     x0, [x3]        // Load remainder into X0
    bl      print_num
    
    // Print final newline
    mov     x0, #1          // File descriptor 1 (stdout)
    adr     x1, newline     // Address of newline
    mov     x2, #1          // Length of newline
    mov     x8, #64         // sys_write system call
    svc     #0
    
    // Exit program
    mov     x0, #0          // Return code 0
    mov     x8, #93         // sys_exit system call
    svc     #0

// Function to print a number
print_num:
    // Save link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Prepare buffer for ASCII conversion
    sub     sp, sp, #16
    mov     x1, sp          // Buffer address
    mov     x2, #10         // Base 10
    
    // Convert to ASCII
    mov     x4, #0          // Counter for digits
convert_loop:
    mov     x3, x0          // Copy number
    udiv    x0, x3, x2      // Divide by 10
    msub    x3, x0, x2, x3  // Get remainder
    add     x3, x3, #'0'    // Convert to ASCII
    strb    w3, [x1, x4]    // Store digit
    add     x4, x4, #1      // Increment counter
    cbnz    x0, convert_loop // Continue if quotient not zero
    
    // Print digits in reverse order
print_loop:
    sub     x4, x4, #1      // Decrement counter
    mov     x0, #1          // File descriptor 1 (stdout)
    add     x1, sp, x4      // Address of current digit
    mov     x2, #1          // Length 1
    mov     x8, #64         // sys_write system call
    svc     #0              // Make system call
    cbnz    x4, print_loop  // Continue if more digits
    
    // Restore stack and return
    add     sp, sp, #16
    ldp     x29, x30, [sp], #16
    ret
