# Error Handling & Debugging Guide

## Overview

This app now has comprehensive error handling to prevent crashes and log all errors for debugging.

## Error Handling Layers

### 1. Global Error Handlers (main.dart)

All uncaught errors are caught at three levels:

1. **FlutterError.onError** - Catches all Flutter framework errors
2. **PlatformDispatcher.instance.onError** - Catches all platform/Dart errors (prevents crashes)
3. **runZonedGuarded** - Catches all async errors

When any of these errors occur:
- Error is logged to console with full stack trace
- Error is cached in SharedPreferences via `ErrorCacheService`
- App continues running (does not crash)

### 2. Game Service Error Isolation (game_service.dart)

Every operation in `_updateUserProgressOnStart()` is isolated with try-catch:

- ISOLATION 1: User authentication check
- ISOLATION 2: Document reference creation
- ISOLATION 3: Document fetch
- ISOLATION 4: Data parsing
- ISOLATION 5: Array extraction
- ISOLATION 6: Existing game check
- ISOLATION 7: Document update (with 4 fallback strategies)
- ISOLATION 8: Document creation

Each isolation level:
- Catches its own errors
- Logs to console with emoji markers
- Caches error via `ErrorCacheService`
- Continues execution or fails gracefully

### 3. Screen-Level Error Handling

Both `truth_or_truth_game.dart` and `love_language_quiz.dart`:
- Wrap initialization in try-catch
- Cache errors with context
- Show user-friendly error messages
- Never crash the app

## Error Cache Service

Location: `lib/services/error_cache_service.dart`

### Features:
- Stores last error with full stack trace
- Maintains error history (last 50 errors)
- Tracks crash count
- Provides diagnostic printing

### Usage:

```dart
// Store an error
await ErrorCacheService().storeError(
  'Something went wrong',
  stackTrace.toString(),
  location: 'MyFunction',
);

// Log a game error
await ErrorCacheService().logGameError(
  gameId: 'love_language_quiz',
  phase: 'initialization',
  error: e.toString(),
  stack: stackTrace.toString(),
);

// Get last error
final lastError = await ErrorCacheService().getLastError();
print(lastError['error']);
print(lastError['stack']);
print(lastError['location']);

// Print diagnostics
await ErrorCacheService().printDiagnostics();

// Clear all errors
await ErrorCacheService().clearErrors();
```

## Debugging Steps

### Step 1: Check Console Logs

Look for these markers:
- `❌ [FATAL FLUTTER ERROR]` - Flutter framework error
- `❌ [FATAL PLATFORM ERROR]` - Platform/Dart error
- `❌ [FATAL ZONE ERROR]` - Async error
- `❌ [GameService]` - Game service error
- `❌ [LoveLanguageQuiz]` - Love Language Quiz error
- `❌ [TruthOrTruth]` - Truth or Truth error

### Step 2: Check Cached Errors

Add this to your code temporarily:

```dart
// In initState() or anywhere
ErrorCacheService().printDiagnostics();
```

Or retrieve individual errors:

```dart
final error = await ErrorCacheService().getLastError();
print('Error: ${error['error']}');
print('Location: ${error['location']}');
print('Stack: ${error['stack']}');
```

### Step 3: Check Error History

```dart
final history = await ErrorCacheService().getErrorHistory();
for (final entry in history) {
  print(entry);
}
```

### Step 4: Check Crash Count

```dart
final count = await ErrorCacheService().getCrashCount();
print('Total crashes: $count');
```

## Console Log Legend

| Emoji | Meaning |
|-------|---------|
| 🎮 | Game operation |
| 🔍 | Data lookup |
| ✅ | Success |
| ❌ | Error |
| ⚠️ | Warning |
| 💾 | Storage operation |
| 📦 | Data processing |

## Error Locations

| Location | Description |
|----------|-------------|
| `auth_check` | User authentication |
| `doc_reference` | Firestore document reference |
| `fetch_doc` | Firestore fetch |
| `parse_data` | Data parsing |
| `extract_playedGames` | Array extraction |
| `check_existing` | Game existence check |
| `update_sessions` | Sessions update |
| `update_both_fields` | Both fields update |
| `update_playedGames_only` | PlayedGames only update |
| `nuclear_fallback` | Last resort set with merge |
| `create_doc` | Document creation |
| `start_session` | Game session start |
| `initialization` | Screen initialization |

## Fallback Strategies

The `_safeUpdatePlayedGamesAndSessions` method has 4 fallback strategies:

1. **Strategy 1**: Update both `playedGames` and `sessions` arrays
2. **Strategy 2**: Update `sessions` only
3. **Strategy 3**: Update `playedGames` only
4. **Strategy 4 (Nuclear)**: Use `set()` with `merge: true`

Each strategy is tried in order. If one fails, the next is attempted.

## Testing Error Handling

To verify error handling works:

1. Turn off network
2. Open a game
3. Check console for error logs
4. Verify app doesn't crash
5. Run `ErrorCacheService().printDiagnostics()` to see cached error

## Files Modified

1. `lib/main.dart` - Global error handlers
2. `lib/services/game_service.dart` - Isolated error handling
3. `lib/services/error_cache_service.dart` - Error caching (NEW)
4. `lib/screens/game/truth_or_truth_game.dart` - Screen-level error handling
5. `lib/screens/game/love_language_quiz.dart` - Screen-level error handling

## Quick Reference

```dart
// Import
import 'package:velmora/services/error_cache_service.dart';

// Log error
await ErrorCacheService().storeError(error, stack, location: 'MyLocation');

// View diagnostics
await ErrorCacheService().printDiagnostics();

// Clear errors
await ErrorCacheService().clearErrors();
```

## Support

If you encounter any errors:
1. Check console logs for the error message
2. Run `ErrorCacheService().printDiagnostics()`
3. Copy the error and stack trace
4. Look for the location field to identify where it happened
