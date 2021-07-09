import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/services/DatabaseHelper.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void getUsers(String username) async {
    emit(SearchLoading());
    DatabaseHelper()
        .getUserByUsername(username)
        .then((value) => emit(SearchLoaded(stream: value)));
  }

  void initial() {
    emit(SearchInitial());
  }
}
