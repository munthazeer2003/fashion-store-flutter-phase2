# Contributing to MFashion Store

Thank you for contributing to this project.

## Project Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/munthazeer2003/fashion-store-flutter-phase2.git
   ```
2. Enter the project folder:
   ```bash
   cd fashion-store-flutter-phase2
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Branch Naming Convention

Use the following naming pattern for feature work:

- `feature/your-feature-name`

Examples:
- `feature/cart-quantity-controls`
- `feature/profile-edit-validation`

## Commit Message Format

Write clear, concise commit messages in imperative form.

Recommended format:

- `<type>: <short description>`

Common types:
- `feat`: new feature
- `fix`: bug fix
- `docs`: documentation changes
- `refactor`: code restructuring without behavior change
- `chore`: tooling or maintenance changes

Examples:
- `feat: add order history empty state`
- `fix: prevent null crash in checkout screen`
- `docs: update Firebase setup steps`

## Pull Request Guidelines

Before opening a PR:

1. Rebase or update your branch with the latest `main`.
2. Ensure the app runs without errors on Android emulator/device.
3. Keep PRs focused on one feature/fix.
4. Include screenshots for UI changes.
5. Reference related issues when applicable.
6. Provide a clear PR description with:
   - What changed
   - Why it changed
   - How it was tested

## Flutter/Dart Code Style Notes

- Follow `flutter_lints` and analyzer rules in this repository.
- Use meaningful class, variable, and method names.
- Keep widgets small and reusable.
- Prefer `const` constructors where possible.
- Avoid unused imports and dead code.
- Preserve MVVM separation:
  - `view_models/` for state and logic
  - `screens/` and widgets for UI
  - `services/` for data access and Firebase operations
