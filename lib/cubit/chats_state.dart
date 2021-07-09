part of 'chats_cubit.dart';

@immutable
abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final Stream<QuerySnapshot> chats;
  ChatsLoaded({required this.chats});
}
