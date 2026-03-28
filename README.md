# Flodo AI Task Management App

A functional, visually polished Task Management Flutter app built for the Flodo AI Take-Home Assignment.

## Selected Track
**Track B: The Mobile Specialist**
- **Frontend**: Flutter & Dart
- **Storage**: Hive (Local Persistence)
- **UI/UX**: Custom Modern Dark and Retro Pixel themes.

## Features
- **CRUD Operations**: Full support for task lifecycle management.
- **Task Dependencies**: Visually distinct blocked tasks with dependency logic.
- **Draft Persistence**: Auto-saves form input even when the app is minimized.
- **Search & Filter**: Real-time filtering by title and status.
- **Simulated Delay**: 2-second async delay for creation and updates with loading states.
- **Dual Themes**: Toggle between a premium Modern Dark theme and a nostalgic Pixel Retro theme.

## Setup Instructions
1. **Prerequisites**: Ensure you have Flutter installed. (Note: Project was built using Flutter 3.x).
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Generate Hive Adapters**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Run the App**:
   ```bash
   flutter run
   ```

## AI Usage Report
- **Tool Used**: Antigravity (Advanced Agentic Coding AI).
- **Process**: 
  - Iteratively designed the architecture using Riverpod and Hive.
  - Automatically resolved SDK availability issues on the host system.
  - Fixed dependency version conflicts manually in `pubspec.yaml` after initial automated failures.
- **Helpful Prompts**: "Build a Flutter Task Management mobile application using Dart with a modern dark-themed dashboard UI and clean architecture..." (full requirements provided by user).

## Stretch Goals
- **Pixel Mode**: Implemented a fully functional retro terminal theme layer as an optional "Pixel Mode" to showcase design creativity and UI flexibility.
