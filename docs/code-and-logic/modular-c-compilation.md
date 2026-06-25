# Week 3 (Wednesday): Modular Geometry Calculator (C Implementation)

## Objective
> To implement a geometry area calculator in C, emphasizing the separation of implementation from execution. This assignment focuses on low-level compilation workflows, demonstrating how to use function prototypes, generate object files, and link them into a final executable.

## Source Code Implementation

The architecture is split into two distinct files to separate the mathematical logic from the main execution thread.

### 1. The Logic Module (`geometry.c`)
This file contains the actual function implementations that calculate the areas. Note the inclusion of `<math.h>` to access the `M_PI` constant.

```c
#include <math.h>

/* Function Prototypes */
double circle_area(double diameter);
double square_area(double length);
double rectangle_area(double length, double width);
double triangle_area(double base, double height);

/* Function Definitions */
double circle_area(double diameter)
{
    double radius = diameter / 2;
    return M_PI * radius * radius;
}

double square_area(double length)
{
    return length * length;
}

double rectangle_area(double length, double width)
{
    return length * width;
}

double triangle_area(double base, double height)
{
    return 0.5 * base * height;
}

```

**Mathematical Formulas Applied:**

* **Circle:** Converts diameter to radius, then uses $\pi r^2$.
* **Square:** Uses $length \times length$.
* **Rectangle:** Uses $length \times width$.
* **Triangle:** Uses $\frac{1}{2} \times base \times height$.

### 2. The Execution Module (`main.c`)

This file calls the functions. It does not contain the logic itself; it relies on prototypes to inform the compiler that these functions exist elsewhere in the program's memory.

```c
#include <stdio.h>

/* Function Prototypes */
double circle_area(double diameter);
double square_area(double length);
double rectangle_area(double length, double width);
double triangle_area(double base, double height);

int main()
{
    printf("Circle area: %.2f\n", circle_area(10));
    printf("Square area: %.2f\n", square_area(5));
    printf("Rectangle area: %.2f\n", rectangle_area(4, 6));
    printf("Triangle area: %.2f\n", triangle_area(3, 8));

    return 0;
}

```

---

## Compilation & Linking Pipeline

To build this modular program, we use the `clang` compiler in a two-step process:

**Step 1: Compile the logic into an Object File**

```bash
clang -c geometry.c

```

*This generates `geometry.o`, which contains compiled machine code but is not yet executable on its own.*

**Step 2: Link the files into an Executable**

```bash
clang main.c geometry.o -o geometry

```

*The linker combines the main execution thread with the logic object file to create the final executable named `geometry`.*

**Step 3: Execute the Program**

```bash
./geometry

```

**Output:**

```text
Circle area: 78.54
Square area: 25.00
Rectangle area: 24.00
Triangle area: 12.00

```

---

## Core Concepts Mastered

1. **Functions in C:** Separating discrete logic into reusable blocks (e.g., `circle_area()`).
2. **Object Files (`.o`):** Understanding that source code compiles into intermediary machine code blocks before becoming a full program.
3. **Linking:** The critical step where the compiler resolves external function calls by stitching `main.c` and `geometry.o` together.

### The Visual Compilation Flow

```text
geometry.c  ──compile──► geometry.o
                                   \
                                    ► linking ► executable program
                                   /
main.c  ──────────────────────────

```