import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumour/providers/index.dart';
import 'package:rumour/theme/app_colors.dart';
import 'package:rumour/widgets/index.dart';
import 'package:rumour/models/message.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String roomId;

  const ChatScreen({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final messageRepository = ref.read(messageRepositoryProvider);
      await messageRepository.sendMessage(
        roomId: widget.roomId,
        userId: user.id,
        userName: user.name,
        userAvatar: user.avatar,
        text: text,
      );

      _scrollToBottom();
    } catch (e) {
      ref.read(errorProvider.notifier).state = e.toString();
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  void _onBackPressed() {
    ref.read(currentRoomProvider.notifier).state = null;
    ref.read(currentUserProvider.notifier).state = null;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final currentRoom = ref.watch(currentRoomProvider);
    final currentUser = ref.watch(currentUserProvider);
    final messagesAsync = ref.watch(messagesProvider(widget.roomId));

    if (currentRoom == null || currentUser == null) {
      return const Scaffold(
        body: LoadingIndicator(message: 'Loading room...'),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: RoomHeader(
          room: currentRoom,
          onBackPressed: _onBackPressed,
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet.\nStart the conversation!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                // Group messages by date
                final groupedMessages = _groupMessagesByDate(messages);

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: groupedMessages.length,
                  itemBuilder: (context, index) {
                    final item = groupedMessages[index];
                    if (item is DateTime) {
                      return DateSeparator(date: item);
                    } else if (item is Message) {
                      final isOwnMessage = item.userId == currentUser.id;
                      return MessageBubble(
                        message: item,
                        isOwnMessage: isOwnMessage,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
              loading: () => const LoadingIndicator(message: 'Loading messages...'),
              error: (error, _) => Center(
                child: Text('Error loading messages: $error'),
              ),
            ),
          ),
          // Message input
          MessageInput(
            onSendMessage: _sendMessage,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  List<dynamic> _groupMessagesByDate(List<Message> messages) {
    final List<dynamic> result = [];
    DateTime? lastDate;

    for (final message in messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (lastDate == null || messageDate != lastDate) {
        result.add(messageDate);
        lastDate = messageDate;
      }

      result.add(message);
    }

    return result;
  }
}
