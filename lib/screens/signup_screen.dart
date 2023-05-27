import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:random_a_v/common/constant.dart';
import 'package:random_a_v/provider/auth_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
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
    return Consumer<AuthProvider>(
      builder: (_, authValue, child) {
        return Material(
          child: Stack(
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
                              child: const Text('sign up'),
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
