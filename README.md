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
1. **Prerequisites**: Ensure you have Flutter installed (tested on Flutter 3.x).
2. **Clone & Setup**:
   ```bash
   git clone https://github.com/kovid2580-blip/task-manager.git
   cd task-manager
   flutter pub get
   ```
3. **Generate Hive Adapters**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Run the App**:
   ```bash
   flutter run -d chrome  # For Web
   flutter run            # For Mobile/Desktop
   ```

## AI Usage Report
- **Tool Used**: **Antigravity** (Advanced Agentic Coding AI by Google DeepMind).
- **Process**: 
  - **Architecture Design**: Iteratively designed the project using Clean Architecture, Riverpod for reactive state management, and Hive for high-performance localized persistence.
  - **UI/UX Craftsmanship**: Hand-implemented dual themes (Modern & Pixel) with advanced animations (Sun/Moon toggle, custom Retro switch).
  - **Environment Orchestration**: Automatically detected and initialized the local Flutter SDK when it was missing from the host path.
  - **Version Conflict Resolution**: Manually resolved dependency versioning issues in `pubspec.yaml` to ensure build stability with Hive and Riverpod.
- **Workflow**: The AI acted as a lead developer, collaborating with the user to refine design tokens, implement core logic, and handle full GitHub deployment.

## Stretch Goals
- **Pixel Mode**: A fully functional retro terminal theme layer as an optional "Pixel Mode" with a unique font (`Press Start 2P`) and neon aesthetics.
- **Custom Hardware Toggles**: Two high-fidelity custom widgets (`RetroToggle` and `ThemeToggle`) designed to provide a tactile, premium UI experience.
- **Task Editing**: Enhanced CRUD capabilities with a pre-populated editing flow and draft persistence.


![image alt](https://github.com/kovid2580-blip/task-manager/blob/1ffe05b7e5a1d0a6c96af0c26d95ad09a5a17e7c/Screenshot%202026-03-28%20114600.png)
![image alt](https://github.com/kovid2580-blip/task-manager/blob/63a28aeed739c7c8771fe3bf1f3d1efe00cf8866/Screenshot%202026-03-28%20114608.pnghttps://github.com/kovid2580-blip/task-manager/blob/63a28aeed739c7c8771fe3bf1f3d1efe00cf8866/Screenshot%202026-03-28%20132947.pnghttps://github.com/kovid2580-blip/task-manager/blob/63a28aeed739c7c8771fe3bf1f3d1efe00cf8866/Screenshot%202026-03-28%20133003.pnghttps://github.com/kovid2580-blip/task-manager/blob/63a28aeed739c7c8771fe3bf1f3d1efe00cf8866/Screenshot%202026-03-28%20133018.png)
