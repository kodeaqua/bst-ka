import 'dart:convert';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/role_model.dart';
import '../utilities/http_utility_new.dart';
import '../utilities/model_from_json_utility.dart';
import '../utilities/task_utility_new.dart';

class RolesCubit extends Cubit<List<RoleModel>?> {
  RolesCubit() : super(null);

  Future<void> init({required CancellationToken token}) async {
    final HttpUtilityNew httpUtilityNew = HttpUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'roles', requestType: HttpRequestType.get);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtilityNew.makeRequest(payload: httpPayload), isMandatory: true);
    final TaskUtilityNew taskUtilityNew = TaskUtilityNew();
    final TaskResult taskResult = await taskUtilityNew.run(payload: taskPayload);

    emit(taskResult.result == null ? <RoleModel>[] : ModelFromJsonUtility.roles(taskResult.result.body));
  }

  Future<TaskResult> send({required CancellationToken token, bool isNew = true, required RoleModel data}) async {
    final HttpUtilityNew httpUtil = HttpUtilityNew();
    final TaskUtilityNew taskUtil = TaskUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'roles', requestType: isNew ? HttpRequestType.post : HttpRequestType.put, data: jsonEncode(data));
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtil.makeRequest(payload: httpPayload), isMandatory: true);

    return await taskUtil.run(payload: taskPayload);
  }
}
