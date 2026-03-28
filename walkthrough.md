# Flutter Task Manager Walkthrough

I have successfully completed the premium Flutter Task Management application, including the custom Sun/Moon theme toggle as requested.

## Key Features Implemented

### 1. Advanced Custom UI System
- **Modern Mode**: Sleek dark-themed dashboard featuring a custom **PRO GRADIENT SYSTEM** (3-layer orange-to-black fade, radial glow overlay, and soft depth shadows).
- **Pixel Mode**: Retro terminal-inspired interface with neon green accents and sharp elements.
- **Sun/Moon Theme Toggle**: A custom-designed, animating toggle switch that transforms between a glowing Sun (Modern) and a neon-lit Moon (Retro).
- **Retro Switch**: A handcrafted, high-fidelity physical toggle switch in the Pixel header with a red status light and metallic sliding animations.

### 2. Task Management Logic
- **Full CRUD Operations**: Complete task lifecycle management, now including a dedicated **Edit Task** flow with pre-populated fields.
- **Task Dependencies**: "Blocked By" logic that visually dims and locks tasks until dependencies are solved.
- **Search & Filter**: Real-time filtering by title or status.

### 3. Advanced UX Behaviors
- **Draft Persistence**: Auto-saves and restores form inputs even after the app is minimized.
- **Simulated Delay**: 2-second async delay on task operations with custom mode-specific loading states.
- **Local Persistence**: Powered by Hive for instantaneous data retrieval and storage.

## Project Structure

- `lib/models/`: [task_model.dart](file:///c:/GIT%20HUB/flutter%20task%20manager/lib/models/task_model.dart)
- `lib/services/`: [local_db_service.dart](file:///c:/GIT%20HUB/flutter%20task%20manager/lib/services/local_db_service.dart)
- `lib/providers/`: [task_provider.dart](file:///c:/GIT%20HUB/flutter%20task%20manager/lib/providers/task_provider.dart)
- `lib/screens/`: [dashboard_screen.dart](file:///c:/GIT%20HUB/flutter%20task%20manager/lib/screens/dashboard_screen.dart), [task_form_screen.dart](file:///c:/GIT%20HUB/flutter%20task%20manager/lib/screens/task_form_screen.dart)
- `lib/widgets/`: [theme_toggle.dart](file:///c:/GIT%20HUB/flutter%20task%20manager/lib/widgets/theme_toggle.dart), [retro_toggle.dart](file:///c:/GIT%20HUB/flutter%20task%20manager/lib/widgets/retro_toggle.dart), etc.

## How to Run
1. Ensure dependencies are fetched: `flutter pub get`
2. Run on your preferred platform: `flutter run`
   - To run in Chrome: `flutter run -d chrome`
