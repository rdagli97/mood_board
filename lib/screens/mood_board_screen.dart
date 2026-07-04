import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_board/providers/auth_provider.dart';
import 'package:mood_board/providers/mood_provider.dart';
import 'package:mood_board/widgets/add_mood_dialog.dart';

class MoodBoardScreen extends ConsumerWidget {
  const MoodBoardScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodsAsync = ref.watch(moodsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: moodsAsync.when(
        data: (moods) {
          if (moods.isEmpty) {
            return const Center(child: Text('No moods yet. Be the first'));
          }
          return ListView.builder(
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              return ListTile(
                leading: Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(mood.note),
                subtitle: Text(mood.userEmail),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddMoodDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}