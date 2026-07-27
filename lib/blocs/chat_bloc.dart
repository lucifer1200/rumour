import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumour/models/message.dart';
import 'package:rumour/repositories/message_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageRepository messageRepository;

  ChatBloc(this.messageRepository) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messagesStream = messageRepository.getMessagesStream(event.roomId);
      await for (var messages in messagesStream) {
        emit(ChatLoaded(messages));
      }
    } catch (e) {
      emit(ChatError('Failed to load messages: $e'));
    }
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
      // Re-load messages after sending
      add(LoadMessages(event.roomId));
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }
}
