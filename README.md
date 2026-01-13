# Ghost Input - 3D Touch Quick Note

Ghost Input demonstrates iOS Quick Actions (3D Touch or Haptic Touch) to open a quick note panel from the app icon.

## How to use (3D Touch / Haptic Touch)
1. Build and run the app on a device.
2. Go back to the Home Screen.
3. Press the app icon (3D Touch or long-press) until the Quick Actions menu appears.
4. Tap "Quick Note".
5. The quick note sheet opens; type and tap Save.

## What happens in code
- The "Quick Note" Quick Action is registered in `AppDelegate` via `UIApplicationShortcutItem`.
- When selected, the router navigates to `GhostInputView`.
- Notes are persisted with `@AppStorage("quick_note")`.

## Sample screenshot
- Add a screenshot at `docs/quick-actions.png`.
- Example: Home Screen Quick Actions menu showing "Quick Note".

## Troubleshooting Quick Actions
- If the menu does not appear, make sure you are running on a real device (Quick Actions do not show on the simulator).
- If the action does not show, relaunch the app after installing so `UIApplication.shared.shortcutItems` is set.
- If the action shows but does nothing, confirm `AppDelegate` is wired via `@UIApplicationDelegateAdaptor` in `ghost_inputApp.swift`.
- If the route does not present the sheet, check that `router.route` is set on the main thread.

## Notes
- Older devices support 3D Touch; newer devices use Haptic Touch (long-press), but Quick Actions behave the same.
