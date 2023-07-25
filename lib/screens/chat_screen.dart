import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../widgets/chat_Buble.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, this.email});
  List<Message> messageList = [];
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPriamryColor,
        centerTitle: true,
        title: Text(
          'Chat Screen',
          style: GoogleFonts.lato(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                BlocConsumer<ChatCubit, ChatState>(listener: (context, state) {
              if (state is ChatSuccess) {
                messageList = state.messageList;
                BlocProvider.of<ChatCubit>(context).success = true;
              } else if (state is ChatFailure) {
                BlocProvider.of<ChatCubit>(context).success = false;
              }
            }, builder: (context, state) {
              return ListView.builder(
                reverse: true,
                controller: _controller,
                itemCount: messageList.length,
                itemBuilder: (context, index) {
                  return messageList[index].id == email
                      ? ChatBuble(
                          message: messageList[index],
                        )
                      : ChatBubleForFriend(
                          message: messageList[index],
                        );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: controller,
                onSubmitted: (data) {
                  BlocProvider.of<ChatCubit>(context)
                      .sendMessage(message: data, email: email!);
                  controller.clear();
                  _controller.animateTo(
                    0,
                    duration: const Duration(microseconds: 650),
                    curve: Curves.easeIn,
                  );
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  suffixIcon: Icon(
                    Icons.send_outlined,
                    color: Colors.black.withOpacity(0.7),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Send message',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
