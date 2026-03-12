# Week 3 (Monday): C Fundamentals and String Handling

## Objective
> Establish the foundational syntax of C programming. The goal was to write a basic execution thread, manage fixed-memory character arrays, and utilize formatted standard output.

## Source Code Implementation
The following code demonstrates how C handles text without relying on a dedicated high-level "String" object class.

```c
#include <stdio.h>

int main() {
    char myName[50] = "Kibuku Carole June Wanjiku";
    char myYear[50] = "Year 4";
    char myCourse[50] = "Computer Science";

    printf("My name is %s.\nI study %s and I am in %s.", myName, myCourse, myYear);

    return 0;
}

```

## Core Concepts Mastered

### 1. The Standard Library (`<stdio.h>`)

Unlike higher-level languages that load built-in functions automatically, C requires explicit linking to standard libraries to perform basic operations. `#include <stdio.h>` brings in the Standard Input/Output library, granting access to the `printf` function.

### 2. The `main()` Execution Thread

`int main()` is the mandatory entry point for any compiled C program. The `return 0;` statement at the end is a status code sent back to the operating system, where `0` universally indicates that the program executed successfully without fatal hardware or memory errors.

### 3. Memory Allocation for Strings (Character Arrays)

C does not have a native `String` data type. Instead, text is handled as an array of individual characters (`char`).

* By declaring `char myCourse[50]`, we are strictly allocating a block of 50 contiguous bytes of memory to store the characters.
* C automatically appends an invisible "null-terminator" (`\0`) to the end of the text to tell the compiler exactly where the string stops in memory.

### 4. Formatted Output & Specifiers

The `printf` function uses format specifiers to inject variables into a text string dynamically.

* **`%s`**: Tells the compiler to look at the provided variables and insert them as strings (character arrays).
* **`\n`**: An escape sequence that dictates a physical line break in the terminal output.

## Execution Output

When compiled and executed, the program formats the strings and outputs:

```text
My name is Kibuku Carole June Wanjiku.
I study Computer Science and I am in Year 4.

```