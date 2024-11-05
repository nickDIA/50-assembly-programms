// Suma de los N primeros números naturales
// Registros utilizados:
// X0 - Parámetro N y resultado final
// X1 - Contador actual
// X2 - Suma acumulada

.global _start      // Punto de entrada del programa

.section .text
_start:
    MOV X0, #5      // Ejemplo: N = 5 (puedes cambiar este valor)
    MOV X1, #1      // Inicializar contador en 1
    MOV X2, #0      // Inicializar suma en 0

loop:
    CMP X1, X0      // Comparar contador con N
    BGT end         // Si contador > N, terminar
    
    ADD X2, X2, X1  // Sumar contador actual a la suma total
    ADD X1, X1, #1  // Incrementar contador
    B loop          // Volver al inicio del loop

end:
    MOV X0, X2      // Mover resultado final a X0 para retorno
    
    // Salir del programa
    MOV X16, #1     // Syscall exit en ARM64 macOS (usar #93 para Linux)
    SVC #0          // Realizar la llamada al sistema

.section .data
