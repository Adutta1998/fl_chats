import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/cubit/rooms_cubit.dart';
import 'package:fl_notes/screens/chat_screen.dart';
import 'package:fl_notes/screens/signup_screen.dart';
import 'package:fl_notes/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("rooms"),
          actions: [
            InkWell(
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
            )
          ],
        ),
        body: BlocBuilder<RoomsCubit, RoomsState>(
          builder: (context, state) {
            return Column(
              children: [
                _searchBar(context, state),
                _userList(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context, RoomsState state) {
    return Container(
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            ((state is RoomsLoading) || (state is RoomsLoaded))
                ? InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.arrow_back),
                    ),
                    onTap: () {
                      usernameController.text = "";
                      BlocProvider.of<RoomsCubit>(context).initial();
                    },
                  )
                : Container(),
            Expanded(
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: "Search People..", border: InputBorder.none),
              ),
            ),
            InkWell(
              child: Icon(Icons.search_sharp),
              onTap: () {
                if (usernameController.text.length > 0) {
                  BlocProvider.of<RoomsCubit>(context)
                      .getUsers(usernameController.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _userList(BuildContext context, RoomsState state) {
    if (state is RoomsLoading) {
      return CircularProgressIndicator();
    }
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
                      return _userTile(ds, context);
                    },
                  )
                : CircularProgressIndicator();
          });
    }
    return Container();
  }

  Widget _userTile(DocumentSnapshot<Object?> ds, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatsScreen()));
      },
      child: Container(
        height: 64.0,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border(bottom: BorderSide(color: Colors.black26))),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: Image.network(ds["imageURL"])),
            SizedBox(
              width: 16.0,
            ),
            Text(ds["name"])
          ],
        ),
      ),
    );
  }
}
