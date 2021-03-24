import 'package:ebook_app/login_signup/main_screens/LoginPage.dart';
import 'package:ebook_app/login_signup/main_screens/RegisterPage.dart';
import 'package:ebook_app/login_signup/results_screen/ForgotPassword.dart';
import 'package:ebook_app/theme/theme_notifier.dart';
import 'package:ebook_app/theme/theme_controller.dart';
import 'package:ebook_app/theme/themes.dart';
import 'package:ebook_app/util/constants.dart';
import 'package:ebook_app/view_models/app_provider.dart';
import 'package:ebook_app/view_models/details_provider.dart';
import 'package:ebook_app/view_models/favorites_provider.dart';
import 'package:ebook_app/view_models/genre_provider.dart';
import 'package:ebook_app/view_models/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_signup/results_screen/Done.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => DetailsProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => GenreProvider()),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          return ChangeNotifierProvider<Settings>.value(
            value: Settings(snapshot.data),
            child: Consumer<AppProvider>(
              builder: (BuildContext context, AppProvider appProvider,
                  Widget child) {
                return MaterialApp(
                  key: appProvider.key,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: appProvider.navigatorKey,
                  title: Constants.appName,
                  theme: Provider.of<Settings>(context).isDarkMode
                      ? setDarkTheme
                      : setLightTheme,
                  darkTheme: themeData(ThemeConfig.darkTheme),
                  initialRoute: RegisterPage.id,
                  routes: {
                    RegisterPage.id: (context) => RegisterPage(),
                    LoginPage.id: (context) => LoginPage(),
                    ForgotPassword.id: (context) => ForgotPassword(),
                    Done.id: (context) => Done(),
                  },
                );
              },
            ),
          );
        });
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
