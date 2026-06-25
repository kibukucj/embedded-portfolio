# Assignment: Object-Oriented Shape Area Calculator

## Objective
> To build a modular geometry calculator using Python.

## Mathematical Formulas Implemented
The following area calculations are embedded into the class methods:

* **Circle:** $Area = \pi \times r^2$(where $r = \frac{diameter}{2}$)
* **Square:** $Area = length^2$
* **Rectangle:** $Area = length \times width$
* **Right-Angled Triangle:** $Area = \frac{base \times height}{2}$

## Source Code
The code uses a base `Shape` class that defines an abstract `area()` method. The subclasses (`Circle`, `Square`, `Rectangle`, `RightTriangle`) inherit from `Shape` and dynamically override the `area()` method (Polymorphism) to execute their specific mathematical formulas.

```python
import math

class Shape:
    def area(self):
        # Method Implemented by Subclasses
        pass

class Circle(Shape):
    def __init__(self, diameter):
        self.diameter = diameter

    def area(self):
        r = self.diameter / 2
        return round(math.pi * (r ** 2), 2) # Rounding to 2 Decimal Places

class Square(Shape):
    def __init__(self, length):
        self.length = length

    def area(self):
        return self.length ** 2

class Rectangle(Shape):
    def __init__(self, length, width):
        self.length = length
        self.width = width

    def area(self):
        return self.length * self.width

class RightTriangle(Shape):
    def __init__(self, base, height):
        self.base = base
        self.height = height

    def area(self):
        return (self.base * self.height) / 2

# Initialize Shape Objects with Defined Dimensions
circle = Circle(10)
square = Square(5)
rectangle = Rectangle(4, 6)
triangle = RightTriangle(3, 8)

# Execute and Print Area Calculations
print("Circle area:", circle.area())
print("Square area:", square.area())
print("Rectangle area:", rectangle.area())
print("Triangle area:", triangle.area())

```

## Execution Output

Running the script yields the following output:

```text
Circle area: 78.54
Square area: 25
Rectangle area: 24
Triangle area: 12.0

```