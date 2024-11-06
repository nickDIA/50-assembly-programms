.global _start

.section .data
num:        .quad 5            // Número del cual calcular el factorial (puedes cambiar este valor)
msg_factorial: .asciz "Factorial: "  // Mensaje de salida

.section .text
_start:
    // Cargar el número a calcular el factorial
    ldr x0, =num                // Cargar la dirección de num
    ldr x0, [x0]                // Cargar el valor del número en x0

    // Verificar si el número es 0 o 1 (el factorial de 0 y 1 es 1)
    cmp x0, #1
    ble factorial_is_1          // Si x0 <= 1, el factorial es 1

    // Si el número es mayor que 1, calcular el factorial
    mov x1, #1                  // Inicializar el resultado en 1
    mov x2, x0                  // Copiar el número original a x2 (lo usaremos como contador)

factorial_loop:
    mul x1, x1, x2              // multiplicar el resultado actual por x2
    sub x2, x2, #1              // decrementar x2
    cmp x2, #1                  // verificar si hemos llegado a 1
    bgt factorial_loop          // Si x2 > 1, continuar con el ciclo

factorial_is_1:
    // Imprimir el mensaje "Factorial: "
    ldr x0, =msg_factorial
    bl print_string

    // Imprimir el resultado
    mov x1, x1                  // El resultado del factorial está en x1
    bl print_number             // Imprimir el número (factorial)

    // Salir del programa
    mov x8, #93                 // syscall para exit (Linux ARM64)
    mov x0, #0                  // Código de salida 0
    svc #0                      // Llamada al sistema para salir

print_string:
    // Función para imprimir una cadena
    mov x1, x0                  // Dirección de la cadena
    mov x2, #0                  // Contador de longitud de la cadena
count_loop:
    ldrb w3, [x1, x2]           // Cargar un byte de la cadena
    cbz w3, done_counting       // Si es null terminator (fin de la cadena), salir
    add x2, x2, #1              // Incrementar contador
    b count_loop                // Continuar contando la longitud

done_counting:
    mov x0, x1                  // Dirección de la cadena
    mov x1, x2                  // Longitud de la cadena
    mov x8, #64                 // syscall número para write (en Linux ARM64)
    mov x2, x1                  // Longitud de la cadena
    svc #0                      // Llamada al sistema para imprimir la cadena
    ret

print_number:
    // Función para imprimir un número en decimal (x1 contiene el número a imprimir)
    mov x2, #10                 // Base 10 (decimal)
    mov x3, x1                  // Guardar el número en x3
    mov x4, #0                  // Limpiar el contador de dígitos

reverse_print:
    udiv x5, x3, x2             // Dividir el número entre 10, el cociente va en x5
    mul x6, x5, x2              // x6 = x5 * 10
    sub x7, x3, x6              // x7 = x3 - x6 (resto de la división, el dígito)
    add x7, x7, #48             // Convertir el dígito a ASCII
    strb w7, [sp, x4]           // Guardar el dígito en el stack
    mov x3, x5                  // Mover el cociente al siguiente paso
    add x4, x4, #1              // Incrementar el contador de dígitos
    cmp x3, #0                  // Verificar si ya no hay más dígitos
    bne reverse_print           // Si hay más dígitos, continuar dividiendo

    // Imprimir los dígitos
    mov x5, x4                  // Número de dígitos
    sub sp, sp, x5              // Reservar espacio en stack
    mov x4, sp                  // Dirección de los dígitos a imprimir

print_digits:
    ldrb w6, [x4], #1           // Cargar un byte (dígito)
    mov x0, w6                  // Mover el dígito a imprimir
    mov x8, #64                 // syscall número para write
    mov x1, x0                  // Escribir el carácter
    mov x2, #1                  // Longitud 1 (un solo carácter)
    svc #0                      // Llamada al sistema
    sub x5, x5, #1              // Decrementar el número de dígitos
    cmp x5, #0                  // Si no quedan más dígitos, terminar
    bgt print_digits            // Si quedan más, imprimir el siguiente

    add sp, sp, x4              // Restaurar el stack
    ret
