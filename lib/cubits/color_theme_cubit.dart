import 'package:flutter_bloc/flutter_bloc.dart';

import '../utilities/shared_preferences_utility_new.dart';

class ColorThemeCubit extends Cubit<int> {
  ColorThemeCubit() : super(0);

  void set({required int value}) => emit(value);
  void unset() => emit(0);

  Future<void> init() async {
    final SharedPreferencesUtilityNew sharedPreferencesUtil = SharedPreferencesUtilityNew();
    final int? id = await sharedPreferencesUtil.read(key: 'color_theme');

    emit(id ?? 0);
  }

  Future<bool> save() async {
    final SharedPreferencesUtilityNew sharedPreferencesUtil = SharedPreferencesUtilityNew();
    return await sharedPreferencesUtil.write(key: 'color_theme', value: state);
  }
}
