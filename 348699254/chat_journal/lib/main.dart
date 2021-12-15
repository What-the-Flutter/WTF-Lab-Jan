import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'pages/main_page/main_page_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(await startApp());
}
