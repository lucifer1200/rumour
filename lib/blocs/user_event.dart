part of 'user_bloc.dart';

abstract class UserEvent {}

class CreateUserForRoom extends UserEvent {
  final String roomId;
  CreateUserForRoom(this.roomId);
}

class LoadUserForRoom extends UserEvent {
  final String roomId;
  LoadUserForRoom(this.roomId);
}
