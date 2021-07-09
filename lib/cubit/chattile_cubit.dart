import 'package:bloc/bloc.dart';
import 'package:fl_notes/services/DatabaseHelper.dart';
import 'package:fl_notes/services/SharedPreferenceHelper.dart';
import 'package:meta/meta.dart';

part 'chattile_state.dart';

class ChattileCubit extends Cubit<ChattileState> {
  ChattileCubit() : super(ChattileInitial());

  fetchUserInformation(String chatRoomId) async {
    String musername = await SharedPreferencesHelper().getUserName();
    String username = chatRoomId.replaceAll(musername, "").replaceAll("_", "");
    DatabaseHelper()
        .getUserInfo(username)
        .then((value) => emit(ChattileLoaded(value.docs[0].data() as Map)));
  }
}
