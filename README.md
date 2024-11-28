# ARM Assembly Programming Project

## Project Overview
This project involves developing an **ARM assembly program** using Keil uVision 5. The program manipulates strings and performs various operations such as case conversion, character matching, and encryption. The key specifications and deliverables are outlined below.

---

## Specifications

### 1. Declaring Strings in Memory
- Define two strings in memory, each containing a mix of uppercase and lowercase letters.
- Example: `"Arm Assembly Programming"`

### 2. Procedure: Convert to Lowercase
- A procedure converts all uppercase letters in a string to lowercase.
- The procedure:
  - Converts uppercase characters to lowercase.
  - Counts the number of converted characters.
  - Stores the results in:
    - `TXT1` and `TXT2`: Lowercase strings.
    - `Count1` and `Count2`: Number of converted characters.

### 3. Procedure: Count Common Characters
- This procedure calculates the number of common characters between two strings, ignoring:
  - Case sensitivity (`'A'` and `'a'` are the same).
  - Repetition of characters.
- The result is stored in a variable called `COMMON`.

### 4. Procedure: Encrypt Strings
- Encrypts a string by inverting all bits of each character's ASCII code:
  - Example: `'A'` (`01000001`) becomes `10111110`.
- Stores encrypted results in `ENCRYPT1` and `ENCRYPT2`.
- Reapplying the procedure decrypts the strings to verify correctness.

---
