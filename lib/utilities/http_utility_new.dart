import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../cubits/active_server_cubit.dart';
import '../main.dart';

enum HttpRequestType { get, getById, post, put, delete }

class HttpPayload {
  final String entity;
  final HttpRequestType requestType;
  final String? id;
  final String? data;

  HttpPayload({this.id, required this.entity, required this.requestType, this.data});
}

class HttpUtilityNew {
  HttpUtilityNew._internal();
  static final HttpUtilityNew _instance = HttpUtilityNew._internal();
  factory HttpUtilityNew() => _instance;

  final String _baseUrl = 'crudcrud.com';
  static String? get _crudCrudId => navigatorKey.currentContext!.read<ActiveServerCubit>().state;
  final http.Client client = http.Client();

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  Future<http.Response> makeRequest({required HttpPayload payload}) async {
    late final Uri url;

    try {
      switch (payload.requestType) {
        case HttpRequestType.get:
          url = Uri.https(_baseUrl, 'api/$_crudCrudId/${payload.entity}');
          return await client.get(url, headers: _headers);
        case HttpRequestType.getById:
          url = Uri.https(_baseUrl, 'api/$_crudCrudId/${payload.entity}/${payload.data}');
          return await client.get(url, headers: _headers);
        case HttpRequestType.post:
          url = Uri.https(_baseUrl, 'api/$_crudCrudId/${payload.entity}');
          return await client.post(url, headers: _headers, body: payload.data);
        case HttpRequestType.put:
          url = Uri.https(_baseUrl, 'api/$_crudCrudId/${payload.entity}/${payload.id}');
          return await client.put(url, headers: _headers, body: payload.data);
        case HttpRequestType.delete:
          url = Uri.https(_baseUrl, 'api/$_crudCrudId/${payload.entity}/${payload.data}');
          return await client.delete(url, headers: _headers);
      }
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    }
  }
}
