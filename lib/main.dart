import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:transitease_app/api/firebase_api.dart';
import 'package:transitease_app/providers/event_provider.dart';
import 'package:transitease_app/providers/user_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transitease_app/providers/notifcation_provider.dart';
import 'package:transitease_app/utils/colors.dart';
import 'package:transitease_app/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transitease_app/providers/category_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 
  FirebaseMessaging.instance.subscribeToTopic('all');
  await FirebaseApi().requestNotificationPermissions();
  await FirebaseApi().getFCMToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: backgroundColor,
          statusBarIconBrightness: Brightness.dark),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primarySwatch: primarySwatch,
        textTheme: TextTheme(
          bodySmall: GoogleFonts.lato(
              color: textColor, fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium: GoogleFonts.lato(
              color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
          titleLarge: GoogleFonts.lato(
              color: headingColor, fontSize: 18, fontWeight: FontWeight.w500),
          headlineLarge: GoogleFonts.lato(
              color: textColor, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}
