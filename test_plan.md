# Test-Plan

|Author|CHIOCCHI Raphaël|
|---|---|
|Created|23/09/2024|
|Last modified|21/10/2024|

## Test-Plan-Approval

| Role | Name | Signature | Date |
|---|---|---|---|
| Project Manager | Lucas AUBARD    |----------|21/10/2024|
| Program Manager | Julian	REINE   |----------|21/10/2024|
| Technical Lead | Vivien Bistrel	TSANGUE CHOUNGOU |----------|21/10/2024|
| Software Developer | Manech	LAGUENS |----------|21/10/2024|
| Software Developer | Mariem	ZAIANE |----------|21/10/2024|
| Technical Writer | Abderrazaq	MAKRAN    |----------|21/10/2024|
| Quality Assurance | Raphaël	CHIOCCHI |----------|21/10/2024|

---
<details open>

<summary>Table-of-Contents</summary>

- [Test-Plan](#test-plan)
  - [Test-Plan-Approval](#test-plan-approval)
  - [I. Introduction](#i-introduction)
    - [1. Overview](#1-overview)
    - [2. Targetted Audience](#2-targetted-audience)
      - [a. Old Player](#a-old-player)
      - [b. Newer Player](#b-newer-player)
    - [3. Softwares Hardwares](#3-softwares-hardwares)
      - [a. Verilog](#a-verilog)
      - [b. FPGAs (Go-Board)](#b-fpgas-go-board)
  - [II. Test Criteria](#ii-test-criteria)
      - [a. Critical-Bugs](#a-critical-bugs)
    - [1. Entry Criteria](#1-entry-criteria)
    - [2. Exit Criteria](#2-exit-criteria)
  - [III. Test Strategy](#iii-test-strategy)
    - [1. Testing Scope](#1-testing-scope)
    - [2. Testing Type](#2-testing-type)
      - [a. Unit Tests](#a-unit-tests)
      - [b. Functional Tests](#b-functional-tests)
    - [3. Define Priorities](#3-define-priorities)
    - [4. Test Tool](#4-test-tool)
      - [a. Github](#a-github)
      - [b. Excel](#b-excel)
    - [5. Test Cases](#5-test-cases)
    - [6. Test Reports](#6-test-reports)
  - [IV. Test Deliverables](#iv-test-deliverables)
  - [V. Glossary](#v-glossary)

</details>

## I. Introduction

### 1. Overview

Our team was tasked with creating a Frogger-style game, with the additional challenge that it had to be coded in assembly and run on an FPGA chip called the "Go-board". This Frogger clone will serve as a nostalgic trip back to the arcade's golden age, offering a classic experience of dodging traffic and navigating obstacles. The game provides a simple yet engaging gameplay loop that highlights the essence of retro gaming, making it both fun and challenging. It’s a great way to introduce newer generations to the charm of vintage arcade titles, fostering a deeper appreciation for the early days of video game design. Overall, this project aims to deliver a timeless experience that connects the past with the present, offering entertainment that resonates across generations.

### 2. Targetted Audience
#### a. Old Player

The old players are nostalgic gamers who have a deep appreciation for classic arcade experiences. This is for those who remember the thrill of Frogger from the 1980s and want to revisit the excitement of dodging traffic.

#### b. Newer Player

Newer players are those who may have never played the original Frogger or experienced the arcade era firsthand. Since Frogger was especially popular during the 80s and 90s but has since faded from the spotlight, these new players will have the opportunity to discover the charm of the game and explore the rich history of retro gaming. This game is an introduction to a bygone era, offering both nostalgia and a fresh perspective for younger audiences.

### 3. Softwares Hardwares

Here are the software and hardware elements used in this project :

#### a. Verilog
Verilog is the hardware description language we'll use to develop the game. This low-level language allows us to design the game’s logic directly on the FPGA, ensuring optimal speed and performance. Since the Go-board has limited resources compared to modern computers, efficient code is essential to achieve smooth gameplay.

#### b. FPGAs (Go-Board)
The Go-board is the hardware that will run the game. Unlike a traditional CPU, the FPGA provides parallel processing capabilities, making it suitable for implementing the game’s logic and real-time processing. This board is where the game’s core functionality such as handling player input, rendering graphics, and managing obstacles will be executed.

## II. Test Criteria
#### a. Critical-Bugs
Critical bugs are issues that prevent the game from functioning properly or block the implementation of new features until they are resolved. If we encounter a critical bug, we will immediately suspend the testing cycle and focus on resolving the issue before continuing. These bugs could involve game crashes, unresponsive controls, or major functionality failures, and must be addressed promptly to ensure the game runs smoothly on the Go-board
### 1. Entry Criteria

Entry criteria define the conditions that must be met before the testing process can begin. These criteria ensure that the testing environment is properly prepared and that the software is in a state where meaningful tests can be performed. The entry criteria for this project are as follows:

* The testable code must be available and compiled for the Go-board environment.        
  

* The test environment must be fully set up and operational, including the Go-board, necessary simulation tools, and testing frameworks. If any issues arise in the test environment, such as problems with simulation software, they must be resolved first.
* The test cases must be written and cover the functional requirements, ensuring that all aspects of the game are tested.

### 2. Exit Criteria

Exit criteria define the conditions that must be satisfied to conclude the testing phase and confirm the game is ready for deployment. For this project, the exit criteria include:

* All tests planned for the project have been run and completed successfully.     

* The level of requirement coverage is at least 80%, ensuring that most of the critical game functionalities have been tested.

* There are no critical or high-severity defects left unresolved. Any major bugs or performance issues must be fixed before the end of testing.
* All high-risk areas of the game, such as player movement, collision detection, and obstacle interactions, have passed their respective tests.
* All medium and low-severity bugs have been reported through the issue tracker, such as GitHub Issues or an alternative system (like a spreadsheet) if GitHub is unavailable.
* By adhering to these criteria, we ensure that the game meets quality standards and is ready for release.

## III. Test Strategy

The testing will be in charge of Team 3's QA, CHIOCCHI Raphaël, and with help of Abderrazaq Makran, Team 3's QA.

### 1. Testing Scope

The two main aspects to test during this project will be the documentation and the game itself.

Ensuring the quality of the documents is crucial for aligning the entire team on the same objectives. We will carefully review the documents not only for grammatical and typographical accuracy but also for content integrity. It's important to verify that all key points are clearly articulated and that no critical information has been missed or inaccurately presented. This will help prevent any misunderstandings or miscommunications during development.

When it comes to the game, we will be rigorously testing all the features outlined in the functional specifications to ensure they align with the original design intent. Additionally, since the game will run on the Go-board, we will test its functionality directly on the hardware to confirm performance and playability. The goal is to verify that the game runs smoothly and that all elements, like graphics, input handling, and obstacle logic, work as expected. While the game is not intended to run on traditional operating systems like Windows or macOS, testing on simulation platforms or using software tools that replicate FPGA environments may be necessary for debugging or verifying design.

### 2. Testing Type
#### a. Unit Tests
A unit test focuses on testing individual components or small pieces of the game’s logic in isolation to ensure they work as expected. Each unit test will verify the correctness of a single function or module within the game, such as input handling, movement logic, or collision detection. Since the game is being developed on an FPGA platform (Go-board), we will primarily be testing the Verilog modules and their interactions to make sure they behave as intended.

Some key areas we will focus on for unit testing include:

* Player Movement Logic: Testing whether the player can move correctly in all four directions (up, down, left, right) based on input. We will ensure the movement is accurate and does not cause unintended behaviors, such as moving through walls or objects.

* Collision Detection: Verifying that the player’s interactions with obstacles are correctly detected. We will test scenarios where the player should be hit or where movement should be blocked.

* Object Spawning and Behavior: Ensuring that game objects, like vehicles or logs, spawn at the correct locations and move as expected, according to game rules. This will involve testing how these objects behave in terms of speed, direction, and interaction with the player.

* Input Handling: Verifying that the user’s controls (button presses or other input methods) are processed correctly and result in the intended actions within the game.

Unit tests will be automated and run frequently to ensure new code changes do not introduce regressions.

#### b. Functional Tests

Functional testing focuses on validating the overall functionality of the game and ensuring it meets the user requirements outlined in the functional specifications. This type of test checks whether the game behaves as expected from a user’s perspective and ensures that all the integrated components work together seamlessly to provide the intended gameplay experience.

Functional tests will cover entire game sequences and user interactions, such as:

* Gameplay Flow: Verifying the game’s core functionality, such as starting the game, navigating the levels, and completing objectives. We will ensure that all game features (like earning points, crossing roads, and avoiding obstacles) work in harmony to provide a seamless experience.

* Game Controls: Testing the responsiveness of the game’s controls (e.g., the player’s ability to move, jump, and avoid hazards) and ensuring they match the design expectations. This will also include testing the player’s ability to pause, restart, or quit the game.

* Game Win/Loss Conditions: Checking if the game correctly handles the win and loss conditions. For example, does the game display the appropriate message when the player successfully crosses all lanes or loses all lives? Does the scoring system reflect correct gameplay actions?

* Game Features: Testing any secondary features, such as score tracking, high-score saving, or special power-ups. We will check that these features are fully functional and integrated into the gameplay loop.

* Performance: Although not a formal requirement, we will also ensure that the game runs smoothly on the Go-board FPGA without lag or performance degradation. This will include testing for frame rate consistency and responsiveness to user input.

Functional tests will be carried out both in a simulated environment and on the actual Go-board hardware to ensure the game performs as expected in the final deployed system.

### 3. Define Priorities

Prioritizing tests is essential for ensuring that the most critical issues are addressed first. Test priorities will be directly correlated with the functional specifications, which will define the key features and functionalities of the game. We will establish four levels of priority for testing:

* Critical: These are tests that must be addressed immediately as they impact the core functionality of the game. Critical issues could include crashes, unresponsive controls, or severe performance problems.    
  
*  High: High-priority tests involve important features that significantly affect gameplay or player experience. While they may not stop the game from running, they still need to be addressed quickly to ensure quality.
* Medium: Medium-priority tests are related to less critical functionalities or minor gameplay issues that do not immediately disrupt the user experience. These will be addressed once higher-priority issues are resolved.
* Low: Low-priority tests focus on enhancements or non-essential features. These could include minor visual tweaks or optimizations that are not critical but may improve the game’s overall polish.
  
Priorities are not fixed and can change during the development process. For example, a high-priority feature that initially seems essential may be downgraded to medium or low priority if it proves to be more complex than expected or if development challenges arise. This dynamic approach will allow us to remain flexible and responsive to project needs as they evolve.

### 4. Test Tool
#### a. Github

Github will be used to report bugs with its included "Issue" tab, where we can create templates of tickets to use in different situations.

#### b. Excel

Excel will be used to list down every test cases that the testing team will have to operate.

### 5. Test Cases
The Excel document will provide an easy way for the QA team to keep track of which tests have been run, which features are covered, and which ones still need to be validated. Using Excel allows for clear, structured, and easily shareable test cases.

The Excel document will contain the following key sections:

* Test Case ID: A unique identifier for each test case for easy reference.
* Test Case Title: A clear and explicit title that describes the functionality being tested (e.g., "Player Movement Up Key Test").
* Description: A short description of what the test is checking.
* Test Steps: A step-by-step guide on how to execute the test, e.g., "Press the Up key and verify the player moves one grid space upward."
* Expected Result: What we expect to happen, such as "Player moves one grid space upward without errors."
* Status: Whether the test was Passed, Failed, or Blocked.
We will also include a Priority field (Critical, High, Medium, Low) to help organize the tests based on the feature’s importance or potential impact on gameplay.

Since we are using Excel, the whole team (including developers, testers, and project managers) will be able to track progress in real time. The Excel file will be regularly updated, and we’ll use it to ensure all critical functionality is covered, as well as to highlight any features that are still being tested or have not been implemented yet.

### 6. Test Reports

For bug reports, we will use GitHub Issues to document and manage any bugs discovered during testing. Each bug report will be created as an Issue and will follow a consistent format to ensure clarity and effective communication.

Each bug report will include the following:

* Title: A clear and explicit title that describes the bug (e.g., "Player does not move when 'Up' key is pressed").
  
* Description: A detailed explanation of the bug, including the steps to reproduce it and the impact it has on the game (e.g., "Player is unable to move when the 'Up' key is pressed, blocking progress through the level").
* Steps to Reproduce: A step-by-step guide on how to trigger the bug (e.g. "1. Launch the game, 2. Press the 'Up' key, 3. Observe that the player does not move").
* Expected Result: What should happen if the bug were not present (e.g., "Player should move one grid space upward").
Actual Result: What actually happens when the bug occurs (e.g., "Player remains stationary and does not move at all").
* Severity: The impact of the bug, classified as Critical, High, Medium, or Low, based on how it affects gameplay.
Assigned To: The developer or team member responsible for fixing the bug.
* Status: The current state of the bug (e.g., Open, In Progress, Resolved).
* Comments: Any additional notes, including testing results after the bug is fixed.
Each bug report will be labeled with the "Bug" tag, and the relevant person will be assigned to resolve the issue. Once a bug is fixed, QA will verify the fix and update the issue status to reflect its resolution.

This system will ensure that all bugs are tracked transparently, and the team can stay on top of fixes and improvements. Additionally, it allows for a streamlined process in terms of bug reporting, prioritization, and resolution.

## IV. Test Deliverables

The **Test Plan** or **Test Strategy** defines the overall approach to testing, outlining how the game will be tested, what types of tests will be conducted, and the process for reporting results.   

**Test Cases** are the detailed, step-by-step instructions for executing the tests. These are created as **GitHub Issues**, ensuring clear visibility and tracking of each test case.

A **Bug Report** details all the issues discovered during testing, ensuring they are communicated clearly to the development team for resolution.

The **Bug Data Report** provides an aggregated, high-level view of all the bugs found during testing. This report will help stakeholders understand the overall health of the game and the progress being made to address issues.

## V. Glossary

| **Term**                     | **Description**                                                                                                                                                               |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **FPGA (Field-Programmable Gate Array)** | An integrated circuit that can be programmed to perform a wide range of tasks, such as processing data or controlling hardware. In this project, the "Go-board" FPGA will run the Frogger-style game.  |
| **Verilog**                   | A hardware description language (HDL) used to model electronic systems. In this project, Verilog is used to program the Go-board, defining game logic like player movement and object interactions. |
| **Unit Test**                 | A type of software testing that focuses on individual components to ensure they perform as expected. In this project, Verilog modules like player movement or collision detection will be unit tested. |
| **Functional Test**           | Testing the overall gameplay experience, ensuring all components work together as expected. This includes testing gameplay flow, controls, win/loss conditions, and performance. |
| **Critical Bug**              | A defect that severely impacts the core functionality, such as causing crashes or making the game unplayable. These bugs must be fixed immediately to continue development or testing.  |
| **High Priority Bug**         | A defect that significantly affects gameplay but does not make the game unplayable. These bugs should be addressed quickly but do not halt the testing cycle.                        |
| **Medium Priority Bug**       | A minor issue that doesn’t disrupt gameplay significantly. These bugs are addressed after critical and high-priority bugs have been resolved.                                     |
| **Low Priority Bug**          | An enhancement or cosmetic issue that doesn’t affect gameplay. These bugs can be fixed later in the development cycle.                                                          |
| **Test Case**                 | A set of conditions used to verify that a specific feature or functionality works as intended. Test cases are documented in Excel and executed to ensure full feature coverage. |
| **GitHub Issues**             | A feature within GitHub used for tracking bugs, creating tickets for test cases, and assigning tasks to developers. All bug reports and test cases will be documented using GitHub Issues. |
| **Excel (for Test Cases)**    | Excel will be used to list and track test cases, with details like test steps, expected results, and test status (pass/fail/block). This helps the QA team manage and track progress. |
| **Test Plan / Test Strategy** | The overall approach to testing, including scope, types of tests, methodologies, and reporting. This document ensures all aspects of the game are tested and quality is maintained. |
| **Bug Report**                | A detailed report of a bug discovered during testing, including how to reproduce it, severity, and the impact on gameplay. Bug reports will be logged as GitHub Issues.               |
| **Go-board**                  | The FPGA hardware used to run the game. The Go-board Has been created by Russell Merrick.               |
