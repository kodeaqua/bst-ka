import 'package:flutter_bloc/flutter_bloc.dart';

class BusyCubit extends Cubit<bool> {
  BusyCubit() : super(false);

  void toBusy() => emit(true);
  void toIdle() => emit(false);
}
