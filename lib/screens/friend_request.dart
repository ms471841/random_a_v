import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_a_v/data/models/user.dart';
import 'package:random_a_v/provider/auth_provider.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List<FriendRequest> friendRequests = currentUser.friendRequests ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: Consumer<AuthProvider>(
        builder: (_, authvalue, child) {
          return ListView.builder(
            itemCount: authvalue.user.friendRequests.length,
            itemBuilder: (context, index) {
              // FriendRequest request = authvalue.user.![index];
              return ListTile(
                //   title: Text('Friend Request from ${request.senderId}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // acceptFriendRequest(request);
                      },
                      child: Text('Accept'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle decline or delete friend request
                      },
                      child: Text('Decline'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
