import 'dart:async';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/busy_cubit.dart';
import '../main.dart';

class TaskPayload {
  final CancellationToken token;
  final Future Function() function;
  final bool isMandatory;

  TaskPayload({required this.token, required this.function, required this.isMandatory});
}

class TaskResult<T> {
  int? elapsedTime;
  T? result;
  String? exception;

  TaskResult({this.elapsedTime, this.result, this.exception});
}

class TaskErrorWidget extends StatelessWidget {
  final bool isMandatory;
  final String message;
  const TaskErrorWidget({super.key, required this.isMandatory, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error occured'),
      content: Text(message),
      actions: isMandatory
          ? <Widget>[
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retry'),
              )
            ]
          : <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retry'),
              )
            ],
    );
  }
}

class TaskUtilityNew {
  TaskUtilityNew._internal();
  static final TaskUtilityNew _instance = TaskUtilityNew._internal();
  factory TaskUtilityNew() => _instance;

  Future<TaskResult> run({required TaskPayload payload}) async {
    late final DateTime startAt;
    late final DateTime endAt;
    late TaskResult result = TaskResult();

    startAt = DateTime.now().toUtc();
    navigatorKey.currentContext!.read<BusyCubit>().toBusy();
    try {
      result.result = await payload.function().asCancellable(payload.token).timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      result.exception = e.toString();
    } catch (e) {
      result.exception = e.toString();
    } finally {
      endAt = DateTime.now().toUtc();
      result.elapsedTime = endAt.difference(startAt).inSeconds;
      navigatorKey.currentContext!.read<BusyCubit>().toIdle();
    }

    print('Task was executed in ${result.elapsedTime} second(s). Result: ${result.result}. Exception: ${result.exception}');

    if (result.exception == null) return result;

    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => TaskErrorWidget(
        isMandatory: payload.isMandatory,
        message: result.exception.toString(),
      ),
    );

    if (!payload.isMandatory) return result;

    return await run(payload: payload);
  }
}
