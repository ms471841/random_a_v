import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_a_v/provider/auth_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(authData.user.name),
            accountEmail:
                Text('Balance : Rs ${authData.user.amount.toString()}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(authData.user.photoUrl),
            ),
            onDetailsPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            margin: const EdgeInsets.only(bottom: 0),
          ),
          // Add more widgets here if needed

          DrawerItem(),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  DrawerItem({super.key});
  final items = [
    {
      'title': 'Find Friends',
      'icon': Icons.people_outlined,
      'route': '/findfriend'
    },
    {'title': 'Mail Box', 'icon': Icons.mail_outlined, 'route': '/mailbox'},
    {'title': 'Friends', 'icon': Icons.person_3_outlined, 'route': '/friends'},
    {'title': 'Settings', 'icon': Icons.settings, 'route': '/settings'},
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

        return ListTile(
          minVerticalPadding: 0,
          leading: Icon(item['icon'] as IconData?),
          title: Text(item['title'] as String),
          onTap: () async {
            // Handle item tap here
            //  await FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, item['route'] as String);
          },
        );
      },
    );
  }
}
