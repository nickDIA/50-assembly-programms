

.section .text
    .global _start

_start:
    // Definir un número fijo, por ejemplo, 5
    mov x0, 5                       // Número para el que se calculará el factorial

    // Calcular el factorial
    mov x1, x0                      // Copiar el número a x1 (usado para multiplicación)
    mov x2, 1                       // Inicializar x2 en 1 (resultado del factorial)

factorial_loop:
    cmp x1, 1                       // Comparar x1 con 1
    ble end_factorial               // Si x1 <= 1, salir del bucle
    mul x2, x2, x1                  // Multiplicar x2 (resultado) por x1
    sub x1, x1, 1                   // Decrementar x1
    b factorial_loop                // Repetir el bucle

end_factorial:
    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    mov x0, 0                       // Código de salida
    svc 0                           // Llamada al sistema
