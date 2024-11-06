.global _start

.section .data
n_terms: .quad 10            // Número de términos de Fibonacci a generar
msg_fib: .asciz "Fibonacci: " // Mensaje inicial

.section .text
_start:
    // Cargar el número de términos (n) de Fibonacci a generar
    ldr x0, =n_terms          // Cargar la dirección de n_terms
    ldr x0, [x0]              // Cargar el valor de n_terms

    // Imprimir el mensaje inicial
    ldr x1, =msg_fib
    bl print_string

    // Inicializar los primeros dos términos de Fibonacci
    mov x2, #0                // F(0) = 0
    mov x3, #1                // F(1) = 1
    mov x4, #2                // Contador de términos calculados, empieza en 2

    // Imprimir F(0) y F(1)
    bl print_fib_number       // Imprimir F(0)
    mov x1, x3                // Mover F(1) a x1 para imprimir
    bl print_fib_number       // Imprimir F(1)

    // Calcular los siguientes términos de la serie de Fibonacci
fibonacci_loop:
    cmp x4, x0                // Comparar contador (x4) con n_terms
    bge end_program           // Si hemos generado los n términos, salir

    add x5, x2, x3            // F(n) = F(n-1) + F(n-2)
    mov x2, x3                // F(n-2) = F(n-1)
    mov x3, x5                // F(n-1) = F(n)

    // Imprimir el número Fibonacci actual
    mov x1, x3                // Cargar el siguiente número de Fibonacci
    bl print_fib_number       // Imprimir el número Fibonacci actual

    add x4, x4, #1            // Incrementar el contador de términos
    b fibonacci_loop          // Repetir el ciclo

end_program:
    // Terminar el programa
    mov x8, #93               // syscall para exit (Linux ARM64)
    mov x0, #0                // Código de salida 0
    svc #0                    // Llamada al sistema

print_fib_number:
    // Función para imprimir un número en el registro x1
    mov x2, #10               // Base 10 (decimal)
    mov x3, x1                // Guardar el número en x3
    mov x4, #0                // Limpiar el contador de dígitos

reverse_print:
    udiv x5, x3, x2           // Dividir el número entre 10, el cociente va en x5
    mul x6, x5, x2            // x6 = x5 * 10
    sub x7, x3, x6            // x7 = x3 - x6 (resto de la división, el dígito)
    add x7, x7, #48           // Convertir el dígito a ASCII
    strb x7, [sp, x4]         // Guardar el dígito en el stack
    mov x3, x5                // Mover el cociente al siguiente paso
    add x4, x4, #1            // Incrementar el contador de dígitos
    cmp x3, #0                // Verificar si ya no hay más dígitos
    bne reverse_print         // Si hay más dígitos, continuar dividiendo

    // Imprimir los dígitos
    mov x5, x4                // Número de dígitos
    sub sp, sp, x5            // Reservar espacio en stack
    mov x4, sp                // Dirección de los dígitos a imprimir

print_digits:
    ldrb x6, [x4], #1         // Cargar un byte (dígito)
    mov x0, x6                // Mover el dígito a imprimir
    mov x8, #64               // syscall número para write
    mov x1, x0                // Escribir el carácter
    mov x2, #1                // Longitud 1 (un solo carácter)
    svc #0                    // Llamada al sistema
    sub x5, x5, #1            // Decrementar el número de dígitos
    cmp x5, #0                // Si no quedan más dígitos, terminar
    bgt print_digits          // Si quedan más, imprimir el siguiente

    add sp, sp, x4            // Restaurar el stack
    ret

print_string:
    // Función para imprimir una cadena
    mov x1, x0                // Dirección de la cadena
    mov x2, #0                // Contador de longitud de la cadena
count_loop:
    ldrb x3, [x1, x2]         // Cargar un byte de la cadena
    cbz x3, done_counting     // Si es null terminator (fin de la cadena), salir
    add x2, x2, #1            // Incrementar contador
    b count_loop              // Continuar contando la longitud

done_counting:
    mov x0, x1                // Dirección de la cadena
    mov x1, x2                // Longitud de la cadena
    mov x8, #64               // syscall número para write
    mov x2, x1                // Longitud de la cadena
    svc #0                    // Llamada al sistema para imprimir la cadena
    ret
