import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_kodeaqua/cubits/busy_cubit.dart';

class AppBarLoadingWidget extends StatelessWidget {
  const AppBarLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusyCubit, bool>(
      builder: (_, isBusy) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isBusy ? null : 0,
          child: const LinearProgressIndicator(),
        );
      },
    );
  }
}
