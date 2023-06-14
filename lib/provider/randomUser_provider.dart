import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_a_v/data/models/user.dart';
import 'package:random_a_v/provider/auth_provider.dart';

import '../services/auth.dart';
import '../services/database.dart';

class RandomUser with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _chatRoomId;
  bool? _isPresence;
  MyUser? randomUser;
  DataSnapshot? snapshot;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get chatRoomId => _chatRoomId;
  bool? get isPresence => _isPresence;

  final AuthService _authService = AuthService();
  final Database _database = Database();

  //
  Future<void> findRandomUser(String myid, int selectedIndex) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await _database.changeStatus('active', myid);
    await _database.fetchRandomUser(selectedIndex).then((value) async {
      if (value != null) {
        randomUser = value;
        // print(randomUser);

        _chatRoomId = await _database.addChatRoom(myid, randomUser!.id);
        await _database.changeStatus('busy', myid);

        _isLoading = false;
        notifyListeners();
      } else {
        await _database.changeStatus('not available', myid);

        randomUser = null;
        _isLoading = false;
        _errorMessage = 'No user Find';
        notifyListeners();
      }
    });
  }

  // Future<void> getChatsProvider() async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   final value = await _database.getChats(_chatRoomId!);
  //   snapshot = value as DataSnapshot?;
  //   _isLoading = false;
  //   notifyListeners();
  // }

//update user presence

  Future<void> updateUserPresence(isPresent) async {
    _database.updateUserPresence(isPresent, chatRoomId!);
  }

//listen for the chatroom presence
  Future<void> listenforChanges() async {
    _isPresence = await _database.listenForChatroomUpdates(chatRoomId!);
    notifyListeners();
  }

// send message
  Future<void> sendMessage(chatMessageData) async {
    // _isLoading = true;
    // _errorMessage = null;
    _database.addMessage(_chatRoomId!, chatMessageData).then((value) {
      _isLoading = false;
      notifyListeners();
    });
  }
}
