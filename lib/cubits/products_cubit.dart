import 'dart:convert';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product_model.dart';
import '../utilities/http_utility_new.dart';
import '../utilities/model_from_json_utility.dart';
import '../utilities/task_utility_new.dart';

class ProductsCubit extends Cubit<List<ProductModel>?> {
  ProductsCubit() : super(null);

  Future<void> init({required CancellationToken token}) async {
    final HttpUtilityNew httpUtilityNew = HttpUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'products', requestType: HttpRequestType.get);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtilityNew.makeRequest(payload: httpPayload), isMandatory: true);
    final TaskUtilityNew taskUtilityNew = TaskUtilityNew();
    final TaskResult taskResult = await taskUtilityNew.run(payload: taskPayload);

    emit(taskResult.result == null ? <ProductModel>[] : ModelFromJsonUtility.products(taskResult.result.body));
  }

  Future<TaskResult> send({required CancellationToken token, bool isNew = true, required ProductModel data}) async {
    final HttpUtilityNew httpUtil = HttpUtilityNew();
    final TaskUtilityNew taskUtil = TaskUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'products', requestType: isNew ? HttpRequestType.post : HttpRequestType.put, data: jsonEncode(data), id: data.id);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtil.makeRequest(payload: httpPayload), isMandatory: true);

    return await taskUtil.run(payload: taskPayload);
  }

  Future<TaskResult> deleteById({required CancellationToken token, required String id}) async {
    final HttpUtilityNew httpUtil = HttpUtilityNew();
    final TaskUtilityNew taskUtil = TaskUtilityNew();
    final HttpPayload httpPayload = HttpPayload(entity: 'products', requestType: HttpRequestType.delete, data: id);
    final TaskPayload taskPayload = TaskPayload(token: token, function: () => httpUtil.makeRequest(payload: httpPayload), isMandatory: true);

    return await taskUtil.run(payload: taskPayload);
  }
}
