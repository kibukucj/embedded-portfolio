# Project Proposal: IoT-Based Automated Irrigation and Environmental Monitoring System for Ornamental Plants

## 1. Introduction
Ornamental plants need consistent monitoring of soil moisture, temperature, humidity, and light to thrive. However, busy schedules make it hard for owners to keep up with these demands. This project proposes an Internet of Things (IoT) solution using an ESP32 microcontroller to collect real-time environmental data and automate the watering process, ensuring optimal plant health with minimal effort.

## 2. The Problem

Keeping plants healthy is difficult because of:

* Irregular watering schedules.
* A lack of real-time data on what the plant actually needs.
* Accidental overwatering or underwatering.
* An inability to monitor plants remotely.

There is a clear need for an intelligent system that completely automates this process.

## 3. Objectives

**Main Objective:** To design and build an IoT-connected system that monitors and automates ornamental plant care.

**Specific Objectives:**

* Continuously measure soil moisture, temperature, and humidity.
* Automate a water pump based on specific soil moisture thresholds.
* Transmit real-time sensor data to a remote cloud database over Wi-Fi.
* Provide a mobile interface for remote monitoring and control.

## 4. System Overview
The ESP32 acts as the brain of the operation. It constantly pulls data from the connected sensors, processes it against predefined health thresholds, physically triggers a water pump via a relay when the plant is thirsty, and pushes the live data to the cloud.

## 5. How It Works (Methodology)

### System Architecture

* **Inputs:** Soil moisture, DHT22 (temperature/humidity), and LDR (light) sensors.
* **Processing & Comms:** ESP32 Microcontroller.
* **Outputs:** 5V Mini water pump (controlled via a relay module).

### Operational Logic

1. The soil sensor continuously reads moisture levels.
2. If the moisture drops below the target threshold, the ESP32 triggers the relay to activate the pump.
3. Once the moisture reaches an adequate level, the pump shuts off.
4. All environmental data and pump activity are securely transmitted to the cloud, updating the user's dashboard in real-time.

## 6. Tech Stack & Components

**Hardware:**

* ESP32 Microcontroller
* Soil Moisture Sensor
* DHT22 Sensor (Temperature & Humidity)
* Light Dependent Resistor (LDR)
* 5V Relay Module & Mini Water Pump
* Silicone tubing, breadboard, jumper wires, and power supply

**Software:**

* **Firmware:** Arduino IDE (C++)
* **Backend:** Firebase (Real-time database handling ESP32 telemetry)
* **Frontend:** Flutter (Mobile application for user dashboard)

## 7. Expected Outcomes

* A fully functional hardware prototype.
* A remote mobile dashboard displaying live plant diagnostics.
* Drastically reduced manual intervention and improved overall plant health.

## 8. Why It Matters
This project is a highly practical application of IoT in home automation and agriculture. It provides a scalable solution for homes or small nurseries, guarantees efficient plant management, and promotes water conservation through precision irrigation.