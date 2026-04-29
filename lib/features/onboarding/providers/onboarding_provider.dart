// lib/features/onboarding/providers/onboarding_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/preferences_service.dart';

final preferencesServiceProvider =
    FutureProvider<PreferencesService>((ref) async {
  return PreferencesService.create();
});

final userNameProvider = Provider<String?>((ref) {
  return ref.watch(preferencesServiceProvider).maybeWhen(
        data: (prefs) => prefs.userName,
        orElse: () => null,
      );
});

final isOnboardingDoneProvider = Provider<bool>((ref) {
  return ref.watch(preferencesServiceProvider).maybeWhen(
        data: (prefs) => prefs.isOnboardingDone,
        orElse: () => false,
      );
});
