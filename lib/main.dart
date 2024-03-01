import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        ColorScheme,
        Colors,
        FocusManager,
        GestureDetector,
        MaterialApp,
        MediaQuery,
        StatelessWidget,
        ThemeData,
        Widget,
        runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather/api/repository/weather_repository.dart';
import 'package:weather/screens/home_page.dart';
import 'package:weather/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

var h;
var w;
var currentLocation;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Weather Watch',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
