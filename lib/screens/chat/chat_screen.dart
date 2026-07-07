import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<ChatMessage> _messages;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.chat.messages);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'u1',
        content: text,
        type: MessageType.text,
        status: MessageStatus.sent,
        createdAt: DateTime.now(),
      ));
      _ctrl.clear();
      _isTyping = false;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() => _isTyping = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isTyping = false;
            _messages.add(ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: widget.chat.otherUserId,
              content: _getAutoReply(text),
              type: MessageType.text,
              status: MessageStatus.delivered,
              createdAt: DateTime.now(),
            ));
          });
          _scrollToBottom();
        }
      });
    });
    _scrollToBottom();
  }

  String _getAutoReply(String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('where') || lower.contains('location')) {
      return 'I\'m on my way! About 2 minutes from your location 📍';
    }
    if (lower.contains('time') || lower.contains('long')) {
      return 'Just a few more minutes! Traffic is clearing up 🛵';
    }
    if (lower.contains('ok') || lower.contains('thanks')) {
      return 'You\'re welcome! 😊 See you soon!';
    }
    return 'Sure! I\'ll be there shortly. 🙏';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: widget.chat.otherUserPhoto != null
                        ? NetworkImage(widget.chat.otherUserPhoto!)
                        : null,
                    backgroundColor: AppColors.primaryContainer,
                    child: widget.chat.otherUserPhoto == null
                        ? Text(
                            widget.chat.otherUserName[0],
                            style: AppTextStyles.titleSmall
                                .copyWith(color: AppColors.primary),
                          )
                        : null,
                  ),
                  if (widget.chat.isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chat.otherUserName,
                      style: AppTextStyles.titleSmall),
                  Text(
                    widget.chat.isOnline ? 'Online' : 'Offline',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: widget.chat.isOnline
                          ? AppColors.success
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.call),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isTyping && i == _messages.length) {
                  return _TypingIndicator(
                      name: widget.chat.otherUserName);
                }
                final msg = _messages[i];
                final isMe = msg.senderId == 'u1';
                return _MessageBubble(message: msg, isMe: isMe);
              },
            ),
          ),
          _InputBar(
            ctrl: _ctrl,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryContainer,
              child: Text('🛵', style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isMe ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.createdAt),
                        style: AppTextStyles.badge.copyWith(
                          color: isMe
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppColors.textTertiary,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.status == MessageStatus.read
                              ? Icons.done_all
                              : message.status == MessageStatus.delivered
                                  ? Icons.done_all
                                  : Icons.done,
                          size: 14,
                          color: message.status == MessageStatus.read
                              ? Colors.lightBlueAccent
                              : Colors.white.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m ${dt.hour >= 12 ? 'PM' : 'AM'}';
  }
}

class _TypingIndicator extends StatelessWidget {
  final String name;
  const _TypingIndicator({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primaryContainer,
            child: Text('🛵', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _dot(delay: 0),
                _dot(delay: 200),
                _dot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required int delay}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (_, v, __) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.textTertiary.withValues(alpha: 0.4 + 0.6 * v),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onSend;

  const _InputBar({required this.ctrl, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              style: AppTextStyles.bodyMedium,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                prefixIcon: IconButton(
                  icon: const Icon(Iconsax.attach_circle,
                      color: AppColors.textTertiary, size: 20),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.send_1,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
