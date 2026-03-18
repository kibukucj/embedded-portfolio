# Week 4 (Monday): Advanced C Data Structures & Memory Management

## Objective
> To transition beyond basic variables and static arrays by mastering complex data grouping and dynamic memory allocation in C. The goal was to build a memory-efficient student record system utilizing `struct`, `enum`, `union`, and runtime memory functions like `malloc` and `free`.

## Source Code Implementation

This program dynamically allocates memory for a user-defined number of students, utilizing a combination of structures, enumerations, and unions to efficiently handle varied academic data.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ================= ENUM ================= */
// ENUM = a user-defined type for fixed set of named constants
typedef enum {
    UNDERGRADUATE,   // automatically 0
    POSTGRADUATE     // automatically 1
} ProgramType;

/* ================= UNION ================= */
// UNION = a type where all members share the same memory location
typedef union {
    float gpa;
    int research_hours;
} AcademicInfo;

/* ================= STRUCT ================= */
// STRUCT = groups related variables into one unit
typedef struct {
    char name[100];
    int age;
    ProgramType program;
    AcademicInfo info;
} Student;

/* ================= FUNCTION PROTOTYPES ================= */
void inputStudent(Student *s);
void displayStudent(Student s);

/* ================= MAIN FUNCTION ================= */
int main() {
    int n;

    printf("Enter number of students: ");
    scanf("%d", &n);

    // DYNAMIC MEMORY ALLOCATION
    Student *students = (Student *)malloc(n * sizeof(Student));

    // CHECK IF malloc FAILED
    if (students == NULL) {
        printf("Memory allocation failed!\n");
        return 1;
    }

    // INPUT LOOP
    for (int i = 0; i < n; i++) {
        printf("\n--- Student %d ---\n", i + 1);
        inputStudent(&students[i]);
    }

    // DISPLAY LOOP
    printf("\n===== Student Records =====\n");
    for (int i = 0; i < n; i++) {
        displayStudent(students[i]);
    }

    // FREE MEMORY
    free(students);

    return 0;
}

/* ================= INPUT FUNCTION ================= */
void inputStudent(Student *s) {
    printf("Enter name: ");
    scanf(" %[^\n]", s->name);

    printf("Enter age: ");
    scanf("%d", &s->age);

    printf("Enter program (0 = Undergraduate, 1 = Postgraduate): ");
    scanf("%d", (int *)&s->program);

    // CONDITIONAL LOGIC BASED ON ENUM
    if (s->program == UNDERGRADUATE) {
        printf("Enter GPA: ");
        scanf("%f", &s->info.gpa);
    } else {
        printf("Enter research hours: ");
        scanf("%d", &s->info.research_hours);
    }
}

/* ================= DISPLAY FUNCTION ================= */
void displayStudent(Student s) {
    printf("\nName: %s\n", s.name);
    printf("Age: %d\n", s.age);

    // DISPLAY PROGRAM TYPE
    if (s.program == UNDERGRADUATE) {
        printf("Program: Undergraduate\n");
        printf("GPA: %.2f\n", s.info.gpa);
    } else {
        printf("Program: Postgraduate\n");
        printf("Research Hours: %d\n", s.info.research_hours);
    }
}
```

## Execution Output

The code was compiled using Clang (`clang -c week-04-monday.c` and `clang week-04-monday.o -o display`). Here is the terminal execution demonstrating the dynamic allocation and conditional logic functioning correctly:

```text
PS C:\Users\cjkib\Documents\gearbox-weekly-projects> clang -c week-04-monday.c
PS C:\Users\cjkib\Documents\gearbox-weekly-projects> clang week-04-monday.o -o display
PS C:\Users\cjkib\Documents\gearbox-weekly-projects> ./display
Enter number of students: 2

--- Student 1 ---
Enter name: June
Enter age: 21
Enter program (0 = Undergraduate, 1 = Postgraduate): 0
Enter GPA: 4.1

--- Student 2 ---
Enter name: Carole
Enter age: 22
Enter program (0 = Undergraduate, 1 = Postgraduate): 1
Enter research hours: 4.8

===== Student Records =====

Name: June
Age: 21
Program: Undergraduate
GPA: 4.10

Name: Carole
Age: 22
Program: Postgraduate
Research Hours: 4
PS C:\Users\cjkib\Documents\gearbox-weekly-projects> 
```

## Core Concepts Mastered

### 1\. Complex Data Structures

  * **`struct` (Structure):** Bundles multiple variables of different types under one unified name. Instead of managing `name`, `age`, and `program` separately, one `Student s;` variable holds everything.
  * **`enum` (Enumeration):** Represents a fixed set of named integer constants (e.g., `UNDERGRADUATE = 0`, `POSTGRADUATE = 1`). This replaces "magic numbers" in code, making conditional logic like `if (s->program == UNDERGRADUATE)` much safer and more readable.
  * **`union`:** Stores multiple variables in the *exact same memory location*. Because a student is either an Undergraduate (has a GPA) OR a Postgraduate (has research hours), we use a union to save memory. Only one value is valid at a time.

### 2\. Dynamic Memory Management

  * **`malloc` (Memory Allocation):** Asks the operating system for a specific block of memory at runtime. By calculating `n * sizeof(Student)`, the program dynamically adapts to the exact number of students needed without wasting space.
  * **NULL Checking:** Always verify `if (students == NULL)` after calling `malloc`. If the system is out of memory, this prevents catastrophic crashes.
  * **`free()`:** The critical final step. It releases the allocated memory back to the system to prevent memory leaks.

### 3\. Pointers and Memory Access

  * **Pointers (`Student *s`):** Passing the memory address of the struct to the `inputStudent` function allows us to modify the *original* data in memory, rather than just editing a temporary copy.
  * **The `->` Operator:** Syntactic sugar for accessing struct members via a pointer. `s->age` is the exact equivalent of `(*s).age`.

### 4\. Input Handling Nuances

  * **`scanf(" %[^\n]", s->name);`:** The space before the `%` is a vital trick. It tells the compiler to ignore any leftover newline characters (`\n`) in the input buffer, allowing us to accurately read full strings containing spaces.

## Architectural Summary

| Concept | Role in Architecture |
| :--- | :--- |
| **`struct`** | Holds and bundles the complete student data profile. |
| **`enum`** | Controls operational logic securely (Undergraduate vs Postgraduate). |
| **`union`** | Optimizes memory footprint by sharing space for mutually exclusive data. |
| **`malloc`** | Generates the exact array size required at runtime. |
| **`pointer`** | Grants functions direct access to modify original data blocks. |
| **`free`** | Cleans up the environment and prevents system memory leaks. |
