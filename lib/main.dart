import 'package:flutter/material.dart';
import 'package:safe_haven/pages/trusted_contacts.dart';
import 'package:safe_haven/pages/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHaven',
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
