import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_a_v/provider/randomUser_provider.dart';
import 'package:random_a_v/services/database.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // late Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  // Widget chatMessages() {
  //   return
  // }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": '1685096183378962',
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      Provider.of<RandomUser>(context, listen: false)
          .sendMessage(chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  _getchats() async {
    // Provider.of<RandomUser>(context, listen: false).getChatsProvider();
  }

  @override
  void initState() {
    // _getchats();
    super.initState();
  }

  Database database = Database();

  @override
  Widget build(BuildContext context) {
    final chatRoomId =
        Provider.of<RandomUser>(context, listen: false).chatRoomId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Chat'),
      ),
      body: Stack(
        children: [
          StreamBuilder<DataSnapshot>(
            stream: database.getChats(chatRoomId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Extract the chats data from the snapshot
                Map<dynamic, dynamic>? chatsData =
                    snapshot.data!.value as Map<dynamic, dynamic>?;
                // print('this is ${chatsData}');
                if (chatsData != null) {
                  // Process and display the chats data in your UI
                  // print('this is ${chatsData}');

                  return ListView.builder(
                    itemCount: chatsData.length,
                    itemBuilder: (context, index) {
                      // Build UI for each chat message
                      var chatMessage = chatsData[index];
                      print(index);
                      print(chatMessage);
                      print(chatsData);

                      return MessageTile(
                        message: chatMessage["message"] ?? '',
                        sendByMe: '1685096183378962' == chatMessage["sendBy"],
                      );
                    },
                  );
                } else {
                  // Handle the case when no chats data is available
                  return Text('No chats available.');
                }
              } else if (snapshot.hasError) {
                // Handle the error case
                return Text('Error: ${snapshot.error}');
              } else {
                // Show a loading indicator while waiting for data
                return CircularProgressIndicator();
              }
            },
          ),

          //  MessageTile(
          //                   message: ["message"] ?? '',
          //                   sendByMe:
          //                       '1685096183378962' == chatMessage["sendBy"],
          //                 );
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: const Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageEditingController,
                    // style: simpleTextStyle(),
                    decoration: const InputDecoration(
                        hintText: "Message ...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      addMessage();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight),
                          borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

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
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
