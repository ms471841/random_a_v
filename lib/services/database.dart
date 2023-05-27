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

  // Future saveUserAvatar(String photoUrl) async {
  //   final byteData = await rootBundle.load(photoUrl);
  //   final tempDir = await getTemporaryDirectory();
  //   final tempPath = path.join(tempDir.path, 'male.jpg');
  //   final file = File(tempPath);
  //   await file.writeAsBytes(byteData.buffer.asUint8List());

  //   final Reference storageRef =
  //       FirebaseStorage.instance.ref().child('avatars/');
  //   await storageRef.putFile(file);
  //   final String downloadUrl = await storageRef.getDownloadURL();
  //   return downloadUrl;
  // }

//get logged in user
  Future<MyUser> getMyUserFromDatabase(String userId) async {
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(userId);
    final DataSnapshot snapshot = await userRef.get();

    if (snapshot.exists) {
      return MyUser.fromDatabaseMap(snapshot);
    } else {
      throw Exception('User not found in the database.');
    }
  }

// add friend
  // Future<void> addFriend(MyUser user, MyUser friend) async {
  //   final DatabaseReference userRef =
  //       FirebaseDatabase.instance.ref().child('users').child(user.id);

  //   user.friends.add(friend);
  //   await userRef.child('friends').set(user.friends);
  // }

