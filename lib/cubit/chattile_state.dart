part of 'chattile_cubit.dart';

@immutable
abstract class ChattileState {}

class ChattileInitial extends ChattileState {}

class ChattileLoaded extends ChattileState {
  final Map user;

  ChattileLoaded(this.user);
}
