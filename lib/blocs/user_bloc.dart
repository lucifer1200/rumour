import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumour/models/user.dart';
import 'package:rumour/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<CreateUserForRoom>(_onCreateUser);
    on<LoadUserForRoom>(_onLoadUser);
  }

  Future<void> _onCreateUser(CreateUserForRoom event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getOrCreateUserIdentity(event.roomId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUser(LoadUserForRoom event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.getUserIdentity(event.roomId);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserInitial());
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
