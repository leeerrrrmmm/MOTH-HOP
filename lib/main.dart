import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moth_hop/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const App());
}
