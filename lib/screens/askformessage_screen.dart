import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_a_v/provider/randomUser_provider.dart';

class YourBottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Consumer<RandomUser>(
        builder: (context, value, child) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Text(
                '${value.randomUser!.name} Left Chatroom 😥',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Dont Worry',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle button 1 action
                      // For example, navigate to another screen
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => AnotherScreen()),
                      // );
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text('Go home'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button 2 action
                      // For example, perform a specific action
                      // or dismiss the bottom sheet
                      // Navigator.pop(context);
                    },
                    child: const Text('Send Message'),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
