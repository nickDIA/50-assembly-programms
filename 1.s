.global _start

.data
    prompt:     .ascii "Ingrese temperatura en Celsius (-999 para salir): "
    prompt_len: .quad . - prompt
    result:     .ascii "Temperatura en Fahrenheit: "
    result_len: .quad . - result
    error_msg:  .ascii "Error: Ingrese un número válido\n"
    error_len:  .quad . - error_msg
    newline:    .ascii "\n"
    buffer:     .skip 20
    decimal:    .ascii "."
    
.text
_start:
main_loop:
    // Mostrar prompt
    mov x0, #1              // fd = 1 (stdout)
    adr x1, prompt          // buffer = dirección del mensaje
    ldr x2, prompt_len      // length = longitud del mensaje
    mov x8, #64             // syscall write
    svc #0

    // Leer entrada del usuario
    mov x0, #0              // fd = 0 (stdin)
    adr x1, buffer          // buffer para almacenar entrada
    mov x2, #20             // máximo 20 bytes
    mov x8, #63             // syscall read
    svc #0

    // Procesar entrada
    adr x1, buffer
    bl parse_float          // Convertir string a número con decimales
    
    // Verificar si es -999 para salir
    mov x1, #-999000        // -999 * 1000 (trabajamos con milésimas)
    cmp x0, x1
    beq exit_program

    // Convertir a Fahrenheit
    // °F = (°C × 9/5) + 32
    mov x19, x0             // Guardar temperatura original
    
    // Multiplicar por 9
    mov x1, #9
    mul x0, x19, x1
    
    // Dividir por 5
    mov x1, #5
    sdiv x0, x0, x1        // División con signo
    
    // Sumar 32000 (32 * 1000 para mantener decimales)
    add x0, x0, #32000
    mov x19, x0            // Guardar resultado

    // Mostrar mensaje de resultado
    mov x0, #1
    adr x1, result
    ldr x2, result_len
    mov x8, #64
    svc #0

    // Convertir y mostrar resultado
    mov x0, x19
    bl print_float

    // Mostrar nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0

    b main_loop            // Volver al inicio para nueva entrada

exit_program:
    mov x8, #93
    mov x0, #0
    svc #0

// Función para parsear float desde string
parse_float:
    mov x3, #0              // Resultado
    mov x4, #0              // Índice actual
    mov x5, #1              // Signo (1 positivo, -1 negativo)
    mov x6, #0              // Posición decimal
    mov x7, #0              // Flag para parte decimal
    
    // Verificar signo
    ldrb w8, [x1]
    cmp w8, #0x2D          // '-'
    bne parse_loop
    mov x5, #-1
    add x4, x4, #1

parse_loop:
    ldrb w8, [x1, x4]      // Cargar byte
    cmp w8, #0x0A          // Nueva línea
    beq end_parse
    cmp w8, #0             // Fin de string
    beq end_parse
    
    cmp w8, #0x2E          // '.'
    beq set_decimal
    
    sub w8, w8, #0x30      // ASCII a número
    mov x9, #10
    mul x3, x3, x9         // Resultado * 10
    add x3, x3, x8         // Añadir dígito
    
    cmp x7, #1             // Si estamos en decimales
    bne continue_parse
    add x6, x6, #1         // Incrementar posición decimal
    
continue_parse:
    add x4, x4, #1
    b parse_loop

set_decimal:
    mov x7, #1             // Activar flag decimal
    add x4, x4, #1
    b parse_loop

end_parse:
    // Ajustar decimales a milésimas
    mov x9, #1000
    cmp x6, #0
    beq no_decimal
    
    cmp x6, #1
    beq one_decimal
    cmp x6, #2
    beq two_decimal
    b three_decimal

no_decimal:
    mul x3, x3, x9
    b finish_parse

one_decimal:
    mul x3, x3, #100
    b finish_parse

two_decimal:
    mul x3, x3, #10
    b finish_parse

three_decimal:
    // Ya está en milésimas
    
finish_parse:
    mul x3, x3, x5         // Aplicar signo
    mov x0, x3
    ret

// Función para imprimir float
print_float:
    mov x19, x0            // Guardar número original
    
    // Manejar signo
    cmp x0, #0
    bge positive
    mov x0, #1
    adr x1, buffer
    mov x2, #1
    strb w2, [x1]          // Guardar '-'
    mov x8, #64
    svc #0
    neg x19, x19           // Hacer positivo
    
positive:
    mov x0, x19
    mov x1, #1000
    udiv x2, x0, x1        // Parte entera
    msub x3, x2, x1, x0    // Parte decimal
    
    // Convertir parte entera
    mov x0, x2
    adr x1, buffer
    bl itoa
    mov x2, x0             // Longitud del número
    
    // Imprimir parte entera
    mov x0, #1
    adr x1, buffer
    mov x8, #64
    svc #0
    
    // Imprimir punto decimal
    mov x0, #1
    adr x1, decimal
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Convertir y mostrar decimales
    mov x0, x3
    adr x1, buffer
    bl itoa_padded         // Versión que rellena con ceros
    
    // Imprimir decimales
    mov x0, #1
    adr x1, buffer
    mov x2, #3
    mov x8, #64
    svc #0
    
    ret

// Función para convertir entero a ASCII con relleno de ceros
itoa_padded:
    adr x2, buffer
    add x2, x2, #2         // Para 3 dígitos
    mov x4, #10
    
    // Primer dígito
    udiv x5, x0, x4
    msub x6, x5, x4, x0
    add x6, x6, #0x30
    strb w6, [x2]
    sub x2, x2, #1
    mov x0, x5
    
    // Segundo dígito
    udiv x5, x0, x4
    msub x6, x5, x4, x0
    add x6, x6, #0x30
    strb w6, [x2]
    sub x2, x2, #1
    mov x0, x5
    
    // Tercer dígito
    add x0, x0, #0x30
    strb w0, [x2]
    
    mov x0, #3             // Longitud fija de 3
    ret

// Función itoa normal (para parte entera)
itoa:
    adr x2, buffer
    add x2, x2, #11
    mov x3, #0
    mov x4, #10
itoa_loop:
    udiv x5, x0, x4
    msub x6, x5, x4, x0
    add x6, x6, #0x30
    strb w6, [x2]
    sub x2, x2, #1
    add x3, x3, #1
    mov x0, x5
    cmp x0, #0
    bne itoa_loop
    add x2, x2, #1
    mov x0, x3
    ret
