import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/ewecome_screen.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/regesyer_screen.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/user_main_screen.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/signin_screen.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/eregesyer_screen.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/welcome_screen.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/esignin_screen.dart';

import 'package:mang_mu/screens/mainscren.dart';
<<<<<<< HEAD
import 'package:mang_mu/screens/splash_screen.dart';// أضف استيراد شاشة المحاسب
import 'package:mang_mu/screens/employee/employee_electricity/billing_accountant_electrity.dart';
=======
import 'package:mang_mu/screens/splash_screen.dart';
import 'package:mang_mu/language/app_localizations.dart';
// أضف استيراد شاشة المحاسب
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
import 'package:mang_mu/providers/language_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/l10n/app_localizations.dart'; // أضف هذا الاستيراد

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Supabase بدلاً من Firebase
  await Supabase.initialize(
    url: 'https://xuwxgjiewdlzzpgzvpxb.supabase.co',
<<<<<<< HEAD
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1d3hnamlld2RsenpwZ3p2cHhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4Mzc5MTIsImV4cCI6MjA3MjQxMzkxMn0.i1CD1NxOM7XDoViqSmyb4ECT7uKZFJPFbzjorscInRY',
=======
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1d3hnamlld2RsenpwZ3p2cHhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4Mzc5MTIsImV4cCI6MjA3MjQxMzkxMn0.i1CD1NxOM7XDoViqSmyb4ECT7uKZFJPFbzjorscInRY',
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return MaterialApp(
                title: 'بلدية المدينة',
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
<<<<<<< HEAD
                  AppLocalizations.delegate, // أضف هذا
=======
                  AppLocalizations.delegate,
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
<<<<<<< HEAD
                supportedLocales: [
                  Locale('ar', ''),
                  Locale('en', ''),
                ],
                locale: languageProvider.currentLocale,
                theme: ThemeData(
                  primarySwatch: Colors.green,
                  fontFamily: languageProvider.currentLocale.languageCode == 'ar' 
                      ? 'Tajawal' 
                      : 'Roboto', // خط مختلف للغة الإنجليزية
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                    titleTextStyle: TextStyle(
                      fontFamily: languageProvider.currentLocale.languageCode == 'ar' 
                          ? 'Tajawal' 
                          : 'Roboto',
=======
                supportedLocales: [Locale('ar', ''), Locale('en', '')],
                locale: Provider.of<LanguageProvider>(context).currentLocale,
                theme: ThemeData(
                  primarySwatch: Colors.green,
                  fontFamily: 'Tajawal',
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: const AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                    titleTextStyle: TextStyle(
                      fontFamily: 'Tajawal',
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  brightness: Brightness.light,
                ),
                darkTheme: ThemeData(
                  primarySwatch: Colors.green,
<<<<<<< HEAD
                  fontFamily: languageProvider.currentLocale.languageCode == 'ar' 
                      ? 'Tajawal' 
                      : 'Roboto',
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                    titleTextStyle: TextStyle(
                      fontFamily: languageProvider.currentLocale.languageCode == 'ar' 
                          ? 'Tajawal' 
                          : 'Roboto',
=======
                  fontFamily: 'Tajawal',
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: const AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                    titleTextStyle: TextStyle(
                      fontFamily: 'Tajawal',
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Colors.grey[900],
                  cardColor: Colors.grey[800],
<<<<<<< HEAD
                  dialogTheme: DialogThemeData(backgroundColor: Colors.grey[800]),
=======
                  dialogTheme: DialogThemeData(
                    backgroundColor: Colors.grey[800],
                  ),
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
                ),
                themeMode: themeProvider.themeMode,
                initialRoute: SplashScreen.screenRoute,
                routes: {
                  SplashScreen.screenRoute: (context) => const SplashScreen(),
                  Mainscren.screenroot: (context) => const Mainscren(),
                  WecomeScreen.screenroot: (context) => const WecomeScreen(),
<<<<<<< HEAD
                  EwecomeScreen.screenroot: (context) => const EwecomeScreen(),
                  SigninScreen.screenroot: (context) => const SigninScreen(),
                  UserMainScreen.screenRoot: (context) => const UserMainScreen(),
                  RegesyerScreen.screenRoot: (context) => const RegesyerScreen(),
                  EsigninScreen.screenroot: (context) => const EsigninScreen(),
                  EregesyerScreen.screenroot: (context) => const EregesyerScreen(),
                  BillingAccountantScreen.screenRoute: (context) => const BillingAccountantScreen(),
                  NotificationsScreen.routeName: (context) => NotificationsScreen(),
=======
                  SigninScreen.screenroot: (context) => const SigninScreen(),
                  UserMainScreen.screenRoot: (context) =>
                      const UserMainScreen(),
                  RegesyerScreen.screenRoot: (context) =>
                      const RegesyerScreen(),
                  EregesyerScreen.screenroot: (context) =>
                      const EregesyerScreen(),
  EwecomeScreen.screenroot: (context) => const EwecomeScreen(),
                  EsigninScreen.screenroot: (context) => const EsigninScreen(),
       
>>>>>>> 66407ccbc1742c7c1e6d68b46373a3fdaa6532b8
                },
              );
            },
          );
        },
      ),
    );
  }
}