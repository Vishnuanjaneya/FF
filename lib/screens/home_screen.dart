import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fireflut/api/apis.dart';

import '../models/chat_user.dart';
import '../widgets/chat_card_user.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  // Added _isDarkMode variable
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapped outside text field
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: const Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name, Email,...'),
                      autofocus: true,
                      style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: (val) {
                        _searchList.clear();
                        for (var i in _list) {
                          if (i.name.contains(val.toLowerCase()) ||
                              i.email.contains(val.toLowerCase())) {
                            _searchList.add(i);
                          }
                        }
                        setState(() {
                          _searchList;
                        });
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text(
                        '🔥Chats💧',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled
                      : Icons.search),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                user: APIs.me,
                              )), // Corrected ProfileScreen
                    );
                  },
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    _toggleTheme();
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                try {
                  await APIs.auth.signOut();
                  await GoogleSignIn().signOut();
                } catch (e) {
                  print("Error signing out: $e");
                }
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
            body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Show enlarged profile picture here
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: CachedNetworkImage(
                                    imageUrl: _isSearching
                                        ? _searchList[index].image
                                        : _list[index].image,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              );
                            },
                            child: ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "No Connections Found!",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