// Find users by name
  // Future<List<MyUser>> fetchUsers({String? searchQuery}) async {
  //   final DatabaseReference usersRef =
  //       FirebaseDatabase.instance.ref().child('users');

  //   DataSnapshot snapshot = await usersRef.get();
  //   List<MyUser> users = [];

  //   if (snapshot.value is Map) {
  //     Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
  //     usersData.forEach((key, value) {
  //       MyUser user = MyUser(
  //         id: value['id'],
  //         name: value['name'],
  //         dob: value['dob'],
  //         photoUrl: value['photoUrl'],
  //         gender: value['gender'],
  //         friends: List<MyUser>.from(value['friends'] ?? []),
  //       );
  //       users.add(user);
  //     });
  //   }

  //   if (searchQuery != null && searchQuery.isNotEmpty) {
  //     users = users
  //         .where((user) =>
  //             user.name.toLowerCase().contains(searchQuery.toLowerCase()))
  //         .toList();
  //   }

  //   return users;
  // }

  // Future<List<MyUser>> fetchUsers({String? searchQuery}) async {
  //   final DatabaseReference usersRef =
  //       FirebaseDatabase.instance.ref().child('users');

  //   DataSnapshot snapshot = await usersRef.get();
  //   List<MyUser> users = [];

  //   if (snapshot.value is Map) {
  //     Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
  //     usersData.forEach((key, value) {
  //       List<String>? friends = value['friends'] != null
  //           ? List<String>.from(value['friends'])
  //           : null;
  //       List<FriendRequest>? friendRequests = value['friendRequests'] != null
  //           ? (value['friendRequests'] as List<dynamic>)
  //               .map((req) => FriendRequest(
  //                     id: req['id'] as String,
  //                     senderId: req['senderId'],
  //                     receiverId: req['receiverId'],
  //                     accepted: req['accepted'],
  //                   ))
  //               .toList()
  //           : null;

  //       MyUser user = MyUser(
  //         id: key,
  //         name: value['name'],
  //         gender: value['gender'],
  //         dob: value['dob'],
  //         photoUrl: value['photoUrl'],
  //         friends: friends,
  //         friendRequests: friendRequests,
  //       );
  //       users.add(user);
  //     });
  //   }

  //   if (searchQuery != null && searchQuery.isNotEmpty) {
  //     users = users
  //         .where((user) =>
  //             user.name.toLowerCase().contains(searchQuery.toLowerCase()))
  //         .toList();
  //   }

  //   return users;
  // }
  Future<List<MyUser>> fetchUsers({String? searchQuery}) async {
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users');

    DataSnapshot snapshot = await usersRef.get();
    List<MyUser> users = [];

    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
      usersData.forEach((key, value) {
        // List<MyUser>? friends = value['friends'] != null
        //     ? List<MyUser>.from(value['friends'])
        //     : null;
        // List<FriendRequest>? friendRequests = value['friendRequests'] != null
        //     ? (value['friendRequests'] as List<dynamic>)
        //         .map((req) => FriendRequest(
        //               id: req['id'],
        //               senderId: req['senderId'],
        //               receiverId: req['receiverId'],
        //               accepted: req['accepted'],
        //             ))
        //         .toList()
        //     : null;

        MyUser user = MyUser(
          id: value['id'],
          name: value['name'],
          gender: value['gender'],
          dob: value['dob'],
          photoUrl: value['photoUrl'],
          // friends: friends,
          // friendRequests: friendRequests,
        );
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
//

  Future<void> sendFriendRequest(String senderId, String receiverId) async {
    final DatabaseReference requestsRef =
        FirebaseDatabase.instance.ref().child('friend_requests');

    String requestId = requestsRef.push().key!;
    FriendRequest request = FriendRequest(
      id: requestId,
      senderId: senderId,
      receiverId: receiverId,
      accepted: false,
    );

    await requestsRef.child(requestId).set(request.toJson());
  }

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

//   Future<void> sendFriendRequest(String senderId, String receiverId) async {
//     final DatabaseReference requestsRef =
//         FirebaseDatabase.instance.ref().child('friend_requests');

//     String requestId = requestsRef.push().key!;
//     FriendRequest request = FriendRequest(
//       id: requestId,
//       senderId: senderId,
//       receiverId: receiverId,
//       accepted: false,
//     );

//     await requestsRef.child(requestId).set(request.toJson());
//     // Add the request to the receiver's friendRequests list
//     final DatabaseReference receiverRef =
//         FirebaseDatabase.instance.ref().child('users').child(receiverId);
//     DataSnapshot snapshot = await receiverRef.get();

//     if (snapshot.value != null) {
//       Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;
//       List<String>? friendRequests = userData['friendRequests'] != null
//           ? List<String>.from(userData['friendRequests'])
//           : [];
//       friendRequests.add(requestId);

//       await receiverRef.child('friendRequests').set(friendRequests);
//     }
//   }

// //
//   Future<void> acceptFriendRequest(FriendRequest request) async {
//     final DatabaseReference userRef =
//         FirebaseDatabase.instance.ref().child('users');

//     // Update the sender's friend list
//     await userRef
//         .child(request.senderId)
//         .child('friends')
//         .push()
//         .set(request.receiverId);

//     // Update the receiver's friend list
//     await userRef
//         .child(request.receiverId)
//         .child('friends')
//         .push()
//         .set(request.senderId);

//     // Update the friend request status
//     //  request.accepted = true;
//     await FirebaseDatabase.instance
//         .ref()
//         .child('friend_requests')
//         .child(request.id)
//         .set(request.toJson());
//   }

// find random user

  Future<MyUser?> fetchRandomUser() async {
    final DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('users');

    DataSnapshot snapshot = await usersRef.get();
    List<MyUser> users = [];

    if (snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> usersData = snapshot.value as Map<dynamic, dynamic>;
      usersData.forEach((key, value) {
        // List<String>? friends = value['friends'] != null
        //     ? List<String>.from(value['friends'])
        //     : null;
        // List<FriendRequest>? friendRequests = value['friendRequests'] != null
        //     ? (value['friendRequests'] as List<dynamic>)
        //         .map((req) => FriendRequest(
        //               id: req['id'],
        //               senderId: req['senderId'],
        //               receiverId: req['receiverId'],
        //               accepted: req['accepted'],
        //             ))
        //         .toList()
        //     : null;

        MyUser user = MyUser(
          id: key,
          name: value['name'],
          gender: value['gender'],
          // friends: friends,
          // friendRequests: friendRequests,
          dob: '',
          photoUrl: '',
        );
        users.add(user);
      });
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

//

  // getchats(String chatRoomId) async {
  //   final DatabaseReference chatRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('chatrooms')
  //       .child(chatRoomId)
  //       .child('chats');
  //   DataSnapshot snapshot = await chatRef.get();
  //   return snapshot;
  // }
  Stream<DataSnapshot> getChats(String chatRoomId) {
    final DatabaseReference chatRef = FirebaseDatabase.instance
        .ref()
        .child('chatrooms')
        .child(chatRoomId)
        .child('chats');

    return chatRef.onValue.map((event) => event.snapshot);
  }

  //
  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    DatabaseReference chatRef = FirebaseDatabase.instance
        .ref()
        .child('chatrooms')
        .child(chatRoomId)
        .child("chats");

    final newMessageRef = chatRef.push();
    await newMessageRef.set(chatMessageData);
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
