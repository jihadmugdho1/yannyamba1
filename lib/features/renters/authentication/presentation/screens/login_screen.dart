import 'package:flutter/material.dart';

import '../../controllers/authentication_controller.dart';
import '../widgets/authentication_widget.dart';

class AuthenticationLoginScreen extends StatelessWidget {
  const AuthenticationLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthenticationScreen(initialMode: AuthMode.login);
  }
}
