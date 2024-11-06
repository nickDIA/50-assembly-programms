.global _start

.section .data
num:        .quad 29              // Número a verificar (puedes cambiar este número)
result:     .asciz "Es primo\n"    // Mensaje si es primo
not_prime:  .asciz "No es primo\n" // Mensaje si no es primo

.section .text
_start:
    // Cargar el número a verificar
    ldr x0, =num                // Dirección del número a verificar
    ldr x0, [x0]                // Cargar el valor del número en x0

    // Verificar si el número es menor o igual a 1
    cmp x0, #1
    ble not_prime_label         // Si x0 <= 1, no es primo

    // Verificar divisibilidad desde 2 hasta la raíz cuadrada de x0
    mov x1, #2                  // Iniciar divisor en 2
    mov x2, x0                  // Copiar el número original en x2
    sqrt x2, x2                 // Obtener la raíz cuadrada de x0

check_divisibility:
    cmp x1, x2                  // Si el divisor es mayor que la raíz cuadrada, terminar
    bgt prime_label

    // Verificar si el número es divisible por x1
    udiv x3, x0, x1             // x3 = x0 / x1
    mul x3, x3, x1              // x3 = x3 * x1
    cmp x3, x0                  // Si x3 == x0, entonces x0 es divisible por x1
    beq not_prime_label         // Si x0 es divisible por x1, no es primo

    // Incrementar el divisor
    add x1, x1, #1
    b check_divisibility        // Continuar verificando el siguiente divisor

prime_label:
    // El número es primo, imprimir "Es primo"
    ldr x0, =result             // Cargar la dirección del mensaje "Es primo"
    bl print_string
    b exit_program              // Terminar el programa

not_prime_label:
    // El número no es primo, imprimir "No es primo"
    ldr x0, =not_prime          // Cargar la dirección del mensaje "No es primo"
    bl print_string

exit_program:
    // Terminar el programa
    mov x8, #93                 // syscall para exit (en Linux ARM64)
    mov x0, #0                  // Código de salida 0
    svc #0                      // Llamar al sistema

print_string:
    // Función para imprimir una cadena
    mov x1, x0                  // Dirección de la cadena
    mov x2, #0                  // Contador de longitud de la cadena
count_loop:
    ldrb x3, [x1, x2]           // Cargar un byte de la cadena
    cbz x3, done_counting       // Si es null terminator (fin de la cadena), salir
    add x2, x2, #1              // Incrementar contador
    b count_loop                // Continuar contando la longitud

done_counting:
    mov x0, x1                  // Dirección de la cadena
    mov x1, x2                  // Longitud de la cadena
    mov x8, #64                 // syscall número para write (en Linux ARM64)
    mov x2, x1                  // Longitud de la cadena
    svc #0                      // Llamada al sistema para imprimir la cadena
    ret
