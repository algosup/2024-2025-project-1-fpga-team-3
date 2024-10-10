# Technical Specification for an FPGA Game project

| Role               | Name                     | Signature  | Date       |
| ------------------ | ------------------------ | ---------- | ---------- |
| Project Manager    | Lucas Aubard             | ✅         | 09/26/2024 |
| Program Manager    | Julian Reine             | ✅         | 09/26/2024 |
| Tech Lead          | Tsangue Vivien Bistrel   | ✅         | 09/26/2024 |
| Software Developer | Manech Laguens           | ✅         | 09/26/2024 |
| Software Developer | Mariem Zayenne           | ✅         | 09/26/2024 |
| Quality Assurance  | Raphaël Chiocchi         | ✅         | 09/26/2024 |
| Technical Writer   | Abderrazaq Makran        | ✅         | 09/26/2024 |


<details>

<summary>

## Table of Contents

</summary>

- [Technical Specification for an FPGA Game project](#technical-specification-for-an-fpga-game-project)
  - [Table of Contents](#table-of-contents)
  - [I. Introduction](#i-introduction)
    - [1. Project Brief](#1-project-brief)
    - [2. Overview](#2-overview)
    - [3. Game Specifications](#3-game-specifications)
    - [4. Objective](#4-objective)
    - [5. Requirements](#5-requirements)
    - [6. Hardware \& Software requirements](#6-hardware--software-requirements)
      - [a. Hardware](#a-hardware)
      - [b. Software](#b-software)
    - [7. Target Audience](#7-target-audience)
  - [II. System Overview](#ii-system-overview)
    - [1. System Architecture](#1-system-architecture)
    - [2. Software setting up Design](#2-software-setting-up-design)
      - [a. Setting up the software environment.](#a-setting-up-the-software-environment)
      - [b. Design](#b-design)
  - [III. Project Requirements:](#iii-project-requirements)
    - [1. FPGA notions.](#1-fpga-notions)
      - [a. Binary:](#a-binary)
      - [b. Gate Operations:](#b-gate-operations)
      - [c. The Clock:](#c-the-clock)
      - [d. LUT:](#d-lut)
      - [Why Understanding LUTs is Essential](#why-understanding-luts-is-essential)
      - [e. Flip-flop:](#e-flip-flop)
    - [2. Gameplay Requirements.](#2-gameplay-requirements)
      - [a. Player Movement:](#a-player-movement)
      - [b. Obstacle Movement:](#b-obstacle-movement)
      - [c. Levels of Difficulty:](#c-levels-of-difficulty)
    - [3. Display Requirements](#3-display-requirements)
      - [a. VGA Display:](#a-vga-display)
      - [b. Sprite Graphics:](#b-sprite-graphics)
      - [c. Color Palette:](#c-color-palette)
    - [4. Debouncing Logic:](#4-debouncing-logic)
    - [5. Game States/ Technical Specifications](#5-game-states-technical-specifications)
      - [a. Initialization:](#a-initialization)
      - [b. Playing:](#b-playing)
      - [c. Game Over:](#c-game-over)
    - [6. Timing and Synchronization](#6-timing-and-synchronization)
    - [7. Folder structure](#7-folder-structure)
  - [IV. Module Breakdown and Design](#iv-module-breakdown-and-design)
    - [1. Top-Level Module](#1-top-level-module)
    - [2. Submodules](#2-submodules)
      - [a. Player Control Module](#a-player-control-module)
      - [b. Obstacle Generation Module](#b-obstacle-generation-module)
      - [c. Collision Detection Module](#c-collision-detection-module)
      - [d. Game Logic Module](#d-game-logic-module)
      - [e. VGA Controller Module](#e-vga-controller-module)
      - [f. Clock Divider Module](#f-clock-divider-module)
  - [V. VGA Timing and Graphics](#v-vga-timing-and-graphics)
    - [1. VGA Signal Generation](#1-vga-signal-generation)
    - [2. Rasterization of Game Objects](#2-rasterization-of-game-objects)
  - [VI. Collision Detection and Game Logic](#vi-collision-detection-and-game-logic)
    - [1. Collision Detection](#1-collision-detection)
    - [2. Game Logic Flow](#2-game-logic-flow)
  - [VII. Implementation Details](#vii-implementation-details)
    - [1. Verilog Code Structure](#1-verilog-code-structure)
    - [2. Finite State Machines (FSMs)](#2-finite-state-machines-fsms)
  - [VIII. Testing and Validation](#viii-testing-and-validation)
    - [1. Testbench Design](#1-testbench-design)
    - [2. Simulation Tools](#2-simulation-tools)
    - [3. Hardware Testing](#3-hardware-testing)
    - [4. Debugging and Optimization](#4-debugging-and-optimization)
  - [IX. Conclusion](#ix-conclusion)
  - [X. Glossary](#x-glossary)
  - [XI. Appendices](#xi-appendices)
    - [1. Verilog Code Snippets](#1-verilog-code-snippets)
    - [2. Block Diagrams and Flowcharts](#2-block-diagrams-and-flowcharts)
    - [3. References](#3-references)

</details>

## I. Introduction

### 1. Project Brief
We have been assigned the task of developing a Frogger game on an FPGA Go Board as project. The game’s primary goal is to successfully guide a frog across a busy road, using the FPGA's button to controller , while skillfully avoiding oncoming traffic. The frog must reach the other side of the road safely without colliding with any vehicles.

The FPGA platform will handle the game’s logic, control mechanisms, and visuals. Our design will incorporate a combination of hardware and software components to ensure smooth interaction between the player's input and the frog's movement.

### 2. Overview
The game will run on an FPGA development board, specifically the Go Board from [NANDLAND](https://nandland.com). Using the buttons on this board, the player will control the movement of a frog: one button for moving left, one for right, one for up, and one for down. The game will be displayed on a VGA monitor, where cars will appear from either the left or right side of the screen. When the frog reaches the top of the screen, the level increases, making the game progressively more challenging.

### 3. Game Specifications
The Go Board's VGA connector will be connected to an external VGA monitor for display. If using an HDMI monitor, a "VGA to HDMI" converter can be used.

The Game Board is a 20 x 15 grid, meaning that the cars and the frog can occupy 20 locations on the X-axis and 15 locations on the Y-axis. The VGA display resolution is 640 x 480 pixels, and the size of the frog will be 1x1 grid size. This means the frog will be 32 pixels wide (640 / 20 = 32) and 32 pixels tall (480 / 15 = 32), making it a square.

The game can be reset to the beginning at any time by pressing all four buttons simultaneously Switch1(SW1) & Switch2(SW2) & Switch3(SW3) & Switch4(SW4).

The VGA display is an RGB display with 3 bits per color channel. This means each channel (Red, Green, and Blue) supports 8 colors (2^3 = 8), and by mixing these, the display can support up to 512 colors (8^3 = 512).

### 4. Objective
- The frog should be represented as a sprite that closely resembles a real frog, with detailed colors.

- Up to 16 cars should be visible on the screen at a time, each capable of moving at different speeds.

- The game should include at least 8 levels. As the level increases, the difficulty should rise, with cars moving faster and their numbers increasing.

### 5. Requirements

- The frog should be displayed as a 1x1 grid on the VGA screen, with each grid cell being 32x32 pixels. The frog must be white in color.

- There should be up to sixteen cars visible on the screen at a time. The car should also be drawn as a 1x1 grid (32x32 pixels) and be white in color.

- The game should include at least one level. The game is complete when the frog successfully reaches the top of the screen.


### 6. Hardware & Software requirements
#### a. Hardware
- FPGA NANDLAND Go Board
- Monitor
- VGA-to-VGA cable
- VGA-to-HDMI adapter for HDMI monitor

#### b. Software
- Visual Studio Code .
- Verilog programming language.
- Github desktop and Github (online)
- Verilog-HDL/SystemVerilog extension.
- Simulation software: [EDAplayground](https://edaplayground.com)


### 7. Target Audience
This document is intended for a diverse audience, primarily software engineers and quality assurance who are involved in the development, testing, and maintenance of software systems. It is designed to provide detailed technical information that will assist developers in understanding and implementing the required specifications, as well as ensuring that the system meets quality standards through comprehensive testing and validation processes.

Additionally, this document is relevant to ALGOSUP.


## II. System Overview
### 1. System Architecture
The image below provides a high-level block diagram of the system, showing interaction between the FPGA, input devices (buttons/switches), display (VGA), and game logic.

![Block-Diagram](images/Block%20Diagram.png)


### 2. Software setting up Design
#### a. Setting up the software environment.
- **MAC OS:**
  - Install Visual Studio Code
  - Go to the Homebrew website.
  - Open the terminal and paste the command you copied from the Homebrew website to install Homebrew.
  - Install Python using the command:

            brew install python

  - Install pip using the command:

            brew install pip
  - Install apio using the command:

        pip3 install apio

  - If you get errors about missing dependencies, use the command:

        pip3 install scons python-serial

  - In case conflicts arise due to pre-existing packages, use a Python virtual environment:

            python3 -m venv apio-env
            source apio-env/bin/activate
            pip3 install apio

- **Windows:**
  - Install Visual Studio Code
  - Install python
  - Open a terminal (cmd) and run:

            pip install apio

  - After installation, initialize Apio using the command:

            apio install system scons icestorm iverilog drivers

  - Install a USB driver using the command:

            apio drivers --serial

- Open Visual Studio Code.
- Create a folder and name it "**And Gate Operation**"
- Inside the "**And Gate Operation**" folder, create a simple ***Verilog*** file(And_Gate.v)
- The **.v** extension is used for all Verilog files.

            /*The following code perform a simple AND operation gate*/


            module And_gate(
                input a, 
                input b, 

                output y
            );

                assign y = a & b;


            endmodule

- Inside the "**And Gate Operation**" folder, create a ***pcf*** file and name it "**Go_Board_Constraints.pcf**". And then use the code below.

            ### LED Pins:
            set_io o_LED_1 56
            set_io o_LED_2 57
            set_io o_LED_3 59

            ### Push-Button Switches
            set_io i_Switch_1 53
            set_io i_Switch_2 51
            set_io i_Switch_3 54
            set_io i_Switch_4 52

- Connect your board to your pc via USB.
- Open the terminal on your pc and and enter the command:

            apio init -b "go-board" -t "And_gate"


            apio upload


   **Comment section:**

       After writing apio init -b "go-board" -t, the next word in quotes should always be the name of the module you want to run. In our case, the module's name is And_gate, so the complete command will be apio init -b "go-board" -t "And_gate".

    **NB:**
   - Type one command at a time. First, enter "**apio init**", press Enter, and wait to see the result. After that, type in apio upload.

   - The command **apio init -b "go-board" -t "And_Gate"** initializes a new project for the NANDLAND Go Board with an AND gate template.

   - The command apio upload transfers your Verilog design to the FPGA board, effectively programming the board to function according to your design.

After running the apio upload command, the image below shows what you should see in your terminal.

  ![TerminalResult](images/TerminalResult.png)



#### b. Design
Before explaining the overall structure and how the hardware will control the game input, game logic, and display output, we will first explain what an FPGA Go Board is. FPGA stands for Field-Programmable Gate Array. It is a type of integrated circuit that allows users to configure and reconfigure its hardware logic to perform specific tasks after manufacturing. This configuration is done using a hardware description language (HDL), such as Verilog or VHDL. In our case, we will use Verilog to carry out the project.

- **Key Points for Explaining an FPGA:**

  - ***Reprogrammable Hardware:***
    Unlike traditional chips that come with fixed functionality, FPGAs are flexible. They can be programmed and reprogrammed to perform different tasks, even after they've been deployed in a system.

  - ***Parallel Processing:***
FPGAs can execute many tasks simultaneously. Unlike a CPU, which processes instructions one after another, FPGAs can handle multiple operations at once, making them highly efficient for specific applications.

  - ***Custom Logic Design:***
With FPGAs, you can design your own digital circuits. Instead of being restricted to predefined functions like with standard processors, you can define how the logic gates and circuits inside the FPGA behave.

  - ***Used in Various Applications:***
FPGAs are used in a wide range of fields, from telecommunications and data centers to automotive systems and video processing. They're ideal for applications that need high-speed processing and the ability to change functionality over time.

  - ***Hardware Description Languages (HDL):***
To program an FPGA, you don't write software as you would for a CPU. Instead, you describe the hardware using HDLs like Verilog or VHDL, which defines how the logic gates and other components should connect and behave.

  - ***High Performance for Specialized Tasks***:
FPGAs are especially useful for tasks that require real-time processing and high speed, like video encoding, signal processing, or machine learning inference.

![FPGA_Board](images/FPGA_Board.png)

As shown in the image above, there are names surrounding the FPGA board. We will explain in detail their roles in this project, including how, where, and when they will intervene.

- **Game structure:**

![FroggerFlowchart](images/FroggerFlowchart.png)

The image above presents a flowchart representation of the Frogger game and how it will function. When we run the command **apio upload,** the game will start and be displayed on the monitor. A menu will appear with two options: **PLAY** or **QUIT**.

The game starts when the player presses **PLAY**, and the frog will spawn at the bottom of the monitor (on the street). There will be at least six roads: three for cars moving from left to right and three for cars moving from right to left. The switches will control the frog's movement, and the objective is to make the frog reach the top of the screen (the other side of the road).

Each time the frog successfully reaches the other side of the road, it will respawn at the bottom of the monitor (on the street), and the level will increase by one, with cars moving faster. The current level number will be displayed on **two seven-segment displays**. This process will continue until there are no more levels.

If the frog is hit by a car, the game will restart from the beginning, regardless of the level the player was on.

The image below shows different state machine of the game logic.

![State-Machine](images/StateMachine.png)


## III. Project Requirements:

### 1. FPGA notions.

In order to carry out the project successfully, here are the primordial notions you must master, and know when and where to use each of them.

#### a. Binary:

Binary, the base-2 number system, is fundamental to all digital systems, including FPGA-based designs. It forms the backbone of how data is represented and processed inside an FPGA. For this project, an understanding of binary is crucial for several reasons, which directly impact how the game logic, input handling, and display output are implemented.

Here’s how binary understanding plays a pivotal role in the project.

- **Digital Logic and Data Representation:**
At the core of any FPGA, all data is processed in binary format. Binary uses only two states: 0 and 1, which correspond to low and high voltage levels in the FPGA's circuitry. Every signal, whether it's controlling the movement of the frog, managing the level progression, or detecting collisions, is represented as binary data.

  - **Frog’s Position:** The frog’s position on the screen is represented as a binary number, encoding its X and Y coordinates in the game grid.

  - **Car Movement:** Each car on the road can be controlled using binary counters or shift registers, moving the cars from one end of the screen to the other.

  - **Switches and Inputs:** The player’s inputs from the switches (up, down, left, right) are read as binary values (1 for pressed, 0 for unpressed). These binary values drive the game logic, determining how the frog moves.

- **Finite State Machines (FSM):**
In digital systems like the Frogger game, finite state machines (FSMs) are used to control the game's flow, such as starting, playing, pausing, or resetting the game. Each state of the FSM is represented using binary encoding.

  - **Game States:** 
The game could have multiple states (e.g., Start, Play, Collision, Game Over). These states are encoded in binary, allowing the FPGA to transition between them efficiently.

  - **Binary State Representation:** For instance, you represent four states as:
    - 00: Start
    - 01: Play
    - 10: Collision
    - 11: Game Over This binary encoding allows you to quickly compare and transition between states.

- **Seven-Segment Display Control:**
In the Frogger game, the level number is displayed on two seven-segment displays. These displays require binary inputs to control which segments are turned on and off to show the correct number.

  - **Binary to Segment Mapping:** Each digit (0-9) on the seven-segment display corresponds to a unique binary pattern. For example, to display the digit "1", a specific combination of segments is illuminated, which is controlled by binary values.

The FPGA will store the binary-encoded level number and then translate this into signals to light up the correct segments on the display.

The following examples show how to capture all possible inputs, from 0000 to 1111(from 0 to F, for hexadecimal, from 0 to 15 for decimal) and translate each number into the correct pattern using the 7-bits, 7-bits as we have 7 segments.

    always @(posedge i_Clk)
      begin
        case (i_Binary_Num)
          4'b0000 : r_Hex_Encoding <= 7'b1111110; //0x7E
          4'b0001 : r_Hex_Encoding <= 7'b0110000; //0x30
          4'b0010 : r_Hex_Encoding <= 7'b1101101; //0x6D
          4'b0011 : r_Hex_Encoding <= 7'b1111001; //0x79
          4'b0100 : r_Hex_Encoding <= 7'b0110011; //0x33
          4'b0101 : r_Hex_Encoding <= 7'b1011011; //0x5B
          4'b0110 : r_Hex_Encoding <= 7'b1011111; //0x5F
          4'b0111 : r_Hex_Encoding <= 7'b1110000; //0x70
          4'b1000 : r_Hex_Encoding <= 7'b1111111; //0x7F
          4'b1001 : r_Hex_Encoding <= 7'b1111011; //0x7B
          4'b1010 : r_Hex_Encoding <= 7'b1110111; //0x77
          4'b1011 : r_Hex_Encoding <= 7'b0011111; //0x1F
          4'b1100 : r_Hex_Encoding <= 7'b1001110; //0x4E
          4'b1101 : r_Hex_Encoding <= 7'b0111101; //0x3D
          4'b1110 : r_Hex_Encoding <= 7'b1001111; //0x4F
          4'b1111 : r_Hex_Encoding <= 7'b1000111; //0x47
          default : r_Hex_Encoding <= 7'b0000000; //0x00
        endcase
      end

- **Collision Detection Logic:**
Collision detection between the frog and cars on the road is based on comparing binary values. The positions of the frog and cars are continuously checked to see if they overlap.

  - **Binary Comparisons:** Checking for collisions is done by comparing the binary values representing the X and Y positions of the frog and the cars. If the binary value of the frog's position matches that of a car’s position, the FPGA registers a collision, and the game resets.


- **Speed Control and Level Progression:**
As the level increases in your game, the cars' speed will increase. This can be controlled using binary counters inside the FPGA. Each time the frog reaches the top of the screen, the level increases, which can be represented as a binary number.

  - **Binary Counters:** The FPGA uses binary counters to control the timing of car movement. The counter value determines how fast the cars move, and as the level progresses, the binary value controlling the speed is increased, resulting in faster movement.


#### b. Gate Operations:
Before starting the project, we have to get use with different gate operations and how do they function. It is mandatory to have deep knowledge on gate operation for this project.

- **AND GATE:**
![AND_Gate](images/ANDGate.png)

  An AND gate is a logic gate whose output is high only when both inputs are high or 1 in binary mode.

  |Input A | Input B | Output |
  |--------|-------- |--------|
  |0       |0        |0       |
  |0       |1        |0       |
  |1       |0        |0       |
  |1       |1        |1       |

- **NAND GATE:**
![NAND_Gate](images/NANDGate.png)

  The NAND gate is thus the same as the AND gate, but inverted. If both inputs are high, the output will be low.

  |Input A | Input B | Output |
  |--------|-------- |--------|
  |0       |0        |1       |
  |0       |1        |1       |
  |1       |0        |1       |
  |1       |1        |0       |

- **OR GATE:**
![OR_Gate](images/OrGate.png)

  The output of the OR gate is high when one of the input is high or when both inputs are high.

  |Input A | Input B | Output |
  |--------|-------- |--------|
  |0       |0        |0       |
  |0       |1        |1       |
  |1       |0        |1       |
  |1       |1        |1       |

- **XOR GATE:**
![XOR_DGate](images/XORGate.png)

  The output of the XOR gate is high when either of the inputs is high, but not both.

  |Input A | Input B | Output |
  |--------|-------- |--------|
  |0       |0        |0       |
  |0       |1        |1       |
  |1       |0        |1       |
  |1       |1        |0       |

- **NOT GATE:**
![NOT_Gate](images/NOTGate.png)

  The NOT gate has a single input and  a single output, and it's kind of invert, ie the output is ***not*** the input.

  | Input  | Output  |
  | ------ | ------- |
  |0       |1        |
  |1       |0        |


In the Frogger game project, logic gates are used extensively for:

- Input control to validate and execute frog movement.
- Collision detection by comparing binary positions of the frog and cars.
- State management for transitioning between different game states (Start, Play, Game Over).
- Display control to convert binary level data into signals for the seven-segment display.
- Speed control to adjust car movement timing based on the level.

By leveraging basic logic gates (AND, OR, NOT, XOR), we will design and implement the core functionality of the game in an efficient and reliable manner within the FPGA. This understanding is key to ensuring that your Verilog code correctly models the desired behavior of the game.

#### c. The Clock:
The clock signal in theFrogger game project is crucial because it provides the timing framework that synchronizes all operations. It controls the rate of movement for the frog and cars, manages input debouncing, drives the display refresh, and ensures collision detection happens in real-time. Without the clock, these critical operations would be unsynchronized, leading to erratic gameplay and inconsistent behavior.

In summary, the clock is necessary for:

- Synchronizing game logic and state transitions.
- Controlling the timing of movements for both the frog and the cars.
- Refreshing the display output consistently.
- Debouncing player inputs from switches.
- Managing level progression and adjusting the speed of gameplay.
- Ensuring real-time collision detection.

By understanding and utilizing the clock properly, the Frogger game will operate smoothly and in a synchronized manner on the FPGA platform.


#### d. LUT:
A Look-Up Table (LUT) is a fundamental component in Field-Programmable Gate Arrays (FPGAs) that plays a critical role in how logic functions are implemented. LUTs are used to map input combinations to corresponding output values based on predefined logic. In the Frogger game project, understanding LUTs is crucial because they define how Verilog code is translated into actual hardware behavior inside the FPGA.

Here’s an explanation of LUTs and their importance in the project:

- LUT is a small memory block that stores pre-calculated outputs for every possible combination of input values. Instead of computing the result of a logic function on-the-fly, the LUT stores all the possible outputs of a logic function and retrieves the correct output when given a specific input.

  - **Inputs and Outputs:**
A LUT can take multiple binary inputs (typically 4 to 6) and produce a single binary output based on a predefined truth table.
For example, a 4-input LUT can have 16 possible input combinations (2⁴), and it stores the corresponding output for each combination.

- In an FPGA, logic gates and functions such as AND, OR, XOR, NOT, NAND, are implemented using LUTs rather than physical gates. When you write Verilog code to describe your Frogger game (e.g frog movement, collision detection, level display), the FPGA’s synthesis tool translates the logic into a series of LUTs.

  - **Efficient Logic Implementation:**
    - Instead of constructing logic functions using individual gates like in traditional digital circuits, FPGAs use LUTs to store the results of those functions. This makes logic processing much faster and more efficient.

    - For instance, a simple function like Y = A AND B can be stored in a 2-input LUT, where the table contains all possible input combinations of A and B and the corresponding outputs.

  - For example: For an AND gate with two inputs, the LUT stores the output of the operation.
When the inputs are A=1 and B=1, the LUT quickly looks up the result (1) without performing any real-time computation.

#### Why Understanding LUTs is Essential

- **Efficient Logic Synthesis:** LUTs allow you to implement complex logic functions (e.g., frog movement, collision detection) efficiently in the FPGA without needing to physically construct each logic gate.

- **Fast Decision Making:** Since LUTs store precomputed results, the FPGA can quickly retrieve the output without having to recompute the logic, ensuring real-time performance in the game.

- **Optimizing Resource Usage:** The FPGA’s synthesis tool optimizes how LUTs are used, minimizing the number of logic resources required. This is important for fitting all the game logic into the limited hardware resources of the NANDLAND Go Board.

- **Simplified Design Process:** LUTs abstract the complexity of designing logic circuits manually, allowing you to focus on higher-level game functionality in Verilog.


In the Frogger game project, LUTs are crucial components of the FPGA, enabling efficient implementation of the game’s logic. From frog movement to collision detection, and from state management to displaying levels, LUTs handle the core operations by storing precomputed logic functions. Understanding how LUTs work and their role in FPGA programming is essential for developing an optimized and responsive game. This helps the FPGA run the game smoothly by minimizing computation time and efficiently using hardware resources.


#### e. Flip-flop:
// Flipflop image
A flip-flop is a fundamental memory element in digital circuits that stores a single bit of data (either 0 or 1) and is essential for implementing sequential logic in FPGAs. Unlike combinational logic (which depends only on current inputs), sequential logic requires storing past states and updating them based on a clock signal. Flip-flops help in this process by storing data from one clock cycle to the next.

In the Frogger game project, flip-flops will be used for several crucial tasks, including storing the current state of the game, tracking the frog’s position, and keeping time for movement updates.

On the image below we can see **D, En, >, and Q**. This simply shows that the flip-flop has 3 on the left inputs and 1 output on the right.
- The top left input **D** is the data input of the flip-flop, ie it is either 1 or 0 in binary format.
- The bottom left input **>** is the clock input, helps to synchronize the performance of the flip-flop. It triggers and take data from the data input (D), at regular time intervals, then pass it to **Q**, which is the output.
- The middle left input **En** is the clock enable, when the clock enable is high or 1, the clock triggers the flip-flop to update its output, but when the clock enable is low or 0, the clock doesn't triggers the flip-flop.

In the Frogger game project, flip-flops are crucial elements used to store and update game state information such as the frog’s position, current game level, and FSM state. They ensure that changes to the game’s state happen synchronously with the clock, providing smooth, real-time gameplay. Flip-flops are also used for timing circuits that control movement speed and debouncing circuits that handle player inputs. Without flip-flops, it would be impossible to implement the sequential logic necessary to make the game function properly on the FPGA.

- **Memory Elements for Sequential Logic:** Flip-flops store the data that defines the current state of various game elements (frog position, level, state of the game). This is essential for making the game responsive to both player inputs and game events.

- **Synchronized Updates:** Since flip-flops change state only on a clock edge, they ensure that the game operates in a synchronized manner, with updates occurring at consistent intervals.

- **State Transitions:** The flip-flops used in the FSM(Finite State Machine) control how the game transitions between different states (e.g., from "Play" to "Game Over").

- **Timers and Counters:** Flip-flops are used in timing circuits, such as the one that controls car speed. They help count clock cycles to regulate movement and gameplay events.

- **Debounced Input Signals:** Flip-flops are essential for stabilizing player inputs and ensuring that movement occurs correctly when switches are pressed.

### 2. Gameplay Requirements.

#### a. Player Movement:
The player movement in the Frogger game will be controlled using the four switches on the Nandland Go Board. Each switch corresponds to a specific direction, and pressing a switch will move the frog accordingly. Below, we will explain the Verilog code for implementing this functionality and discuss the roles of the clock, lookup tables (LUTs), flip-flops, and logic gates in this context.

- **Switch Control Overview:**
  - **Switch 1 (SW1):** Moves the frog left.
  - **Switch 2 (SW2):** Moves the frog down.
  - **Switch 3 (SW3):** Moves the frog up.
  - **Switch 4 (SW4):** Moves the frog right.

  ![Switches](images/Switches.png)

- **Verilog Code Implementation:**
The frog's position will be represented by two registers, **x_position** and **y_position**, which will be updated based on the state of the switches. The movement speed is defined by a parameter called **MOVE_SPEED**, which determines how many pixels the frog moves with each switch press.

        // Registers to store frog's current position
        reg [9:0] x_position;  // 10-bit register for x-coordinate (0-639 for 640 pixels)
        reg [9:0] y_position;  // 10-bit register for y-coordinate (0-479 for 480 pixels)

        // Movement speed (in pixels)
        parameter MOVE_SPEED = 10; // Speed of movement

        // Input: switch signals (active high)
        input wire SW1, SW2, SW3, SW4; // Switches for movement

        // Clock signal for synchronous logic
        input wire clk;

        // Always block to handle frog movement
        always @(posedge clk) 
          begin
            // Fog movement logic
          end
        end

    **NB:** The frog should start at the following coordinates on the screen
    - x-coordinate = 320
    - y-coordinate = 480

- **Explanation of Components Involved**
  - **Clock:**
 In the code, the always @(posedge clk) statement indicates that the logic inside the block executes on the rising edge of the clock signal.
 This means the frog’s position is updated only once per clock cycle, ensuring predictable and orderly movement.

  - **Lookup Tables (LUTs):**
FPGAs use LUTs to implement combinational logic functions. In this case, the logic for detecting switch presses will be implemented in LUTs.
The states of the switches are inputs to the LUTs, which will determine the output signals for moving the frog. LUTs can evaluate the conditions for movement and provide the necessary control signals to update the frog’s position based on the switch inputs.

  - **Flip-Flops:**
Flip-flops are used to store the current state of the frog's position (x_position and y_position). Each time the clock rises, the values of these registers are updated.
When a switch is pressed, the flip-flops store the new position of the frog. Without flip-flops, the position would not be retained across clock cycles.

  - **Logic Gates:**
Basic logic gates (AND, OR, NOT) are used to implement the logic that controls movement. For instance, when a switch is pressed, the corresponding logic gate will detect the input and enable the movement condition.
For example, the condition to move up can be described as:
    if (**SW1 AND y_position > 0**) using an AND gate to ensure both conditions are true before executing the movement.

- **Movement Speed Control:** The parameter MOVE_SPEED controls how far the frog moves with each switch press. We will adjust this parameter to make the movement we need, depending on gameplay requirements. The frog will move 32 pixels instead of 10, this will be change during the development phase. 

- **Debouncing Switches:**
Switches can produce noise when pressed (known as bouncing), which may cause multiple signals to be registered. To ensure that only a single clean signal is read when a switch is pressed, a debouncing mechanism using flip-flops can be implemented.


#### b. Obstacle Movement:
In the Frogger game, the movement of cars is automatic and will alternate between left-to-right and right-to-left across multiple roads (lanes). There are 10 horizontal roads, and on each road, cars will move at different speeds. As the player advances through levels, the speed of the cars will increase. There will always be up to 16 cars on the screen, distributed across the roads, and each car occupies one grid (32x32 pixels). Below, I’ll explain how the movement will be implemented, including speed control, direction, and reset behavior.

#### c. Levels of Difficulty:
//Explain how the game increases in difficulty (faster-moving obstacles, more obstacles, etc.) as the player progresses through levels.

Each time the player moves the frog from the spawning street way, to the opposite street way on the other side of the road, the level increases by 1, the level number is shown on the 7 segments display, and the cars increases in speed, making the game much more difficult.
For example for level 1, the 7 segment will display something like this; **01**, and so on.

![Segments](images/SEGMENTS.png)

### 3. Display Requirements
#### a. VGA Display:
//Detail the screen layout (dividing it into road lanes for cars and river lanes for logs and water).

#### b. Sprite Graphics:
//Define the graphical representations of the frog, cars, logs, and other game elements (pixel sizes, colors, etc.).

#### c. Color Palette:
//List the colors for each object on the screen (e.g., green for frog, red for cars, blue for water).

### 4. Debouncing Logic:
//Explain the debouncing technique implemented in Verilog to ensure clean button presses.

### 5. Game States/ Technical Specifications
#### a. Initialization:
Define the initial state of the game, including resetting scores and lives.

#### b. Playing:
Detail the game flow during active play, including movement, collisions, and scoring.

#### c. Game Over:
Explain the conditions for game over (e.g., loss of all lives) and resetting the game.

### 6. Timing and Synchronization
Explain how the FPGA’s clock is divided for game logic and VGA output timing (e.g., 50 MHz system clock divided down to 25 MHz for VGA).
Define the refresh rate of the VGA display and timing constraints to ensure smooth gameplay.

### 7. Folder structure
//Folders: arrangement of files and naming of files
// 

## IV. Module Breakdown and Design

### 1. Top-Level Module
Describe the top-level Verilog module that integrates the entire game (connections between all sub-modules).

### 2. Submodules
#### a. Player Control Module

This module handles the player’s input to move the frog. Include input handling, movement logic, and boundary checks.
#### b. Obstacle Generation Module

Generate moving cars and logs in their respective lanes. Describe how obstacle positions are updated and how speed varies between lanes.
#### c. Collision Detection Module

Define the conditions for collisions between the frog and obstacles. Explain how the collision logic is different for each type of obstacle (e.g., cars vs. logs).
#### d. Game Logic Module

Explain the FSM (Finite State Machine) used for managing game states: start screen, active play, level progression, game over, etc.
Discuss how scoring is handled and how the player progresses to the next level.
#### e. VGA Controller Module

This module generates VGA signals and displays the game screen. Include pixel rendering logic for displaying sprites (frog, obstacles) and background.
Detail how the screen refreshes and updates to reflect changes in gameplay (movement, collisions).
#### f. Clock Divider Module
Explain the clock divider that reduces the 50 MHz clock to a manageable frequency for VGA and game logic (e.g., 25 MHz).


## V. VGA Timing and Graphics

### 1. VGA Signal Generation
Explain the VGA signal protocol (horizontal sync, vertical sync, pixel data).
Define the exact timing parameters for a 640x480 display (front porch, sync pulse, back porch, and display area).

### 2. Rasterization of Game Objects
Describe how the game objects (frog, cars, logs, water) will be mapped onto the VGA screen.
Define pixel data mapping and how the game objects’ positions are updated during gameplay.


## VI. Collision Detection and Game Logic

### 1. Collision Detection
Describe the logic for detecting collisions between the frog and obstacles (pixel-by-pixel collision).
Discuss how different types of collisions result in different outcomes (e.g., frog colliding with a car results in death, while landing on a log allows safe passage across the water).

### 2. Game Logic Flow
Explain the overall game flow (start, play, game over).
Define how lives, score, and levels are managed.
Describe what happens when the frog reaches home (score increase, next level).

## VII. Implementation Details

### 1. Verilog Code Structure
Provide a high-level overview of the directory structure for the Verilog codebase, with subfolders for modules, testbenches, and scripts.

### 2. Finite State Machines (FSMs)
Describe FSMs used for different aspects of the game (e.g., game states, obstacle movement).
Include state diagrams to show transitions between different states.


## VIII. Testing and Validation
### 1. Testbench Design
Explain how Verilog testbenches will be used to simulate individual modules for correctness.

### 2. Simulation Tools
Mention the simulation tools (e.g., ModelSim, Vivado) that will be used to validate the design.

### 3. Hardware Testing
Describe the process of deploying the design onto the FPGA and performing real-time testing with actual input devices and VGA output.

### 4. Debugging and Optimization
Explain techniques used for debugging, such as signal monitoring with an Integrated Logic Analyzer (ILA) or chipscope.


## IX. Conclusion

Summarize the purpose and goals of the design.
Highlight the expected outcome of the project, including game playability, display quality, and performance.


## X. Glossary



## XI. Appendices

### 1. Verilog Code Snippets
Include relevant portions of the Verilog code (e.g., key modules like VGA controller or collision detection).

### 2. Block Diagrams and Flowcharts
Add any relevant diagrams to help visualize the system architecture and module interactions.

### 3. References
List references to FPGA board documentation, VGA signal standards, and any related work.