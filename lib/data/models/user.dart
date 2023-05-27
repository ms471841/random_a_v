import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

class MyUser extends Equatable {
  final String id;
  final String name;
  final String dob;
  final String photoUrl;
  final String gender;
  final int amount;
  final List<MyUser> friends;
  final List<MyUser> friendRequests;

  const MyUser({
    required this.id,
    required this.name,
    required this.dob,
    required this.photoUrl,
    required this.gender,
    this.amount = 0,
    this.friends = const [],
    this.friendRequests = const [],
  });

  factory MyUser.fromDatabaseMap(DataSnapshot doc) {
    final data = doc.value as Map<dynamic, dynamic>;

    final friendData = data['friends'] as List<dynamic>?;
    final requestorData = data['friendRequests'] as List<dynamic>?;

    return MyUser(
      id: data['id'],
      name: data['name'],
      dob: data['dob'],
      photoUrl: data['photoUrl'],
      gender: data['gender'],
      amount: data['amount'],
      friends: friendData != null
          ? List<MyUser>.from(
              friendData.map((friend) => MyUser.fromDatabaseMap(friend)))
          : [],
      friendRequests: requestorData != null
          ? List<MyUser>.from(requestorData
              .map((requestor) => MyUser.fromDatabaseMap(requestor)))
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
      'friends': friends.map((friend) => friend.toDatabaseMap()).toList(),
      'friendRequests':
          friendRequests.map((requestor) => requestor.toDatabaseMap()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [id, name, dob, photoUrl, gender, friends, friendRequests];
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
