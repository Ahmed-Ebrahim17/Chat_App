part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  List<Message> messageList;
  ChatSuccess({required this.messageList});
}

class ChatFailure extends ChatState {
  bool isFailure = false;
  ChatFailure({required this.isFailure});
}
