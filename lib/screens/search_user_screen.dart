import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_notes/cubit/search_cubit.dart';
import 'package:fl_notes/screens/chat_screen.dart';
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
      create: (context) => SearchCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          actions: [],
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
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

  Widget _searchBar(BuildContext context, SearchState state) {
    return Container(
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            ((state is SearchLoading) || (state is SearchLoaded))
                ? InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.arrow_back),
                    ),
                    onTap: () {
                      usernameController.text = "";
                      BlocProvider.of<SearchCubit>(context).initial();
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
                  BlocProvider.of<SearchCubit>(context)
                      .getUsers(usernameController.text);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _userList(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return CircularProgressIndicator();
    }
    if (state is SearchLoaded) {
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChatsScreen(
                      ds: ds.data() as Map,
                    )));
      },
      child: Container(
        height: 72.0,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border(bottom: BorderSide(color: Colors.black26))),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
