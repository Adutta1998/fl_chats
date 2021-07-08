import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/services/DatabaseHelper.dart';
import 'package:meta/meta.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(RoomsInitial());

  void getUsers(String username) async {
    emit(RoomsLoading());
    DatabaseHelper()
        .getUserByUsername(username)
        .then((value) => emit(RoomsLoaded(stream: value)));
  }

  void initial() {
    emit(RoomsInitial());
  }
}
