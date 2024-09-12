import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_kodeaqua/cubits/color_theme_cubit.dart';
import 'package:klontong_kodeaqua/cubits/roles_cubit.dart';
import 'package:klontong_kodeaqua/utilities/init_utility.dart';

import 'cubits/active_server_cubit.dart';
import 'cubits/busy_cubit.dart';
import 'cubits/categories_cubit.dart';
import 'cubits/products_cubit.dart';
import 'cubits/user_cubit.dart';
import 'screens/base_screen.dart';

late final GlobalKey<NavigatorState> navigatorKey;

void main() {
  navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ActiveServerCubit()),
        BlocProvider(create: (_) => ColorThemeCubit()),
        BlocProvider(create: (_) => BusyCubit()),
        BlocProvider(create: (_) => RolesCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => ProductsCubit()),
        BlocProvider(create: (_) => CategoriesCubit()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Color get color {
    return <Color>[
      Colors.green,
      Colors.indigo,
      Colors.red,
      Colors.blue,
    ].elementAt(context.read<ColorThemeCubit>().state);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await InitUtility.start();
      navigatorKey.currentContext!.read<ColorThemeCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorThemeCubit, int>(
      builder: (context, colorTheme) {
        return MaterialApp(
          title: 'Klontong App',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: color, brightness: Brightness.light),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: color, brightness: Brightness.dark),
          ),
          themeMode: ThemeMode.system,
          home: const BaseScreen(),
        );
      },
    );
  }
}
