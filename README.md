# Godot Pong

A simple two-player Pong game made with Godot as a learning project.

This is my first Godot project, created to learn the fundamentals of the engine and experiment with basic gameplay programming and game feel.

## Play

The game is playable directly in your browser on itch.io:

**https://gladorf.itch.io/godot-pong**

## Controls

- **Left player:** Z / S on AZERTY keyboards  
  (W / S physical key positions)
- **Right player:** Up / Down arrows

## Gameplay

- Local two-player Pong
- First player to reach **5 points** wins
- Short pause after each point
- Progressive ball speed during rallies
- Maximum rebound angle to prevent near-vertical trajectories
- Custom rebound behavior:
  - Nearly horizontal trajectories can gain a new vertical direction depending on where the paddle is hit
  - Already angled trajectories mostly preserve their vertical direction
  - Hits near the paddle edges have a stronger effect on the trajectory

## Technical features

- Reusable paddle scene
- `CharacterBody2D` based movement and collisions
- Godot Input Map for player controls
- Signals used to communicate scoring events between the ball and the game
- Separate game logic for score and win conditions
- Web export for browser play

## What I learned

This project was mainly an introduction to Godot after several years without using a game engine.

It allowed me to practice:

- Godot scenes and node hierarchy
- GDScript
- Physics processing
- `CharacterBody2D` movement and collision handling
- Signals
- Input actions
- Managing score, win conditions, and ball reset states
- Iterating on game feel through rebound angles and ball speed
- Exporting a Godot project for the Web and publishing it on itch.io

## Built with

- Godot 4
- GDScript

## Status

The game is playable and published.

This project is intentionally small and focused on learning the fundamentals before moving on to more complex gameplay projects.

