import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_app/features/rules/widgets/rule_container.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/shared/repositories/user_data.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/styles.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  UserDetailsPageState createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  final UserDataRepository _userDataRepository = UserDataRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: _userDataRepository.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Profiel',
                        style: Styles.pageTitle,
                      ),
                      Container(height: 20),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              foregroundImage: ((snapshot.data?.image != null)
                                  ? MemoryImage(snapshot.data!.image!)
                                  : const AssetImage('assets/profile_default.jpg')) as ImageProvider<Object>,
                            ),
                            Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    ImagePicker()
                                        .pickImage(source: ImageSource.gallery)
                                        .then((value) async {
                                      if (value != null) {
                                        await _userDataRepository.setImage(
                                            await value.readAsBytes());
                                        setState(() {});
                                      }
                                    });
                                  },
                                  fillColor: AppColors.buttonColor,
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(height: 20),
                      TextFormField(
                        controller: TextEditingController(
                          text: snapshot.data!.firstname,
                        ),
                        decoration: Styles.textInputDecoration.copyWith(
                          labelText: 'Voornaam',
                        ),
                        style: Styles.textInput,
                        onChanged: (value) {
                          snapshot.data!.firstname = value;
                        },
                      ),
                      TextFormField(
                        controller: TextEditingController(
                          text: snapshot.data!.lastname,
                        ),
                        decoration: Styles.textInputDecoration.copyWith(
                          labelText: 'Achternaam',
                        ),
                        style: Styles.textInput,
                        onChanged: (value) {
                          snapshot.data!.lastname = value;
                        },
                      ),
                      TextFormField(
                        controller: TextEditingController(
                          text: snapshot.data!.age,
                        ),
                        decoration: Styles.textInputDecoration.copyWith(
                          labelText: 'Leeftijd',
                        ),
                        style: Styles.textInput,
                        onChanged: (value) {
                          snapshot.data!.age = value;
                        },
                      ),
                      DropdownButtonFormField(
                        value: snapshot.data!.major,
                        dropdownColor: const Color.fromARGB(135, 0, 0, 0),
                        decoration: Styles.textInputDecoration.copyWith(
                          labelText: 'Major',
                        ),
                        style: Styles.textInput,
                        items: const [
                          DropdownMenuItem(
                            value: 'Brass',
                            child: Text('Brass'),
                          ),
                          DropdownMenuItem(
                            value: 'Choir',
                            child: Text('Choir'),
                          ),
                          DropdownMenuItem(
                            value: 'Dance',
                            child: Text('Dance'),
                          ),
                          DropdownMenuItem(
                            value: 'MMS',
                            child: Text('MMS'),
                          ),
                          DropdownMenuItem(
                            value: 'Theatre',
                            child: Text('Theatre'),
                          ),
                        ],
                        onChanged: (String? value) {
                          snapshot.data!.major = value;
                        },
                      ),
                      DropdownButtonFormField(
                        value: snapshot.data!.minor,
                        dropdownColor: const Color.fromARGB(135, 0, 0, 0),
                        decoration: Styles.textInputDecoration.copyWith(
                          labelText: 'Minor',
                        ),
                        style: Styles.textInput,
                        items: const [
                          DropdownMenuItem(
                            value: 'Brass Class',
                            child: Text('Brass Class'),
                          ),
                          DropdownMenuItem(
                            value: 'Gospel',
                            child: Text('Gospel'),
                          ),
                          DropdownMenuItem(
                            value: 'Sport & Ministries',
                            child: Text('Sport & Ministries'),
                          ),
                          DropdownMenuItem(
                            value: 'Ritme',
                            child: Text('Ritme'),
                          ),
                          DropdownMenuItem(
                            value: 'Media',
                            child: Text('Media'),
                          ),
                          DropdownMenuItem(
                            value: 'Compositie',
                            child: Text('Compositie'),
                          ),
                        ],
                        onChanged: (String? value) {
                          snapshot.data!.minor = value;
                        },
                      ),
                      // save button
                      Container(height: 20),
                      ElevatedButton(
                        style: Styles.buttonStyle,
                        onPressed: () async {
                          await _userDataRepository.setUser(snapshot.data!);
                        },
                        child: const Text('Opslaan', style: Styles.buttonText),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
