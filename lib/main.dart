import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/controller/cart_controller.dart';
import 'package:footwear_client/controller/login_controller.dart';
import 'package:footwear_client/pages/start_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controller/home_controller.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';


Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
