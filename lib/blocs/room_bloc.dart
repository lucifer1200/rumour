import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumour/models/room.dart';
import 'package:rumour/repositories/room_repository.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository roomRepository;

  RoomBloc(this.roomRepository) : super(RoomInitial()) {
    on<CreateRoom>(_onCreateRoom);
    on<JoinRoom>(_onJoinRoom);
  }

  Future<void> _onCreateRoom(CreateRoom event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      final room = await roomRepository.createRoom();
      emit(RoomLoaded(room));
    } catch (e) {
      emit(RoomError('Failed to create room: $e'));
    }
  }

  Future<void> _onJoinRoom(JoinRoom event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      if (event.code.isEmpty) {
        emit(RoomError('Room code cannot be empty'));
        return;
      }
      final room = await roomRepository.joinRoomByCode(event.code);
      emit(RoomLoaded(room));
    } catch (e) {
      emit(RoomError('Room not found. Check the code and try again.'));
    }
  }
}
