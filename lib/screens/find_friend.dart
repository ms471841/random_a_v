import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_a_v/data/models/user.dart';
import 'package:random_a_v/provider/auth_provider.dart';
import 'package:random_a_v/services/database.dart';

class FindFriendScreen extends StatefulWidget {
  const FindFriendScreen({super.key});

  @override
  _FindFriendScreenState createState() => _FindFriendScreenState();
}

class _FindFriendScreenState extends State<FindFriendScreen> {
  List<MyUser> users = [];
  String searchQuery = '';
  Database database = Database();
  String status = 'Add';

  void searchUsers(String query) {
    setState(() {
      searchQuery = query;
    });
    database.fetchUsers(searchQuery: query).then((filteredUsers) {
      setState(() {
        users = filteredUsers;
      });
    });
  }

  Future<void> addFriendToUser(MyUser user) async {
    await Provider.of<AuthProvider>(context, listen: false).addFriend(user);
    // Show a success message or update the UI as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Friends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: searchUsers,
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                MyUser user = users[index];
                final isRequested = user.friendRequests
                    .where((element) => element.senderId == '1686378166472932')
                    .toList();
                print(user.friendRequests);
                // print(isRequested);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    title: Text(user.name),
                    trailing: MaterialButton(
                      height: 25,
                      color: Colors.pink,
                      onPressed: () {
                        addFriendToUser(user);
                        setState(() {
                          // status = 'Requested';
                        });
                      },
                      child: Text(
                        status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
