import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/cubit/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  final Map ds;
  ChatsScreen({required this.ds, Key? key}) : super(key: key);
  TextEditingController chatMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: _chatHeader(ds),
        ),
        body: BlocBuilder<ChatsCubit, ChatsState>(
          builder: (context, state) {
            if (state is ChatsInitial) {
              BlocProvider.of<ChatsCubit>(context)
                  .initialiseRoom(ds["username"]);
            }
            return Stack(
              children: [
                (state is ChatsLoaded)
                    ? _chats(state.chats, context)
                    : CircularProgressIndicator(),
                _chatTextBox(context)
              ],
            );
          },
        ),
      ),
    );
  }

  _chatHeader(Map ds) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            ds["imageURL"],
            fit: BoxFit.contain,
            height: 40,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Text(ds["name"])
      ],
    );
  }

  _chatTextBox(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        color: Colors.grey[700],
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: chatMessage,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Message",
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                BlocProvider.of<ChatsCubit>(context)
                    .addMessage(chatMessage.text);
                chatMessage.text = "";
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _chats(Stream<QuerySnapshot> chats, BuildContext context) {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return (snapshot.hasData)
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                itemBuilder: (context, index) =>
                    _chatBody(snapshot.data!.docs[index]))
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  _chatBody(QueryDocumentSnapshot<Object?> doc) {
    return Row(
      mainAxisAlignment: (doc["sendBy"] != ds["username"])
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          margin: EdgeInsets.symmetric(vertical: 2.0),
          decoration: BoxDecoration(
              color: (doc["sendBy"] != ds["username"])
                  ? Colors.blue[200]
                  : Colors.orange[100],
              borderRadius: BorderRadius.circular(16)),
          child: Text(doc["message"]),
        ),
      ],
    );
  }
}
