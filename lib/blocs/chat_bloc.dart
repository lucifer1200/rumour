import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumour/models/message.dart';
import 'package:rumour/repositories/message_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository messageRepository;
  StreamSubscription<List<Message>>? _msgSub;

  ChatBloc(this.messageRepository) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<_MessagesUpdated>(_onMessagesUpdated);
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    _msgSub?.cancel();
    _msgSub = messageRepository.getMessagesStream(event.roomId).listen(
      (messages) => add(_MessagesUpdated(messages)),
      onError: (e) => add(_MessagesUpdated(const [])),
    );
  }

  void _onMessagesUpdated(_MessagesUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await messageRepository.sendMessage(
        roomId: event.roomId,
        userId: event.userId,
        userName: event.userName,
        userAvatar: event.userAvatar,
        text: event.text,
      );
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }

  @override
  Future<void> close() {
    _msgSub?.cancel();
    return super.close();
  }
}
