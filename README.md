# ADÖRE

**ADÖRE** is a helper library for [LÖVE2D](https://love2d.org/) designed to make common game development tasks faster and cleaner.  
It provides built-in systems for:

- **Easy Drawing** – Manage and render sprites with automatic Y sorting.
- **UI Handling** – Simple UI elements with anchors and resizing support.
- **Tile Management** – Define, place, and update tiles (including animated or state-based tiles like flowers).
- **Utility Functions** – Common helpers for sprite loading, string formatting, and more.

---

## ✨ Features

- **Sprite Management** – Automatic sprite registration from your `sprites/` directory.
- **UI Anchors** – UI elements stay positioned correctly when the window resizes.
- **Tile Systems** – Easily define tile lookups, populate maps, and attach behavior to tiles.
- **Camera Layering** – Draw game objects and UI separately with camera attach/detach.
- **Object Creation** – Spawn drawable objects in a single call.
- **Stateful Tiles** – Example: flowers that change appearance over time.
- **Performance-Friendly Drawing** – Automatic culling for off-screen objects.

---

## 📦 Installation

1. Copy `adörelib` folder into the root of your LÖVE2D project.
2. Require the library in your main.lua and add necessary calls in love functions `main.lua`:
   ```lua
   local adore = require("adörelib/adore")
   
   function love.load()
     adore:load()
   end
    
   function love.update(dt)
     adore:update(dt)
   end
    
   function love.draw()
      adore:draw()
   end
