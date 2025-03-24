# Basys3_Stack_Calculator #

The stack consists of 128 locations that each hold 8 bits. Instructions are encoded by the four buttons on the Basys3 board.
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
