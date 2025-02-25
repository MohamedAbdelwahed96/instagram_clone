import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/logic/chat_provider.dart';
import 'package:instagram_clone/presentation/screens/splash_screen.dart';
import 'package:instagram_clone/services/notification.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme.dart';
import 'firebase_options.dart';
import 'logic/media_provider.dart';
import 'logic/user_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService.instance.initialize();
  await Supabase.initialize(
    url: "https://kwrtcgnmxmdfffqffkin.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3cnRjZ25teG1kZmZmcWZma2luIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5MDAxODUsImV4cCI6MjA1MzQ3NjE4NX0.lwcWfz2YaVs7BxClu0mQM9cA-CZgnCAXqHL0-TZCKZc",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MediaProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider())
      ],
      child: EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: Locale('en'),
          child: MyApp()),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider.of<UserProvider>(context, listen: false).getUserInfo();
    return MaterialApp(
        title: 'Instagram',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: SplashScreen()
        );
  }
}
