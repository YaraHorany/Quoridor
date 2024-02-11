import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quoridor/helper/dependencies.dart';
import 'package:quoridor/screens/intro_screen.dart';
import 'package:flutter/services.dart';

void main() {
  GameControllerBinding().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quoridor Board Game',
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => IntroScreen(),
          binding: BindingsBuilder(
            () => {
              Get.lazyPut<GameControllerBinding>(() => GameControllerBinding()),
            },
          ),
        ),
      ],
    );
  }
}
