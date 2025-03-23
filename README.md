# Heart Monitor Project

## Overview
This project implements a real-time cardiac monitoring system using the **PIC18F87K22** microprocessor and the **AD8232 ECG Module**. The system captures and processes the user's heartbeat data and outputs the RR-interval in hundredths of seconds to **PORTC**. Future development will include calculations for **Heart Rate Variability (HRV)** and **Heartbeat Coherence (HC)**, along with a display and visual feedback system.

## Current Features
- **Real-time Heartbeat Monitoring** using the AD8232 sensor.
- **RR-Interval Measurement**: The interval between heartbeats is computed and output in hundredths of a second to **PORTC**.
-  **Oscilloscope visualization** of the raw signal.

## Planned Features
- **Heart Rate Variability (HRV) Calculation** based on RR-interval standard deviation.
- **Heartbeat Coherence (HC) Calculation** using a time-domain algorithm.
- **User Input via Keypad** for setting critical HRV and HC values.
- **LCD Display Output** for real-time heart health parameters.
- **LED Indicators** for visual feedback (green for normal, red for irregular values).

## Hardware components
- **Microcontroller**: PIC18F87K22
- **ECG sensor module**: AD8232
- **Display**: 2x16 LCD screen (planned)
- **User Input**: Keypad (planned)
- **LEDs**: Green (normal), Red (irregular) (planned)
- **Additional equipment**: Oscilloscope for signal visualization

## Software Design
The software consists of the following steps:
1. **Data acquisition**: The ECG sensor collects raw heartbeat data from three chest pads.
2. **Filtering**: A band-pass filter (0.5 Hz - 3.5 Hz) removes noise from the signal.
3. **Analog-to-Digital Conversion (ADC)**: The filtered signal is converted to a 12-bit digital value.
4. **Signal Pprocessing**: The microcontroller detects RR-intervals and outputs the value to **PORTC**.
5. **(Planned) HRV and HC calculations**:
   - **HRV** = Standard deviation of RR-intervals.
   - **HC** = Number of regular intervals within a threshold (k × HRV), normalized to a 0-10 scale.
6. **(Planned) Output display**: The calculated HRV and HC values, along with heart rate, will be displayed on an LCD screen.
7. **(Planned) Visual feedback**: LEDs will indicate whether the values are within the critical range.

## Performance assessment (planned)
- **HR and HRV Accuracy**: To be compared with a commercial heart rate monitor under different conditions (rest, exercise, recovery).
- **HC Verification**: To be checked against expected physiological states (e.g., relaxation = high coherence, stress = low coherence).

## Installation and usage
### Prerequisites
- MPLAB X IDE with XC8 compiler.
- PIC18F87K22 Development Board.
- AD8232 ECG Sensor Module.

### Steps to Run the Project
1. Connect the ECG sensor to pin **RA0** of **PORTA** using a low pass filter with a cutting frequency of 10Hz.
2. Compile and upload the assembly code to the microcontroller.
3. Power up the system and observe the RR-interval output on **PORTC**.
4. Future updates will include additional features such as keypad input, LCD output, and LED indicators.

## Repository Structure
```
Heart-monitor/
│-- src/                  # Source code files (Assembly)
│-- docs/                 # Project documentation
│-- hardware/             # Circuit diagrams and component details
│-- README.md             # Project overview and setup instructions
```

## References
- [AD8232 Heart Rate Monitor Documentation](https://github.com/sparkfun/AD8232_Heart_Rate_Monitor)
- Lecture slides on microprocessor interfacing and signal processing.

## Contributors
- **Giancarlo Venturato** - Main developer
- **Andrea Sanfilippo** - Tester and secondary developer

## License
This project is open-source and available under the MIT License.

