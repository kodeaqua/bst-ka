import 'dart:convert';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/category_model.dart';
import '../utilities/http_utility_new.dart';
import '../utilities/model_from_json_utility.dart';
import '../utilities/task_utility_new.dart';

class CategoriesCubit extends Cubit<List<CategoryModel>?> {
  CategoriesCubit() : super(null);

  Future<void> init({required CancellationToken token}) async {
    final HttpUtilityNew httpUtil = HttpUtilityNew();
    final TaskUtilityNew taskUtil = TaskUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'categories', requestType: HttpRequestType.get);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtil.makeRequest(payload: httpPayload), isMandatory: false);
    final TaskResult taskResult = await taskUtil.run(payload: taskPayload);

    emit(taskResult.result == null ? <CategoryModel>[] : ModelFromJsonUtility.categories(taskResult.result.body));
  }

  Future<TaskResult> send({required CancellationToken token, bool isNew = true, required CategoryModel data}) async {
    final HttpUtilityNew httpUtil = HttpUtilityNew();
    final TaskUtilityNew taskUtil = TaskUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'categories', requestType: isNew ? HttpRequestType.post : HttpRequestType.put, data: jsonEncode(data), id: data.id);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtil.makeRequest(payload: httpPayload), isMandatory: true);

    return await taskUtil.run(payload: taskPayload);
  }

  Future<TaskResult> deleteById({required CancellationToken token, required String id}) async {
    final HttpUtilityNew httpUtil = HttpUtilityNew();
    final TaskUtilityNew taskUtil = TaskUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'categories', requestType: HttpRequestType.delete, data: id);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtil.makeRequest(payload: httpPayload), isMandatory: true);

    return await taskUtil.run(payload: taskPayload);
  }
}
