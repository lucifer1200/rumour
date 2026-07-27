part of 'room_bloc.dart';

abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final Room room;
  RoomLoaded(this.room);
}

class RoomError extends RoomState {
  final String message;
  RoomError(this.message);
}
