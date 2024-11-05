// Instituto Tecnologico de Tijuana
// Depto de Sistemas y Computacion
// Ing. Sistemas computacionales
// Autor: Ibarra Acedo Dominick 
// Repositorio: 

.global _start

.text
_start:
    // Suponemos que la temperatura en Celsius está en x0
    // Fórmula: °F = (°C × 9/5) + 32
    
    // Multiplicar por 9
    mov x1, #9
    mul x0, x0, x1
    
    // Dividir por 5
    mov x1, #5
    udiv x0, x0, x1
    
    // Sumar 32
    add x0, x0, #32
    
    // El resultado en Fahrenheit está ahora en x0
    
    // Salir del programa
    mov x8, #93        // syscall exit
    mov x0, #0         // return code 0
    svc #0             // realizar syscall

.data
    celsius: .word 25   // Ejemplo: 25°C
