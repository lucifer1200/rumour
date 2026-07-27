part of 'room_bloc.dart';

abstract class RoomEvent {}

class CreateRoom extends RoomEvent {}

class JoinRoom extends RoomEvent {
  final String code;
  JoinRoom(this.code);
}
