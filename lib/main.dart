import 'package:cloud_contact/res/colors.dart';
import 'package:cloud_contact/view_model/auth_viwew_model.dart';
import 'package:cloud_contact/view_model/contact_view_model.dart';
import 'package:cloud_contact/views/main/input_contact.dart';
import 'package:cloud_contact/views/main/home_screen.dart';
import 'package:cloud_contact/views/utility/auth_screen.dart';
import 'package:cloud_contact/views/utility/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: ContactViewModel(),
        ),
      ],
      child: Consumer<AuthViewModel>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cloud Contact',
          theme: ThemeData(
              scaffoldBackgroundColor: lightBackgroundColor,
              colorScheme: const ColorScheme.light(
                brightness: Brightness.light,
                background: lightBackgroundColor,
                primary: primaryColor,
                onPrimary: textColor,
                secondary: Colors.amberAccent,
                onSecondary: textColor,
              ),
              appBarTheme: AppBarTheme.of(context).copyWith(
                centerTitle: true,
                elevation: 0,
                foregroundColor: primaryBackgroundColor,
                backgroundColor: lightBackgroundColor,
                iconTheme: const IconThemeData(color: primaryBackgroundColor),
                toolbarTextStyle: const TextStyle(
                  color: primaryBackgroundColor,
                  fontSize: 22,
                ),
              )
              //primarySwatch: Colors.blue,
              ),
          home: auth.isAuth
              ? const HomeScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {InputContact.routName: (ctx) => const InputContact()},
        ),
      ),
    );
  }
}
