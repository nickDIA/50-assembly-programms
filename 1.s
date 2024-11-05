.global _start

.data
    prompt:     .ascii "Ingrese temperatura en Celsius: "
    prompt_len: .quad . - prompt
    result:     .ascii "Temperatura en Fahrenheit: "
    result_len: .quad . - result
    newline:    .ascii "\n"
    buffer:     .skip 12
    
.text
_start:
    // Mostrar prompt
    mov x0, #1              // fd = 1 (stdout)
    adr x1, prompt          // buffer = dirección del mensaje
    ldr x2, prompt_len      // length = longitud del mensaje
    mov x8, #64             // syscall write
    svc #0

    // Leer entrada del usuario
    mov x0, #0              // fd = 0 (stdin)
    adr x1, buffer          // buffer para almacenar entrada
    mov x2, #12             // máximo 12 bytes
    mov x8, #63             // syscall read
    svc #0

    // Convertir string a número
    adr x1, buffer
    bl atoi                 // Llamar a rutina de conversión
    mov x19, x0             // Guardar el número en x19

    // Convertir a Fahrenheit
    // °F = (°C × 9/5) + 32
    mov x1, #9
    mul x0, x19, x1         // Multiplicar por 9
    mov x1, #5
    udiv x0, x0, x1        // Dividir por 5
    add x0, x0, #32        // Sumar 32
    mov x19, x0            // Guardar resultado

    // Mostrar mensaje de resultado
    mov x0, #1
    adr x1, result
    ldr x2, result_len
    mov x8, #64
    svc #0

    // Convertir resultado a string
    mov x0, x19
    adr x1, buffer
    bl itoa

    // Mostrar resultado
    mov x0, #1
    adr x1, buffer
    mov x2, #12
    mov x8, #64
    svc #0

    // Mostrar nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0

    // Salir
    mov x8, #93
    mov x0, #0
    svc #0

// Función para convertir ASCII a entero (atoi)
atoi:
    mov x3, #0              // Resultado
    mov x4, #0              // Índice actual
loop_atoi:
    ldrb w5, [x1, x4]      // Cargar byte
    cmp w5, #0x0A          // Comprobar si es nueva línea
    beq end_atoi
    cmp w5, #0             // Comprobar si es fin de string
    beq end_atoi
    sub w5, w5, #0x30      // Convertir ASCII a número
    mov x6, #10
    mul x3, x3, x6         // Multiplicar resultado actual por 10
    add x3, x3, x5         // Añadir nuevo dígito
    add x4, x4, #1         // Incrementar índice
    b loop_atoi
end_atoi:
    mov x0, x3             // Retornar resultado
    ret

// Función para convertir entero a ASCII (itoa)
itoa:
    adr x2, buffer
    add x2, x2, #11        // Empezar desde el final del buffer
    mov x3, #0             // Contador de dígitos
    mov x4, #10
loop_itoa:
    udiv x5, x0, x4        // Dividir por 10
    msub x6, x5, x4, x0    // Obtener remainder (módulo)
    add x6, x6, #0x30      // Convertir a ASCII
    strb w6, [x2]          // Guardar dígito
    sub x2, x2, #1         // Mover puntero
    add x3, x3, #1         // Incrementar contador
    mov x0, x5             // Actualizar número
    cmp x0, #0             // Comprobar si quedan dígitos
    bne loop_itoa
    add x2, x2, #1         // Ajustar puntero
    mov x0, x3             // Retornar número de dígitos
    ret
