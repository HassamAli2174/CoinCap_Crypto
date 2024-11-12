import 'dart:convert';

import 'package:coincap/models/app_config.dart';
import 'package:coincap/pages/home_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPservice();
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  // Load your configuration settings here
  String configContent = await rootBundle.loadString('assets/config/main.json');
  Map configData = jsonDecode(configContent);
  // print(_configData);
  GetIt.instance.registerSingleton<AppConfiguration>(
    AppConfiguration(
      COIN_API_BASE_URL: configData["COIN_API_BASE_URL"],
    ),
  );
}

void registerHTTPservice() {
  // Register your HTTP service here
  GetIt.instance.registerSingleton<HTTPService>(HTTPService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CoinCap',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}
