import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/services/storage_service.dart';

void main() async {
  // Initialize services here if needed:
  // await initServices();
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}
