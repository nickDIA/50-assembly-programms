// Suma de los N primeros números naturales
// Registros utilizados:
// X0 - Parámetro N y resultado final
// X1 - Contador actual
// X2 - Suma acumulada

using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Suma de N números naturales ===\n");
        
        // Solicitar entrada al usuario
        Console.Write("Ingrese un número N: ");
        int n = Convert.ToInt32(Console.ReadLine());

        // Mostrar resultados usando diferentes métodos
        Console.WriteLine($"\nUsando bucle for: {SumaConBucle(n)}");
        Console.WriteLine($"Usando fórmula matemática: {SumaConFormula(n)}");
        Console.WriteLine($"Usando LINQ: {SumaConLinq(n)}");
        Console.WriteLine($"Usando recursividad: {SumaRecursiva(n)}");
    }

    // Método 1: Usando un bucle for
    static long SumaConBucle(int n)
    {
        long suma = 0;
        for (int i = 1; i <= n; i++)
        {
            suma += i;
        }
        return suma;
    }

    // Método 2: Usando la fórmula matemática n*(n+1)/2
    static long SumaConFormula(int n)
    {
        return (long)n * (n + 1) / 2;
    }

    // Método 3: Usando LINQ
    static long SumaConLinq(int n)
    {
        return Enumerable.Range(1, n).Sum(x => (long)x);
    }

    // Método 4: Usando recursividad
    static long SumaRecursiva(int n)
    {
        if (n <= 1) return n;
        return n + SumaRecursiva(n - 1);
    }

    // Método adicional para validar la entrada (opcional)
    static int ValidarEntrada()
    {
        int n;
        while (true)
        {
            Console.Write("Ingrese un número positivo: ");
            if (int.TryParse(Console.ReadLine(), out n) && n > 0)
                return n;
            Console.WriteLine("Por favor, ingrese un número válido mayor que 0.");
        }
    }
}
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
