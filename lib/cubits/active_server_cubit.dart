import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/shared_preferences_utility_new.dart';

class ActiveServerCubit extends Cubit<String> {
  ActiveServerCubit() : super('d9f82ede052e481cbc9ecf3de1140b03');

  void set({required String value}) => emit(value);
  void unset() => emit('');

  Future<void> init() async {
    final SharedPreferencesUtilityNew sharedPreferencesUtil = SharedPreferencesUtilityNew();
    final String? id = await sharedPreferencesUtil.read(key: 'crudcrud_id');

    emit(id ?? '');
  }

  Future<bool> save() async {
    final SharedPreferencesUtilityNew sharedPreferencesUtil = SharedPreferencesUtilityNew();
    return await sharedPreferencesUtil.write(key: 'crudcrud_id', value: state);
  }
}
