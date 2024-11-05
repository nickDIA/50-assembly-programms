/*
using System;
class Program
{
    static void Main()
    {
        int numero1 = 5;  // Primer número
        int numero2 = 3;  // Segundo número
        int resultado = numero1 + numero2;
        Console.WriteLine("Resultado: " + resultado);
    }
}
*/
    .section .data
result_str: 
    .asciz "Resultado: 8\n"   // Resultado esperado de 5 + 3 como cadena

    .section .text
    .global _start

_start:
    // Cargar los números en los registros
    MOV X0, #5          // Cargar el valor 5 en el registro X0
    MOV X1, #3          // Cargar el valor 3 en el registro X1

    // Sumar X0 y X1, almacenar el resultado en X2
    ADD X2, X0, X1      // X2 = X0 + X1

    // Configurar la llamada al sistema `write` para imprimir el resultado
    MOV X0, #1          // File descriptor 1 (stdout)
    LDR X1, =result_str // Dirección del mensaje a imprimir
    MOV X2, #13         // Longitud del mensaje "Resultado: 8\n"
    MOV X8, #64         // Código de sistema para `write` en ARM64
    SVC #0              // Llamada al sistema para escribir en stdout

    // Terminar el programa limpiamente
    MOV X8, #93         // Código de salida (exit) en ARM64
    SVC #0              // Llamada al sistema para salir
