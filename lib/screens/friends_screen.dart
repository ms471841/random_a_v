import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
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
