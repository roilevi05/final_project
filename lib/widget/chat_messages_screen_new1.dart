import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widget/bubble_message.dart';
import 'package:flutter_complete_guide/models/auth.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ChatMessages extends StatelessWidget {
  final String userId;
  ChatMessages(@required this.userId);
  @override
  //BuildContext טענת כניסה : פעולה שמקבלת
  // טענת יציאה : פעולה שבונה את הרשימה של כל ההודעות
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser.uid;
    List<Auth> listuser =
        Provider.of<AuthProvdier>(context, listen: false).Auths;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!chatSnapshots.hasData || chatSnapshots.data.docs.isEmpty) {
          return const Center(
            child: Text('There are no messages yet'),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        List<DocumentSnapshot> filteredMessages;
        final loadedMessages = chatSnapshots.data.docs;

        Auth admin = listuser.firstWhere((element) => element.uid == auth);

        if (!(admin.kind == 'admin')) {
          filteredMessages = loadedMessages
              .where((message) => message['userId'] == auth)
              .toList();
        } else {
          filteredMessages = loadedMessages
              .where((message) => message['userId'] == userId)
              .toList();
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: filteredMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = filteredMessages[index];
            final nextChatMessage = index + 1 < filteredMessages.length
                ? filteredMessages[index + 1]
                : null;
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = currentMessageUserId == nextMessageUserId;
            if (chatMessage['isAdmin']) {
              if (!nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: chatMessage['isAdmin'],
                );
              } else {
                return MessageBubble.first(
                  chatMessage['url'],
                  chatMessage['username'],
                  chatMessage['text'],
                  chatMessage['isAdmin'],
                );
              }
            } else {
              if (!nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: auth == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  chatMessage['url'],
                  chatMessage['username'],
                  chatMessage['text'],
                  auth == currentMessageUserId,
                );
              }
            }
          },
        );
      },
    );
  }
}
