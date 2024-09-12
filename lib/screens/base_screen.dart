import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_kodeaqua/cubits/user_cubit.dart';
import 'package:klontong_kodeaqua/screens/home_screen.dart';
import 'package:klontong_kodeaqua/screens/login_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  late final CancellationToken _token;
  late bool? _hasLogin;

  @override
  void initState() {
    super.initState();
    _token = CancellationToken();
    _hasLogin = null;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<UserCubit>().loadUser(token: _token);
      setState(() {
        if (context.read<UserCubit>().state != null) {
          _hasLogin = true;
        } else {
          _hasLogin = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_hasLogin) {
        true => const HomeScreen(),
        false => const LoginScreen(),
        _ => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
      },
    );
  }
}
