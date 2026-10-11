import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moth_hop/app.dart';
import 'package:moth_hop/core/progress/progress_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressStore.instance.init();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const App());
}
