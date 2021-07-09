import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/cubit/rooms_cubit.dart';
import 'package:fl_notes/screens/chat_screen.dart';
import 'package:fl_notes/screens/search_user_screen.dart';
import 'package:fl_notes/screens/signup_screen.dart';
import 'package:fl_notes/services/AuthService.dart';
import 'package:fl_notes/services/DatabaseHelper.dart';
import 'package:fl_notes/services/SharedPreferenceHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  Future<Map> getUserInformation(String chatroomid) async {
    var musername = await SharedPreferencesHelper().getUserName();
    var username = chatroomid.replaceAll(musername, "").replaceAll("_", "");
    var l = await DatabaseHelper().getUserInfo(username);
    Map p = l.docs[0].data() as Map;
    return p;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit(),
      child: BlocBuilder<RoomsCubit, RoomsState>(
        builder: (context, state) {
          if (state is RoomsInitial) {
            BlocProvider.of<RoomsCubit>(context).getRooms();
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Rooms"),
              actions: [_logOut(context)],
            ),
            body: _roomsList(context, state),
            floatingActionButton: _searchFab(context),
          );
        },
      ),
    );
  }

  _logOut(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(Icons.logout),
      ),
      onTap: () {
        AuthService().signOut().then((value) => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              )
            });
      },
    );
  }

  _searchFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchScreen()));
      },
      child: Icon(Icons.search),
    );
  }

  _roomsList(BuildContext context, RoomsState state) {
    if (state is RoomsLoaded) {
      return StreamBuilder(
          stream: state.stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return (snapshot.hasData)
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return FutureBuilder(
                        future: getUserInformation(ds.id),
                        builder: (context, AsyncSnapshot<Map> snapshot) {
                          return (snapshot.hasData)
                              ? _chatTile(
                                  context,
                                  snapshot.data!,
                                  ds["last_message"],
                                  ds["last_message_ts"].toDate().toString())
                              : Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      );
                    },
                  )
                : CircularProgressIndicator();
          });
    }
    return Container();
  }

  _chatTile(BuildContext context, Map user, String lm, String lmts) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatsScreen(
                      ds: user,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          child: Row(
            children: [
              Container(
                height: 56,
                margin: EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(user["imageURL"]),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user["name"],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  Text(lm),
                  Text(lmts)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
