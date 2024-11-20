
import 'dart:ui';

import 'package:clonephone/common/constants.dart';
import 'package:clonephone/common/providers.dart';
import 'package:clonephone/ui/main_screem/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  final sharedPrefs = await SharedPreferences.getInstance();

 runApp(ProviderScope(
   overrides: [
     sharedPrefProvider.overrideWithValue(sharedPrefs),
   ],
     child: const MyApp()
 ));
}
class CustomScrollBehavior extends MaterialScrollBehavior{
  @override
  Set<PointerDeviceKind> get dragDevices =>{
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad
  };
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() =>_MyAppState();
}

class _MyAppState extends State<MyApp>{

  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected =ColorSelection.orange;


  late final _router = GoRouter(
    initialLocation: '/:tab',
    routes: [
      GoRoute(
          path: '/:tab',
        builder: (context,state) {
          return  const Home(
           //  tab:int.tryParse(
             // state.pathParameters['tab']  ?? '')??1,

          );

        }
      ),

    ],
    errorPageBuilder: (context,state){
      return MaterialPage(
        key:state.pageKey,
          child: Scaffold(
            body: Center(
              child: Text(
                state.error.toString(),
                style: const TextStyle(
                  fontSize: 18.0
                ),
              ),
            ),
          ),
      );
    }
  );

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      scrollBehavior: CustomScrollBehavior(),
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
    );
  }
}