import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
//project imports
import 'package:random_a_v/provider/auth_provider.dart';
import 'package:random_a_v/provider/randomUser_provider.dart';
import 'package:random_a_v/screens/askformessage_screen.dart';
import 'package:random_a_v/services/database.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageEditingController = TextEditingController();
  // ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  ScrollController scrollController = ScrollController();

  addMessage() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": authProvider.user.id,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      Provider.of<RandomUser>(context, listen: false)
          .sendMessage(chatMessageMap);

      setState(() {
        messageEditingController.clear();
      });
    }
  }

  StreamSubscription<DatabaseEvent>? chatroomListenerSubscription;

  Future<void> listenForChatroomUpdates(String chatRoomId) async {
    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chatrooms').child(chatRoomId);

    chatroomListenerSubscription = chatRef.onChildChanged.listen((event) {
      final isPresence = event.snapshot.value;
      if (isPresence == false) {
        showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: false,
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
            return YourBottomSheetWidget();
          },
        );
      }
    });
  }

  Database database = Database();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final randomProvider = Provider.of<RandomUser>(context, listen: false);
    // Provider.of<RandomUser>(context, listen: false).listenforChanges();
    final chatRoomId = randomProvider.chatRoomId;
    randomProvider.updateUserPresence(true);
    listenForChatroomUpdates(chatRoomId!);

    scrollController.addListener(() {
      focusNode.unfocus();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollController.animateTo(
    //     scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeOut,
    //   );
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    database.stopChatroomListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomId =
        Provider.of<RandomUser>(context, listen: false).chatRoomId;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        // Show a dialog with a warning message
        bool confirmExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Warning'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context)
                    .pop(false), // Stay on the current screen
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<RandomUser>(context, listen: false)
                      .updateUserPresence(false);
                  Navigator.of(context).pop(true); // Allow navigation back
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );

        // Return the decision whether to allow navigation back or not
        return confirmExit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Random Chat'),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                )
              ],
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Flexible(
                  child: StreamBuilder<DataSnapshot>(
                    stream: database.getChats(chatRoomId!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<dynamic, dynamic>? chatsData =
                            snapshot.data!.value as Map<dynamic, dynamic>?;
                        List<dynamic>? chats = [];
                        if (chatsData != null) {
                          chatsData.forEach((key, value) {
                            chats.add(value);
                          });

                          return ListView.builder(
                            controller: scrollController,
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              var chatMessage = chats[index];

                              return MessageTile(
                                message: chatMessage['message'],
                                sendByMe: authProvider.user.id ==
                                    chatMessage["sendBy"],
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('No chats available.'),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return const Center(
                          child: SpinKitChasingDots(
                            color: Colors.pink,
                            size: 50.0,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomAppBar(
                    elevation: 10.0,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 100.0),
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 24, vertical: 24),
                      // color: Color.fromARGB(255, 196, 187, 187),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: () {}
                              // showPhotoOptions(viewModel, user),
                              ),
                          Flexible(
                            child: TextField(
                              controller: messageEditingController,
                              // style: simpleTextStyle(),
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .color,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                messageEditingController.text.isNotEmpty
                                    ? addMessage()
                                    : null,
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const MessageTile({super.key, required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
