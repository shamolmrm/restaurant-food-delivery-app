enum MessageType { text, image, system }
enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final String? imageUrl;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.status,
    required this.createdAt,
    this.imageUrl,
  });
}

class ChatModel {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserPhoto;
  final bool isOnline;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final List<ChatMessage> messages;

  const ChatModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserPhoto,
    this.isOnline = false,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.messages = const [],
  });
}
