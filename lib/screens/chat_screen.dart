import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumour/blocs/index.dart';
import 'package:rumour/models/message.dart';
import 'package:rumour/theme/app_colors.dart';
import 'package:rumour/widgets/index.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;

  const ChatScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollCtrl = ScrollController();
  final _msgCtrl = TextEditingController();
  late String _userId;
  late String _userName;
  late String _userAvatar;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages(widget.roomId));
    // Get user from UserBloc state
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _userId = userState.user.id;
      _userName = userState.user.name;
      _userAvatar = userState.user.avatar;
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMsg(String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(
      roomId: widget.roomId,
      userId: _userId,
      userName: _userName,
      userAvatar: _userAvatar,
      text: text,
    ));
    _msgCtrl.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Column(
        children: [
          // Simple header
          Container(
            color: AppColors.darkSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room #${widget.roomId.substring(0, 4)}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('Anonymous chat',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Messages
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatError) {
                  return Center(child: Text(state.message));
                }

                List<Message> messages = [];
                if (state is ChatLoaded) {
                  messages = state.messages;
                } else if (state is MessageSent) {
                  messages = state.messages;
                }

                if (messages.isEmpty) {
                  return Center(
                    child: Text('No messages yet.\nStart talking!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary)),
                  );
                }

                // Group by date
                final grouped = _groupByDate(messages);

                return ListView.builder(
                  controller: _scrollCtrl,
                  itemCount: grouped.length,
                  itemBuilder: (_, idx) {
                    final item = grouped[idx];
                    if (item is DateTime) {
                      return DateSeparator(date: item);
                    }
                    final msg = item as Message;
                    return MessageBubble(
                      message: msg,
                      isOwnMessage: msg.userId == _userId,
                    );
                  },
                );
              },
            ),
          ),
          // Input
          Container(
            color: AppColors.darkBackground,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.darkSurfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    onSubmitted: (text) => _sendMsg(text),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMsg(_msgCtrl.text),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check,
                        color: AppColors.ownMessageText, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _groupByDate(List<Message> msgs) {
    final result = <dynamic>[];
    DateTime? lastDate;

    for (final msg in msgs) {
      final msgDate = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );

      if (lastDate == null || msgDate != lastDate) {
        result.add(msgDate);
        lastDate = msgDate;
      }
      result.add(msg);
    }

    return result;
  }
}
