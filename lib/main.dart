import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giphy_get/l10n.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/pages/splash_page.dart';
import 'package:we_chat_app/pages/test_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ///for status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Set your desired status bar color here
  ));
  runApp(const MyApp());

  // runApp(MultiProvider(providers: [
  //   ChangeNotifierProvider(
  //       create: (ctx) => ThemeProvider(currentTheme: ThemeMode.system))
  // ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      localizationsDelegates: [
        // Default Delegates
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        // Add this line
        GiphyGetUILocalizations.delegate
      ],
      supportedLocales: [
        // Your supported languages
        Locale('en', ''),
        Locale('es', ''),
        Locale('da', ''),
      ],
     // themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}

