import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const DashboardScreen();
        }
        return const LoginPage();
      },
    );
  }
}

