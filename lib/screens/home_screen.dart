import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_a_v/provider/auth_provider.dart';
import 'package:random_a_v/provider/randomUser_provider.dart';
import 'package:random_a_v/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  Future<void> _getData() async {
    isLoading = true;
    await Provider.of<AuthProvider>(context, listen: false).getUser();
    isLoading = false;
  }

  void _find(String myid) async {
    final randomProvider = Provider.of<RandomUser>(context, listen: false);
    await randomProvider
        .findRandomUser(myid)
        .then((value) => Navigator.pushNamed(context, '/chat'));
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authValue, child) {
        return Scaffold(
          drawer: const MyDrawer(),
          appBar: AppBar(
            title: const Text("Random Audio Video"),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: authValue.isLoading
                    ? const Text('')
                    : Text(authValue.user.amount.toString()),
              )
            ],
          ),
          body: Center(
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: () => _find(authValue.user.id),
                  child: Text('Random'),
                ),
                if (authValue.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                if (authValue.errorMessage != null)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      child: Center(
                        child: Text(authValue.errorMessage!),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}


  //  Column(
  //       children: [
  //         ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/findfriend');
  //             },
  //             child: Text('find friends')),
  //         ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/friendrequest');
  //             },
  //             child: Text('Friend request')),
  //       ],
  //     ),