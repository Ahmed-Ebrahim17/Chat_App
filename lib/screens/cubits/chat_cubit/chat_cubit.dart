import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  List<Message> messageList = [];
  bool success = false;

  Future<void> sendMessage(
      {required String message, required String email}) async {
    try {
      messages.add(
        {
          'message': message,
          'CreatedAt': DateTime.now(),
          'id': email,
        },
      );
    } on Exception {
      emit(ChatFailure(isFailure: success));
    }
  }

  void getMessage() {
    messages.orderBy('CreatedAt', descending: true).snapshots().listen((event) {
      List<Message> messageList = [];
      messageList.clear();
      for (var doc in event.docs) {
        messageList.add(
          Message.fromJson(doc),
        );
      }
      emit(
        ChatSuccess(messageList: messageList),
      );
    });
  }
}
