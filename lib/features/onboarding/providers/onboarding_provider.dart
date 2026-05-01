// lib/features/onboarding/providers/onboarding_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/preferences_service.dart';

final preferencesServiceProvider =
    FutureProvider<PreferencesService>((ref) async {
  return PreferencesService.create();
});

final userNameProvider = StateProvider<String?>((ref) {
  return ref.watch(preferencesServiceProvider).valueOrNull?.userName;
});

final isOnboardingDoneProvider = StateProvider<bool>((ref) {
  return ref.watch(preferencesServiceProvider).valueOrNull?.isOnboardingDone ?? false;
});
