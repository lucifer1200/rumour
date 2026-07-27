part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String roomId;
  LoadMessages(this.roomId);
}

class SendMessage extends ChatEvent {
  final String roomId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String text;

  SendMessage({
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.text,
  });
}

class _MessagesUpdated extends ChatEvent {
  final List<Message> messages;
  _MessagesUpdated(this.messages);
}
