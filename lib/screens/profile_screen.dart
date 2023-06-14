import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:random_a_v/common/constant.dart';

import '../provider/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController genderEditingController = TextEditingController();
  TextEditingController ageEditingController = TextEditingController();

  @override
  // final  userProvider = Provider.of<AuthProvider>(context);
  // User user = userProvider.user;

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context, listen: false);
    nameEditingController.text = authData.user.name;
    genderEditingController.text = authData.user.gender;
    ageEditingController.text = authData.user.dob;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white, width: 6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.network(
                          authData.user.photoUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    authData.user.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameEditingController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: genderEditingController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: ageEditingController,
                          ),
                          const SizedBox(height: 40.0),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController genderEditingController = TextEditingController();
  TextEditingController ageEditingController = TextEditingController();

  late String _gender = 'Male', _name;
  late DateTime selectedDate;

  final _formKey = GlobalKey<FormState>();
  String selectedAvatar = maleAvatar;
  final dateController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  void selectGender(String gender) {
    setState(() {
      _gender = gender;

      // Update the avatar
      if (_gender == 'Male') {
        selectedAvatar = maleAvatar;
      } else if (_gender == 'Female') {
        selectedAvatar = femaleAvatar;
      }
    });
  }

  void _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.signup(_name, selectedDate, selectedAvatar, _gender).then(
        (value) {
          Navigator.pushReplacementNamed(context, '/home');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final cardHeight = screenHeight * 0.7;
    final cardWidth = screenWidth * 0.8;

    final authData = Provider.of<AuthProvider>(context, listen: false);
    nameEditingController.text = authData.user.name;
    genderEditingController.text = authData.user.gender;
    ageEditingController.text = authData.user.dob;
    return Consumer<AuthProvider>(
      builder: (_, authValue, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: cardHeight,
                  width: cardWidth,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(selectedAvatar),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: nameEditingController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your name'
                                  : null,
                              onSaved: (value) => _name = value!,
                            ),
                            DropdownButtonFormField<String>(
                              value: _gender,
                              onChanged: (newValue) {
                                selectGender(newValue!);
                              },
                              items: <String>[
                                'Male',
                                'Female'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                              ),
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date of Birth',
                              ),
                              onTap: () async {
                                var date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now());

                                if (date != null) {
                                  setState(() {
                                    selectedDate = date;
                                    dateController.text =
                                        DateFormat('MM/dd/yyyy').format(date);
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 40.0),
                            ElevatedButton(
                              onPressed: _submit,
                              child: const Text('Update'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                ),
            ],
          ),
        );
      },
    );
  }
}
