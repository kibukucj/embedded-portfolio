# Week 6 (Extra): Traffic Light Controller

## Objective
> To design, wire, and program a physical traffic light sequence using a Raspberry Pi Pico W. 

## The Hardware Blueprint
Established the physical circuit using the Pico W, three LEDs (Red, Yellow, Green), resistors, and a breadboard.

### Wiring Steps:

1. **Mount the Pico W:** Push the Pico W firmly into the breadboard so it straddles the center trench. This isolates the left pins from the right pins, preventing catastrophic short circuits.
2. **Establish a Ground Rail:** Run a jumper wire from a `GND` pin on the Pico W (e.g., Pin 38) to one of the long blue/negative rails on the edge of the breadboard.
3. **Place the LEDs:** Insert the Red, Yellow, and Green LEDs into the breadboard, ensuring each LED spans across different numbered rows so their legs remain electrically isolated.
4. **Connect the Grounds:** For each LED, connect the shorter leg (cathode) to the common ground rail established in Step 2.
5. **Connect Resistors and Data Pins:**

   * Place a resistor connecting the longer leg (anode) of the Red LED to an empty row. Connect that row to `GP13` on the Pico W.
   * Connect the Yellow LED's anode through a resistor to `GP14`.
   * Connect the Green LED's anode through a resistor to `GP15`.

*Hardware Theory:* We use General Purpose Input/Output (GPIO) pins to send high (**3.3V**) or low (**0V**) signals to the LEDs.

---

## The CircuitPython Pivot

### Library Management
Due to the Pico W's limited storage space, you must only copy the specific `.mpy` files you need into the `lib` folder. 

*Note: For this specific traffic light project, no external libraries from the bundle were required, as CircuitPython's native `board` and `digitalio` modules handle basic GPIO control.*

### Firmware Implementation
Rewrote the initial MicroPython logic into CircuitPython to cycle the lights continuously.

```python
import board
import digitalio
import time

# Initialize GPIO pins as Outputs in CircuitPython
led_red = digitalio.DigitalInOut(board.GP13)
led_red.direction = digitalio.Direction.OUTPUT

led_yellow = digitalio.DigitalInOut(board.GP14)
led_yellow.direction = digitalio.Direction.OUTPUT

led_green = digitalio.DigitalInOut(board.GP15)
led_green.direction = digitalio.Direction.OUTPUT

# Infinite execution loop
while True:
    # 1. Red Light Phase (5 seconds)
    led_red.value = True
    led_yellow.value = False
    led_green.value = False
    time.sleep(5)
    
    # 2. Green Light Phase (5 seconds)
    led_red.value = False
    led_yellow.value = False
    led_green.value = True
    time.sleep(5)
    
    # 3. Yellow Light Phase (2 seconds)
    led_red.value = False
    led_yellow.value = True
    led_green.value = False
    time.sleep(2)
```

---

## Troubleshooting

### The Symptom
The code was executing perfectly (verified by adding a blinking onboard LED to the script), but the external breadboard LEDs remained completely dark. 

### The Diagnostic Checklist
Ran through the standard hardware troubleshooting protocol:

* **Polarity:** Are the LEDs plugged in backward?
* **Pin Mapping:** Do the physical pins match the software variables?
* **Routing:** Are the components in the correct breadboard rows?
* **Grounding:** Is the circuit properly closed?

### The Resistor Reality Check
During troubleshooting, we established why resistors are absolutely mandatory. Without them, the Pico W would push its full 3.3V logic current through the LEDs without a bottleneck. This would result in either instantly burnt-out LEDs or a permanently fried Pico W.

### The Fix
Guess what the issue was 💀. The ground wire was plugged into a disconnected half of the breadboard's power rail. 

**The Lesson:** Full-sized breadboards often have a physical split right down the middle of their power rails. If you don't bridge that gap with a jumper wire, half of your board receives no power or ground. 
