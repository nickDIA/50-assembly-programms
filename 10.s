.global _start

.section .data
input_string:   .asciz "Hola Mundo"    // Cadena de entrada
input_len:      .quad 11               // Longitud de la cadena (sin el null terminator)

.section .bss
reverse_string: .skip 12               // Espacio para almacenar la cadena invertida

.section .text
_start:
    // Cargar la dirección de la cadena original
    ldr x0, =input_string       // Cargar la dirección de la cadena original
    ldr x1, =input_len          // Cargar la longitud de la cadena (sin el null terminator)
    ldr x1, [x1]                // Obtener la longitud de la cadena

    // Preparar para invertir la cadena
    ldr x2, =reverse_string     // Dirección donde se almacenará la cadena invertida

invert_loop:
    // Comprobar si hemos llegado al final de la cadena
    cbz x1, done_inverting      // Si x1 (longitud) es 0, hemos terminado

    // Obtener el siguiente carácter de la cadena original
    sub x1, x1, #1              // Decrementar longitud
    add x3, x0, x1              // Dirección del carácter actual en la cadena original
    ldrb x4, [x3]               // Cargar el byte (carácter) en w4

    // Almacenar el carácter en la cadena invertida
    strb x4, [x2], #1           // Almacenar y mover el puntero a la siguiente posición en reverse_string

    b invert_loop               // Repetir el ciclo

done_inverting:
    // Añadir el null terminator a la cadena invertida
    mov x4, #0                  // Null terminator (0)
    strb x4, [x2]               // Guardar el null terminator

    // Imprimir la cadena invertida
    ldr x0, =reverse_string     // Cargar la dirección de la cadena invertida
    bl print_string             // Llamar a la función de impresión

    // Salir del programa
    mov x8, #93                 // syscall número para exit (en Linux ARM64)
    mov x0, #0                  // Código de salida 0
    svc #0                      // Realizar la llamada al sistema

print_string:
    // Función para imprimir una cadena
    mov x1, x0                  // Poner la dirección de la cadena en x1
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
