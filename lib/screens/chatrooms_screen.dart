import 'package:fl_notes/cubit/rooms_cubit.dart';
import 'package:fl_notes/screens/signup_screen.dart';
import 'package:fl_notes/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRooms extends StatelessWidget {
  const ChatRooms({Key? key}) : super(key: key);

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
                (state is RoomsLoading)
                    ? CircularProgressIndicator()
                    : Container()
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
            (state is RoomsLoading)
                ? InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.arrow_back),
                    ),
                    onTap: () {
                      BlocProvider.of<RoomsCubit>(context).initial();
                    },
                  )
                : Container(),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search People..", border: InputBorder.none),
              ),
            ),
            InkWell(
              child: Icon(Icons.search_sharp),
              onTap: () {
                BlocProvider.of<RoomsCubit>(context).loading();
              },
            )
          ],
        ),
      ),
    );
  }
}
