import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/regesyer_screen.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/user_main_screen.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/signin_screen.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/eregesyer_screen.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/esignin_screen.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/welcome_screen.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/ewecome_screen.dart';
import 'package:mang_mu/screens/mainscren.dart';
import 'package:mang_mu/screens/splash_screen.dart';


import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة Supabase بدلاً من Firebase
  await Supabase.initialize(
    url: 'https://xuwxgjiewdlzzpgzvpxb.supabase.co', // استبدل برابط مشروعك
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1d3hnamlld2RsenpwZ3p2cHhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4Mzc5MTIsImV4cCI6MjA3MjQxMzkxMn0.i1CD1NxOM7XDoViqSmyb4ECT7uKZFJPFbzjorscInRY', // استبدل بالمفتاح الخاص بك
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'بلدية المدينة',
            debugShowCheckedModeBanner: false,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              primarySwatch: Colors.green,
              fontFamily: 'Tajawal',
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                titleTextStyle: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.green,
              fontFamily: 'Tajawal',
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                titleTextStyle: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.grey[900],
              cardColor: Colors.grey[800],
              dialogBackgroundColor: Colors.grey[800],
            ),
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            initialRoute: SplashScreen.screenRoute,
            routes: {
              SplashScreen.screenRoute: (context) => const SplashScreen(),
              Mainscren.screenroot: (context) => const Mainscren(),
              WecomeScreen.screenroot: (context) => const WecomeScreen(),
              EwecomeScreen.screenroot: (context) => const EwecomeScreen(),
              SigninScreen.screenroot: (context) => const SigninScreen(),
              UserMainScreen.screenRoot: (context) => const UserMainScreen(),
              RegesyerScreen.screenRoot: (context) => const RegesyerScreen(),
              EsigninScreen.screenroot: (context) => const EsigninScreen(),
              EregesyerScreen.screenroot: (context) => const EregesyerScreen(),
              
            },
          );
        },
      ),
    );
  }
}
