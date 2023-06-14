import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import '../data/models/user.dart';

class Database {
  //save user details on sign up
  Future<void> saveMyUserToDatabase(MyUser user) async {
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(user.id);
    final userMap = user.toDatabaseMap();
    await userRef.set(userMap);
  }

//get logged in user
  Future<MyUser> getMyUserFromDatabase(String userId) async {
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(userId);
    final DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      return MyUser.fromDatabaseMap(data);
    } else {
      throw Exception('User not found in the database.');
    }
  }

//serach friends

  Future<List<MyUser>> fetchUsers({String? searchQuery}) async {
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users');

    DataSnapshot snapshot = await usersRef.get();
    List<MyUser> users = [];

    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
      usersData.forEach((key, value) {
        MyUser user = MyUser.fromDatabaseMap(value);

        users.add(user);
      });
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      users = users
          .where((user) =>
              user.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return users;
  }

//send friends request

  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    final DatabaseReference requestsRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(receiverId)
        .child('friend_requests');

    String requestId = requestsRef.push().key!;
    FriendRequest request = FriendRequest(
      id: requestId,
      senderId: senderId,
      receiverId: receiverId,
      accepted: false,
    );

    await requestsRef.child(requestId).set(request.toJson());
  }

//accept friends request
  Future<void> acceptFriendRequest(FriendRequest request) async {
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users');

    // Update the sender's friend list
    await userRef
        .child(request.senderId)
        .child('friends')
        .push()
        .set(request.receiverId);

    // Update the receiver's friend list
    await userRef
        .child(request.receiverId)
        .child('friends')
        .push()
        .set(request.senderId);

    // Update the friend request status
    // request.accepted = true;
    await FirebaseDatabase.instance
        .ref()
        .child('friend_requests')
        .child(request.id)
        .set(request.toJson());
  }

// find random user

  Future<MyUser?> fetchRandomUser(int selectedIndex) async {
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users');

    // DataSnapshot snapshot = await usersRef.equalTo();
    DataSnapshot snapshot =
        await usersRef.orderByChild("status").equalTo("active").get();

    List<MyUser> users = [];
    String queryString = '';
    if (selectedIndex == 0) {
      queryString = 'Female';
    } else if (selectedIndex == 1) {
      queryString = 'Male';
    }
    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
      if (queryString != '') {
        usersData.forEach(
          (key, value) {
            if (value['gender'] == queryString) {
              MyUser user = MyUser(
                id: key,
                name: value['name'],
                gender: value['gender'],
                dob: '',
                photoUrl: '',
              );
              users.add(user);
            }
          },
        );
      } else {
        usersData.forEach((key, value) {
          MyUser user = MyUser(
            id: key,
            name: value['name'],
            gender: value['gender'],
            dob: '',
            photoUrl: '',
          );
          users.add(user);
        });
      }
    }

    // Fetch a random user
    if (users.isNotEmpty) {
      final random = Random();
      int index = random.nextInt(users.length);
      MyUser randomUser = users[index];
      return randomUser;
    }

    return null; // Return null if no users found
  }

// add chat room
  Future<String> addChatRoom(String myid, String userid) async {
    List<String> users = [myid, userid];

    String chatRoomId = getChatRoomId(myid, userid);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('chatrooms').child(chatRoomId);
    await userRef.set(chatRoom);
    return chatRoomId;
  }

//get the chats

  Stream<DataSnapshot> getChats(String chatRoomId) {
    final DatabaseReference chatRef = FirebaseDatabase.instance
        .ref()
        .child('chatrooms')
        .child(chatRoomId)
        .child('chats');
    Query query = chatRef.orderByChild('time');

    return query.onValue.map((event) => event.snapshot);
  }

  // add the meesage
  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    DatabaseReference chatRef = FirebaseDatabase.instance
        .ref()
        .child('chatrooms')
        .child(chatRoomId)
        .child("chats");

    final newMessageRef = chatRef.push();
    await newMessageRef.set(chatMessageData);
  }

// Function to update the user's presence status in the chatroom
  void updateUserPresence(bool isPresent, String chatRoomId) async {
    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chatrooms').child(chatRoomId);
    // final presence = {'' : ''};
    await chatRef.update({'ispresent': isPresent});
  }

// Declare a global variable for the listener subscription
  StreamSubscription<DatabaseEvent>? chatroomListenerSubscription;

// Function to listen for chatroom updates and handle user presence changes
  Future<bool> listenForChatroomUpdates(String chatRoomId) async {
    DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chatrooms').child(chatRoomId);

    chatroomListenerSubscription = chatRef.onChildChanged.listen((event) {
      final isPresence = event.snapshot.value;
      if (isPresence == false) {
        // return false;
      }
    });
    return true;
  }

// Function to stop the chatroom listener
  void stopChatroomListener() {
    chatroomListenerSubscription?.cancel();
  }

  // update user status
  Future<void> changeStatus(String status, String id) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(id);
    await userRef.update({'status': status});
  }
}

// create chatroom id
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
