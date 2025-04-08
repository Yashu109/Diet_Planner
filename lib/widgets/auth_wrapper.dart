import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_survices.dart';

class AuthWrapper extends StatelessWidget {
  final Widget authenticatedChild;
  final Widget unauthenticatedChild;

  const AuthWrapper({
    super.key,
    required this.authenticatedChild,
    required this.unauthenticatedChild,
  });

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthService>().isLoggedIn;
    return isLoggedIn ? authenticatedChild : unauthenticatedChild;
  }
}
