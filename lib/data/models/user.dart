import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

class MyUser extends Equatable {
  final String id;
  final String name;
  final String dob;
  final String photoUrl;
  final String gender;
  final int amount;
  final String status;
  final List<MyUser> friends;
  final List<FriendRequest> friendRequests;

  const MyUser({
    required this.id,
    required this.name,
    required this.dob,
    required this.photoUrl,
    required this.gender,
    this.status = 'Active',
    this.amount = 0,
    this.friends = const [],
    this.friendRequests = const [],
  });

  factory MyUser.fromDatabaseMap(data) {
    // final data = doc.value as Map<dynamic, dynamic>;

    final friendData = data['friends'] as List<dynamic>?;
    // final requestorData = data['friend_requests'] as List<dynamic>?;
    final requestorData = data['friend_requests'];
    List<dynamic>? requestorList;

    if (requestorData is List<dynamic>) {
      requestorList = requestorData;
    }
    print('request ${requestorList}');
    return MyUser(
      id: data['id'],
      name: data['name'],
      dob: data['dob'],
      photoUrl: data['photoUrl'],
      gender: data['gender'],
      amount: data['amount'],
      status: data['status'] ?? '',
      // friends: friendData != null
      //     ? List<MyUser>.from(
      //         friendData.map((friend) => MyUser.fromDatabaseMap(friend)))
      //     : [],
      // friendRequests: requestorData != null
      //     ? List<FriendRequest>.from(requestorData
      //         .map((requestor) => FriendRequest.fromJson(requestor)))
      //     : [],
      friends: friendData != null
          ? List<MyUser>.from(
              friendData.map((friend) => MyUser.fromDatabaseMap(friend)))
          : [],
      friendRequests: requestorList != null
          ? List<FriendRequest>.from(requestorList
              .map((requestor) => FriendRequest.fromJson(requestor)))
          : [],
    );
  }

  Map<String, dynamic> toDatabaseMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'photoUrl': photoUrl,
      'gender': gender,
      'amount': amount,
      'status': status,
      'friends': friends.map((friend) => friend.toDatabaseMap()).toList(),
      // 'friendRequests':
      // friendRequests.map((requestor) => requestor.toDatabaseMap()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [id, name, dob, photoUrl, gender, status, friends, friendRequests];
}

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final bool accepted;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.accepted,
  });
  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    print('json ${json}');
    return FriendRequest(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      accepted: json['accepted'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'accepted': accepted,
    };
  }
}
