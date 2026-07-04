import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_board/providers/mood_provider.dart';

class AddMoodDialog extends ConsumerStatefulWidget {
  const AddMoodDialog({super.key});

  @override
  ConsumerState<AddMoodDialog> createState() => _AddMoodDialogState();
}

class _AddMoodDialogState extends ConsumerState<AddMoodDialog> {
  final TextEditingController _noteController = TextEditingController();
  String _selectEmoji = '😊';

  final List<String> _emojis = ['😊', '😢', '😡', '😴', '🤩', '😰', '🥳', '😐', '🎉', '💃', '💀'];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final note = _noteController.text.trim();
    if(note.isEmpty) return;

    final success = await ref
        .read(moodControllerProvider.notifier)
        .addMood(_selectEmoji, note);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodState = ref.watch(moodControllerProvider);

    return AlertDialog(
      title: const Text('Share your mood'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // picking emoji
          Wrap(
            spacing: 8,
            children: _emojis.map((emoji) {
              final isSelected = emoji == _selectEmoji;
              return GestureDetector(
                onTap: () => setState(() => _selectEmoji = emoji),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurple.withValues(alpha: 0.2)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: "What's on your mind?",
            ),
          ),
          if (moodState.errorMessage != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                moodState.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        moodState.isSubmitting
            ? const Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
            : TextButton(
              onPressed: _submit,
              child: const Text('Share'),
            ),
      ],
    );
  }
}