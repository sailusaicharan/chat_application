import 'package:chat_application/api/apis.dart';
import 'package:chat_application/main.dart';
import 'package:chat_application/models/chat_user.dart';
import 'package:chat_application/screens/profile_screen.dart';
import 'package:chat_application/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
      onWillPop: () { 
        if(_isSearching) {
          setState(() {
            _isSearching = !_isSearching;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
        
       },
      child: Scaffold(
        // app bar
        appBar: AppBar(
          leading: const Icon(CupertinoIcons.home),
          title: _isSearching
              ? TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Name, Email,....'),
                  autofocus: true,
                  style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                  // When search text changes then updates search list
                  onChanged: (val) {
                    // search logic
                    _searchList.clear();
      
                    for (var i in _list) {
                      if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                          i.email.toLowerCase().contains(val.toLowerCase())) {
                        _searchList.add(i);
                      }
                      setState(() {
                        _searchList;
                      });
                    }
                  },
                )
              : const Text('We Chat'),
          actions: [
            //search user button
            IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search)),
      
            //more features button
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: Apis.me)));
                },
                icon: const Icon(Icons.more_vert)),
          ],
        ),
        //floating action to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () async {
              await Apis.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: const Icon(Icons.add_comment_rounded),
          ),
        ),
      
        //body
        body: StreamBuilder(
          stream: Apis.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //if data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
      
              //if some or all data is located then show it
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
      
                if (_list.isNotEmpty) {
                  return ListView.builder(
                      itemCount: _isSearching ? _searchList.length : _list.length,
                      padding: EdgeInsets.only(top: mq.height * .01),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user:
                                _isSearching ? _searchList[index] : _list[index]);
                        // return Text('Name: ${list[index]}');
                      });
                } else {
                  return const Center(
                    child: Text(
                      'No Connection Found !',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
            }
          },
        ),
      ),
    ));
  }
}
