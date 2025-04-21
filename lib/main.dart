import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csm/firebase_options.dart';
import 'package:csm/repository/auth_repository.dart';
import 'package:csm/repository/package_repository.dart';
import 'package:csm/src/features/auth/cubit/auth_cubit.dart';
import 'package:csm/src/features/packages/cubit/package_cubit.dart';
import 'package:csm/src/features/theme/cubit/theme_cubit.dart';
import 'package:csm/src/routes/app_router.dart';
import 'package:csm/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/features/home/cubit/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

final appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => PackageCubit(PackageRepository(FirebaseFirestore.instance, FirebaseAuth.instance))),
        BlocProvider(create: (_) => AuthCubit(FirebaseAuth.instance, AuthRepository())),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          ColorTheme.isDark = isDark;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: appRouter.delegate(),
            routeInformationParser: appRouter.defaultRouteParser(),
            theme: ThemeData(fontFamily: 'Comfortaa'),
          );
        },
      ),
    );
  }
}
