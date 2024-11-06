// Programa en ensamblador ARM de 64 bits para calcular la serie de Fibonacci hasta un número fijo
// Guardar este archivo como fibonacci.s y compilar con:
// $ as -o fibonacci.o fibonacci.s
// $ ld -o fibonacci fibonacci.o
// Ejecutar con:
// $ ./fibonacci

.section .text
    .global _start

_start:
    // Definir el número de términos de Fibonacci que queremos calcular, por ejemplo, 10
    mov x0, 10                      // Número de términos de la serie de Fibonacci no confundir con el número de término que buscamos
    mov x1, 0                       // F(0)
    mov x2, 1                       // F(1)
    mov x3, 2                       // Contador de términos, comenzando en el tercer término

fibonacci_loop:
    cmp x3, x0                      // Comparar el contador con el número fijo
    bge end_fibonacci               // Si alcanzamos el número fijo, salir del bucle

    // Calcular el siguiente término de Fibonacci
    add x4, x1, x2                  // F(n) = F(n-1) + F(n-2)
    mov x1, x2                      // Mover F(n-1) a F(n-2)
    mov x2, x4                      // Mover F(n) a F(n-1)
    add x3, x3, 1                   // Incrementar el contador

    b fibonacci_loop                // Repetir el bucle

end_fibonacci:
    // Al finalizar, el último término de Fibonacci calculado estará en x2

    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    mov x0, 0                       // Código de salida
    svc 0                           // Llamada al sistema
