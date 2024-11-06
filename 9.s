// Programa en ensamblador ARM de 64 bits para verificar si un número fijo es primo
// Guardar este archivo como primo.s y compilar con:
// $ as -o primo.o primo.s
// $ ld -o primo primo.o
// Ejecutar con:
// $ ./primo
//si el 

.section .text
    .global _start

_start:
    // Definir el número a verificar, por ejemplo, 13
    mov x0, 13                      // Número a verificar si es primo
    mov x1, 2                       // Inicializar divisor en 2

check_prime_loop:
    // Comprobar si el divisor x1 al cuadrado es mayor que x0
    mul x2, x1, x1                  // x2 = x1 * x1
    cmp x2, x0                      // Comparar x2 con el número x0
    bgt is_prime                    // Si x2 > x0, el número es primo

    // Verificar si el número es divisible por el divisor actual
    udiv x3, x0, x1                 // x3 = x0 / x1 (división entera)
    msub x3, x3, x1, x0             // x3 = x0 - (x3 * x1), es decir, el residuo de x0 / x1
    cbz x3, not_prime               // Si x3 es 0, x0 es divisible, no es primo

    // Incrementar el divisor y continuar
    add x1, x1, 1                   // Incrementar divisor
    b check_prime_loop              // Repetir el bucle

is_prime:
    // Aquí se llega si el número es primo
    mov x0, 1                       // Resultado 1 (indica primo)
    b end_program

not_prime:
    // Aquí se llega si el número no es primo
    mov x0, 0                       // Resultado 0 (indica no primo)

end_program:
    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    svc 0                           // Llamada al sistema
