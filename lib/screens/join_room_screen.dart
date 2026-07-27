import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumour/blocs/index.dart';
import 'package:rumour/theme/app_colors.dart';
import 'package:rumour/theme/app_text_styles.dart';
import 'package:rumour/widgets/loading_indicator.dart';
import 'chat_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({Key? key}) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _codeController = TextEditingController();
  String? _errorMsg;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleJoinRoom() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _errorMsg = 'Enter a code');
      return;
    }
    context.read<RoomBloc>().add(JoinRoom(code));
  }

  void _handleCreateRoom() {
    context.read<RoomBloc>().add(CreateRoom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: MultiBlocListener(
        listeners: [
          BlocListener<RoomBloc, RoomState>(
            listener: (context, state) {
              if (state is RoomLoaded) {
                context.read<UserBloc>().add(CreateUserForRoom(state.room.id));
              } else if (state is RoomError) {
                setState(() => _errorMsg = state.message);
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                final roomState = context.read<RoomBloc>().state;
                if (roomState is RoomLoaded) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(roomId: roomState.room.id),
                    ),
                  );
                }
              } else if (state is UserError) {
                setState(() => _errorMsg = state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<RoomBloc, RoomState>(
          builder: (context, roomState) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (roomState is RoomLoading || userState is UserLoading) {
                  return const LoadingIndicator(message: 'Connecting...');
                }
                return _buildForm(context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'R',
                    style: AppTextStyles.displayMedium
                        .copyWith(color: AppColors.ownMessageText),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Rumour',
              textAlign: TextAlign.center,
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Anonymous room-code chat',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            Text('Join a Room', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Enter code',
                hintStyle: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.darkSurfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onSubmitted: (_) => _handleJoinRoom(),
            ),
            if (_errorMsg != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMsg!,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleJoinRoom,
              child: const Text('Join Room'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.divider)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('or', style: AppTextStyles.bodySmall),
                ),
                const Expanded(child: Divider(color: AppColors.divider)),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _handleCreateRoom,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Create New Room',
                style: AppTextStyles.button
                    .copyWith(color: AppColors.primaryGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
