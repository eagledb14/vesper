# Space Simulator in V

This is a space simulation written in the V programming language. It models gravitational interactions, collisions, and orbiting bodies, providing a visual and interactive simulation of planetary systems.

## Features

- **Realistic Physics**: Implements gravitational force and collision detection between celestial bodies.
- **Orbiting Bodies**: Simulates planets orbiting a central body and other complex orbital interactions.
- **Interactive Camera**: Pan and zoom around the simulation space using keyboard and mouse controls.
- **Dynamic Movables**: Observe the trajectories of various moving objects like rockets and asteroids.

## Requirements

- [V Compiler](https://vlang.io/) (ensure you have V installed on your system)

## Running the Simulator

1. Clone or download this repository.
2. Navigate to the directory containing the code.
3. Run the simulation with the following command:
   ```sh
   v run .

## Controls

### Camera
- **W/A/S/D**: Move the camera up, left, down, and right.
- **Scroll Wheel**: Zoom in/out.

### Object Interaction
- **Left Arrow**: Select the previous object.
- **Right Arrow**: Select the next object.
- **Space**: Toggle following the selected object.
- **1**: Reset camera to origin.

### Other
- **Right Mouse Button + Drag**: Pan the camera.
