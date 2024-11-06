// Programa en ensamblador ARM de 64 bits para calcular el factorial de un número
// Guardar este archivo como factorial.s y compilar con:
// $ as -o factorial.o factorial.s
// $ ld -o factorial factorial.o
// Ejecutar con:
// $ ./factorial

.section .data
prompt: .asciz "Introduce un número: "
result_msg: .asciz "El factorial es: %d\n"

.section .bss
    .lcomm num, 8                  // Reserva 8 bytes para el número

.section .text
    .global _start

_start:
    // Escribir el mensaje para solicitar un número
    mov x0, 1                       // File descriptor (stdout)
    ldr x1, =prompt                 // Dirección del mensaje
    mov x2, 18                      // Longitud del mensaje
    mov x8, 64                      // Syscall para escribir
    svc 0                           // Llamada al sistema

    // Leer el número ingresado por el usuario
    mov x0, 0                       // File descriptor (stdin)
    adrp x1, num                    // Cargar la página base de la dirección de 'num'
    add x1, x1, :lo12:num           // Ajustar al desplazamiento correcto en la página
    mov x2, 8                       // Tamaño de lectura
    mov x8, 63                      // Syscall para leer
    svc 0                           // Llamada al sistema

    // Cargar el número y convertirlo a entero
    adrp x0, num                    // Cargar la página base de la dirección de 'num'
    add x0, x0, :lo12:num           // Ajustar al desplazamiento correcto en la página
    ldrb w0, [x0]                   // Cargar el número leído en w0 (8 bits)
    sub x0, x0, '0'                 // Convertir de ASCII a valor entero

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
    // Imprimir el resultado
    mov x0, 1                       // File descriptor (stdout)
    ldr x1, =result_msg             // Dirección del mensaje de resultado
    mov x8, 64                      // Syscall para escribir
    svc 0                           // Llamada al sistema

    // Finalizar el programa
    mov x8, 93                      // Syscall para salir
    mov x0, 0                       // Código de salida
    svc 0                           // Llamada al sistema
