//Commit #1 in branch : akr-branch

import 'package:memeapp/providers/cart_counter_provider.dart';
import 'package:memeapp/providers/meme_cart_provider.dart';
import 'package:memeapp/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MemeCartProvider()),
          ChangeNotifierProvider(create: (_) => CartCounterProvider())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                fontFamily: 'SpaceMono',
                useMaterial3: true,
                colorSchemeSeed: const Color(0xff323030)),
            home: const SplashScreen()));
  }
}
