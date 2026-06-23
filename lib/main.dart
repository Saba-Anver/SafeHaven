import 'package:flutter/material.dart';
import 'package:safe_haven/pages/trusted_contacts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHaven',
      home: TrustedContacts(),
      debugShowCheckedModeBanner: false,
    );
  }
}
