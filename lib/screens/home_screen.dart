import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  int selectedBox = 3;
  List<String> images = [
    'assets/images/FEMALE.png',
    'assets/images/MALE.png',
    'assets/images/random.jpg'
  ];
  String selectedImage = 'assets/images/random.jpg';
  String? status = 'Automatic';
  List<String> dropdownItems = ['Automatic', 'Set as Away', 'Do not Disturb'];

  Future<void> _getData() async {
    isLoading = true;
    await Provider.of<AuthProvider>(context, listen: false).getUser();
    isLoading = false;
  }

  void _find(String myid) async {
    final randomProvider = Provider.of<RandomUser>(context, listen: false);
    await randomProvider
        .findRandomUser(myid, selectedBox)
        .then((value) => Navigator.pushNamed(context, '/chat'));
  }

  void _changeStatus() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .changeStatus(status!);
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final randomUser = Provider.of<RandomUser>(context, listen: true);
    return Consumer<AuthProvider>(
      builder: (context, authValue, child) {
        return Scaffold(
          drawer: const MyDrawer(),
          appBar: AppBar(
            title: const Text("Random A v"),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: !authValue.isLoading
                    ? Row(
                        children: [
                          // Drop down for user status
                          // DropdownButton(
                          //   // style: const TextStyle(color: Colors.white),
                          //   underline: Container(),
                          //   value: authValue.user.status,
                          //   items: dropdownItems.map((String item) {
                          //     return DropdownMenuItem<String>(
                          //       value: item,
                          //       child: Text(item),
                          //     );
                          //   }).toList(),
                          //   onChanged: (newValue) {
                          //     setState(() {
                          //       status = newValue;
                          //     });
                          //     _changeStatus();
                          //   },
                          // ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Rs: ${authValue.user.amount.toString()}'),
                        ],
                      )
                    : null,
              )
            ],
          ),
          body: authValue.isLoading == true
              ? const Center(
                  child: SpinKitChasingDots(
                    color: Colors.pink,
                    size: 50.0,
                  ),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Select the gender to chat with',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildSelectableBox(1, 'Female'),
                              buildSelectableBox(2, 'Male'),
                              buildSelectableBox(3, 'Random')
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/images/home.gif'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Start a text, Audio or Video chat with '),
                          const Text('Random Peoples'),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                style: ButtonStyle(
                                  // Customize the shadow color
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.red),
                                  // Customize the background color
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  // Customize the shape (circle in this example)
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.call_outlined),
                                visualDensity: VisualDensity.standard,
                                // highlightColor: Colors.pink,

                                // splashColor: Colors.pink,
                                tooltip: 'Audio Call',
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.pink),
                                  elevation:
                                      MaterialStateProperty.all<double>(4),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(
                                    Icons.video_call_rounded,
                                    // color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.message_outlined),
                                tooltip: 'Text',
                              ),
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: BottomAppBar(
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  constraints:
                                      const BoxConstraints(maxHeight: 100.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _find(authValue.user.id);
                                    },
                                    child: const Text('Start Chat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (randomUser.isLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black26,
                          child: const Center(
                            child: SpinKitChasingDots(
                              color: Colors.pink,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    if (randomUser.errorMessage != null)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black26,
                          child: Center(
                            child: Text(authValue.errorMessage!),
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget buildSelectableBox(int boxIndex, String type) {
    final isSelected = selectedBox == boxIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBox = boxIndex;
          selectedImage = images[boxIndex - 1];
        });
      },
      child: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? Colors.pink : Colors.white,
          border: Border.all(color: Colors.pink),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
                fontSize: 20, color: isSelected ? Colors.white : Colors.pink),
          ),
        ),
      ),
    );
  }
}
