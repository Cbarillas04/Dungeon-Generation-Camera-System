# Dungeon-Generation-Camera-System
Procedural dungeon generation system with branching room logic and a lock-on camera built in Roblox.

## Demo
https://www.youtube.com/watch?v=hcyz6Wvk41I

## Features
- Procedural room generation with branching paths
- Randomized room expansion with constraints
- Special room types (e.g., item, boss)
- Dynamic lock-on camera system
- Target and Player detection

## How It Works

### Procedural Generation
The dungeon starts from a single node and expands outward using a branching system. Each room spawns with 2–4 new connection points or becomes a special room type (no extra expansion points). Generation continues until a set limit is reached, producing a unique layout each run. Once complete, open nodes means there is no connection and a wall will be generated there. Closed nodes means there is a room to room connection and a doorway will generate instead.

### Camera System
The system scans nearby humanoid root parts within a defined range and selects the closest valid target. Players can toggle lock-on to focus the camera on the selected target. System avoids other player humanoid parts.
The camera switches to a script-controlled mode when locked on, smoothly following and orienting toward the target. It dynamically adjusts position based on distance and handles wall collisions to prevent clipping.

## Tech Stack
- Roblox Studio
- Lua

## Challenges
- Handling camera collision to prevent clipping through walls
- Managing dynamic target selection in a 3D space
