import 'package:flamingo_flutter/database.dart';
import 'package:flamingo_flutter/flashcards_provider.dart';
import 'package:flamingo_flutter/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.seedIfEmpty();
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (context) => database,
          dispose: (context, db) => db.close(),
        ),
        ChangeNotifierProvider<FlashcardsProvider>(
          create: (context) =>
              FlashcardsProvider(context.read<AppDatabase>())..loadWords(),
        ),
      ],
      child: const FlamingoApp(),
    ),
  );
}

class FlamingoApp extends StatelessWidget {
  const FlamingoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flamingo Spanish',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}
