class Message {
  final String message;
  final String id;

  Message(this.message, this.id);

  factory Message.fromJson(JsonData) {
    return Message(
      JsonData['message'],
      JsonData['id'],
    );
  }
}
