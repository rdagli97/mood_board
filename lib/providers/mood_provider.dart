import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_board/models/mood.dart';
import 'package:mood_board/providers/auth_provider.dart';
import 'package:mood_board/services/mood_service.dart';

class MoodState {
  final bool isSubmitting;
  final String? errorMessage;

  MoodState({this.isSubmitting = false, this.errorMessage});
}

class MoodController extends Notifier<MoodState> {
  @override
  MoodState build() {
    return MoodState();
  }

  Future<bool> addMood(String emoji, String note) async {
    // get email of auth user
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) {
      state = MoodState(errorMessage: 'You must logged in');
      return false;
    }

    state = MoodState(isSubmitting: true);
    try {
      final mood = Mood(
        id: '',
        emoji: emoji,
        note: note,
        userEmail: user.email ?? 'unknown',
        createdAt: DateTime.now(),
      );
      await ref.read(moodServiceProvider).addMood(mood);
      state = MoodState();
      return true;
    } catch (e) {
      state = MoodState(errorMessage: 'Failed to share mood');
      return false;
    }
  }
}

final moodControllerProvider = NotifierProvider<MoodController, MoodState>(() {
  return MoodController();
});

// access to mood service
final moodServiceProvider = Provider<MoodService>((ref) {
  return MoodService();
});
