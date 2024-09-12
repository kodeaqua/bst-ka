import 'dart:convert';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../utilities/http_utility_new.dart';

import '../utilities/shared_preferences_utility_new.dart';
import '../utilities/task_utility_new.dart';
import 'color_theme_cubit.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);

  void set(UserModel? value) => emit(value);

  Future<void> loadUser({required CancellationToken token}) async {
    final SharedPreferencesUtilityNew sharedPreferencesUtil = SharedPreferencesUtilityNew();
    final String? id = await sharedPreferencesUtil.read(key: 'user_id');

    if (id == null) return;
    await init(token: token, id: id);
  }

  Future<void> init({required CancellationToken token, required String id}) async {
    final HttpUtilityNew httpUtilityNew = HttpUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'users', requestType: HttpRequestType.getById, data: id);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtilityNew.makeRequest(payload: httpPayload), isMandatory: true);
    final TaskUtilityNew taskUtilityNew = TaskUtilityNew();
    final TaskResult taskResult = await taskUtilityNew.run(payload: taskPayload);

    emit(taskResult.result == null ? null : UserModel.fromJson(jsonDecode(taskResult.result.body)));
  }

  Future<TaskResult> send({required CancellationToken token, bool isNew = true, required UserModel data}) async {
    final HttpUtilityNew httpUtil = HttpUtilityNew();
    final TaskUtilityNew taskUtil = TaskUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'users', requestType: isNew ? HttpRequestType.post : HttpRequestType.put, data: jsonEncode(data));
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtil.makeRequest(payload: httpPayload), isMandatory: true);

    return await taskUtil.run(payload: taskPayload);
  }

  Future<bool> save() async {
    final SharedPreferencesUtilityNew sharedPreferencesUtil = SharedPreferencesUtilityNew();
    return await sharedPreferencesUtil.write(key: 'user_id', value: '${state?.id}');
  }

  Future<bool> onLogout() async {
    final SharedPreferencesUtilityNew sharedPreferencesUtil = SharedPreferencesUtilityNew();
    final bool isDeleted = await sharedPreferencesUtil.clear();

    if (!isDeleted) return false;
    navigatorKey.currentContext!.read<ColorThemeCubit>().set(value: 0);
    emit(null);
    return true;
  }
}
