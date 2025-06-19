# ColorMaster - Color Recognition Game

**ColorMaster** is a fun and challenging color recognition game built with LÖVE (Love2D) engine. Test your ability to **identify colors** by guessing their hexadecimal values!

## Game Overview

In **ColorMaster**, you'll see a randomly generated color in the center of the screen. Your task is to input the hexadecimal value that matches this color as closely as possible. The game will then show you the correct answer and score your guess based on color similarity.

## Features

- 🎨 Randomly generated colors each round
- 📝 Hex value input with validation
- ✅ Automatic correction for missing "#" prefix
- 📊 Color similarity scoring (0-100%)
- 💯 Performance-based color-coded feedback
- 🔄 Multi-round gameplay with score tracking
- ⌨️ Mouse and keyboard controls

## How to Play

1. Observe the color displayed in the center of the screen
2. Enter the hexadecimal value in the input box (e.g., "#FFCC00" or "#FC0")
3. Submit your guess by:
   - Clicking the "SUBMIT" button
   - Pressing the Enter key
4. View your similarity score and the correct answer
5. Press SPACE to start a new round
6. Press ESC at any time to quit the game

## Scoring System

Your guess is scored based on how closely it matches the actual color (using HSV color system):

- 85%: Green (Excellent)
- 70-85%: Yellow (Good)
- 50-70%: Orange (Fair)
- <50%: Red (Needs practice)

## Controls

- **Mouse**: Click to activate input field or press buttons
- Keyboard:
  - Type hex values (0-9, A-F, a-f, #)
  - ENTER: Submit guess
  - SPACE: Start new round
  - ESC: Quit game
  - BACKSPACE: Delete last character

## Technical Details

- Built with Lua and Love2D
- Color similarity calculated using RGB difference algorithm
- Real-time cursor animation for input field
- Responsive UI design for 800x600 resolution

Developed with LÖVE. Challenge your color perception skills and see how high you can score!