import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_mode_controller.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/auth_gate_page.dart';
import '../firebase_options.dart';

class AskIslamAdminApp extends StatelessWidget {
  const AskIslamAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          repository: context.read<AuthRepository>(),
        )..add(const AuthSubscriptionRequested()),
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: AppThemeController.mode,
          builder: (context, mode, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ASK Islam Dashboard',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: mode,
            builder: (context, child) {
              if (child == null) return const SizedBox.shrink();
              final media = MediaQuery.of(context);
              final scaled = MediaQuery(
                data: media.copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child,
              );
              if (mode == ThemeMode.light) {
                return ColorFiltered(
                  colorFilter: const ColorFilter.matrix(_whitePolishMatrix),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(_invertMatrix),
                    child: scaled,
                  ),
                );
              }
              return scaled;
            },
            home: const AuthGatePage(),
          ),
        ),
      ),
    );
  }
}

const List<double> _invertMatrix = <double>[
  0, -1, 0, 0, 255,
  -1, 0, 0, 0, 255,
  0, 0, -1, 0, 255,
  0, 0, 0, 1, 0,
];

const List<double> _whitePolishMatrix = <double>[
  0.92, 0.06, 0.02, 0, 24,
  0.06, 0.92, 0.02, 0, 24,
  0.04, 0.06, 0.90, 0, 26,
  0, 0, 0, 1, 0,
];

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

