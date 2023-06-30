import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../widgets/chat_Buble.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, this.email});
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  final String? email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy('CreatedAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messageList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messageList.add(Message.fromJson(snapshot.data!.docs[i]));
            }

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
                    child: ListView.builder(
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Container(
                      height: 50,
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data) {
                          messages.add(
                            {
                              'message': data,
                              'CreatedAt': DateTime.now(),
                              'id': email,
                            },
                          );
                          controller.clear();
                          _controller.animateTo(
                            0,
                            duration: Duration(microseconds: 650),
                            curve: Curves.easeIn,
                          );
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          suffixIcon: Icon(
                            Icons.send_outlined,
                            color: Colors.black.withOpacity(0.7),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Send message',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPriamryColor,
              centerTitle: true,
              title: Text(
                'Chat Screen',
                style: GoogleFonts.lato(color: Colors.black),
              ),
            ),
            backgroundColor: kPriamryColor,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        });
  }
}
