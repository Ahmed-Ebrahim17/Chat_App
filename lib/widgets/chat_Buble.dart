import 'package:chat_app/screens/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/message.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomLeft: Radius.zero,
              ),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Text(
              message.message,
            ),
          ),
          // const Text('Try again'),
          Icon(
            BlocProvider.of<ChatCubit>(context).success
                ? null
                : Icons.warning_rounded,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class ChatBubleForFriend extends StatelessWidget {
  const ChatBubleForFriend({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.zero,
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          color: Colors.blueGrey.shade300,
        ),
        child: Text(
          message.message,
        ),
      ),
    );
  }
}
