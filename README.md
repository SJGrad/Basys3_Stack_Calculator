# Basys3_Stack_Calculator #

The stack consists of 128 locations that each hold 8 bits. Instructions are encoded by the four buttons on the Basys3 board. The stack calculator does not check for overflow or underflow conditions.
## Instructions to Implement ##

Mode/Instruction | Button 3 | Button 2 | Button 1 | Button 0
:--------------: | :------: | :------: | :------: | :------:
Push/Pop | 0 | 0 | Pop | Push
Add/Subtract | 0 | 1 | Subtract | Add
Clear/Top | 1 | 0 | Clear | Top
Dec/Inc | 1 | 1 | Dec Addr | Inc Addr

**Note: The stack grows towards address 0x00 and the stack pointer register (SPR) points to the next available address**

* Pop: leave all buttons unpressed then press Button 1.
  * Pops the value on the top of the stack.
* Push: leave all button unpressed then prress Button 0.
  * Pushes the 8-bit value specified by the switch 0-7 onto the stack.
* Subtract: hold Button 2 down then press Button 1.
  * Pops two values off the stack, subtracts lower address value from the higher address value, then pushes the result.
* Add: hold Button 2 down then press Button 0.
  * Pops two values off the stack, adds them while discarding the carry, then pushes the result.
* Clear: hold Button 3 down then press Button 1.
  * Clears the stack, setting every value to 0x00. Sets the SPR to 0x7F.
* Top: hold Button 3 down then press Button 0.
  * Sets the data address register (DAR) to the topmost value on the stack.
* Dec Addr: hold Button 3 and Button 2 down then press Button 1.
  * Decrements the DAR.
* Inc Addr: hold down Button 3 and Button 2 down then press Button 0.
  * Increments the DAR.
## State Machine Chart
![SM_stack_calculator](https://github.com/user-attachments/assets/fd5a2c29-bd45-49a6-abdd-da63b30796ab)

## Block Diagram
![image](https://github.com/user-attachments/assets/6e91f394-f418-4bbe-b92a-53d8d1df2d65)

## Board Examples ##

### Example 1 ###
**Clear -> Push 0x33 -> Push 0x11 -> Pop**

<img src="https://github.com/user-attachments/assets/42fd6c55-ccfd-4afe-b2ae-804500866014" alt="Alt Text" style="width:100%; height:auto;">

<img src="https://github.com/user-attachments/assets/3c82070a-d2cb-4ab1-bfbd-03106f616930" alt="Alt Text" style="width:33%; height:auto;"> <img src="https://github.com/user-attachments/assets/c68e6c1d-5812-4378-a8b6-db8997373153" alt="Alt Text" style="width:33%; height:auto;"> <img src="https://github.com/user-attachments/assets/45a1dba7-b22c-429f-a934-4be6549314b1" alt="Alt Text" style="width:33%; height:auto;">

### Example 2 ###
**Clear -> Push 0x33 -> Push 0x11 -> Add**

<img src="https://github.com/user-attachments/assets/42fd6c55-ccfd-4afe-b2ae-804500866014" alt="Alt Text" style="width:100%; height:auto;">
![image](https://github.com/user-attachments/assets/af279e90-dfcc-4d43-b84d-1ddfbe896fee)

**After Clear**



**After both Pushes**



**After Add**

![image4](https://github.com/user-attachments/assets/1bb01e9a-c776-4313-9aba-37e0190d5415)

### Example 3 ###
**Clear -> Push 0x33 -> Push 0x11 -> Add**
