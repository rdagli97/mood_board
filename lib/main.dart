import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_board/firebase_options.dart';
import 'package:mood_board/providers/auth_provider.dart';
import 'package:mood_board/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Board',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const AuthScreen();
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Mood Board'),),
          body: Center(child: Text('Welcome, ${user.email}'),),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err'),),
      ),
    );
  }
}