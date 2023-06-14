import 'package:flutter/material.dart';
import 'package:random_a_v/data/models/user.dart';
import 'package:random_a_v/services/auth.dart';
import 'package:random_a_v/services/database.dart';
import 'package:random_a_v/services/shared_prefrences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  late MyUser user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  final AuthService _authService = AuthService();
  final Database _database = Database();

// Signup user
  Future<void> signup(
      String name, DateTime dob, String photoUrl, String gender) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await _authService.signin(name, dob, gender, photoUrl).then((value) async {
      await Helper.saveUsernameSharedPreference(value.id);
      await Helper.saveUserloggedInSharedPreference(true);
      _isLoading = false;
      user = value;
      notifyListeners();
    });
  }

//get user profile

  Future<void> getUser() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();
    final userId = await Helper.getUsernameSharedPreference();
    print(userId);
    final value = await _database.getMyUserFromDatabase(userId!);
    user = value;
    _isLoading = false;
    notifyListeners();
  }

  //

  Future<void> addFriend(MyUser friendId) async {
    // _isLoading = true;
    _errorMessage = null;
    // notifyListeners();
    await _database.sendFriendRequest(user.id, friendId.id);

    // user = value;
    _isLoading = false;
    notifyListeners();
  }

  //chnage user status provider
  Future<void> changeStatus(String newstatus) async {
    await _database.changeStatus(newstatus, user.id);
    user = await _database.getMyUserFromDatabase(user.id);
    // _isLoading = false;
    notifyListeners();
  }
}
