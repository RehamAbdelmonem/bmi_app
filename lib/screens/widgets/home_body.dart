import 'package:bmi_app/screens/edit_screen.dart';
import 'package:bmi_app/screens/sign_in.dart';
import 'package:bmi_app/services/auth.dart';
import 'package:bmi_app/services/cloud_firestore_service.dart';
import 'package:bmi_app/utils/functions/calculate_bmi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBodyWidget extends StatefulWidget {
  const HomeBodyWidget({super.key});

  @override
  State<HomeBodyWidget> createState() => _HomeBodyWidgetState();
}

class _HomeBodyWidgetState extends State<HomeBodyWidget> {
  CloudFirestoreService? service;
  List<Map<String, dynamic>> userDataList = [];

  @override
  void initState() {
    service = CloudFirestoreService(FirebaseFirestore.instance);
    service?.streamUserData().listen((List<Map<String, dynamic>> userData) {
      setState(() {
        userDataList.clear();
        userDataList.addAll(userData);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Model>(context);

    final heightController = TextEditingController();
    final weightController = TextEditingController();
    final ageController = TextEditingController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: heightController,
              decoration: const InputDecoration(hintText: 'Height'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(hintText: 'Weight'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(hintText: 'Age'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final height = heightController.text.trim();
                final weight = weightController.text.trim();
                final age = ageController.text.trim();
                model.calculateBmi(double.parse(weight), double.parse(height));

                service?.add({
                  'height': height,
                  'weight': weight,
                  'age': age,
                  'bmi': model.bmi,
                  'bmiStatus':model.status,
                });

                heightController.clear();
                weightController.clear();
                ageController.clear();
              },
              child: const Text('Submit'),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Result:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: service?.streamUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> userDataList = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            userDataList.length > 10 ? 10 : userDataList.length,
                        itemBuilder: (context, index) {
                          final userData = userDataList[index];
                          return ListTile(
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Height: ${userData['height']}'),
                                Text('Weight: ${userData['weight']}'),
                                Text('Age: ${userData['age']}'),
                                Text('BMI: ${userData['bmi']}'),
                                Text('BMI Status: ${userData['bmiStatus']}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditScreen(
                                            documentId: userData['id'],
                                            userData: userData),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Deletion"),
                                          content: const Text(
                                              "Are you sure you want to delete this record?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                service?.delete(userData['id']);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            ElevatedButton(
              onPressed: () {
                Auth(FirebaseAuth.instance).signOut().then((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                }).catchError((error) {
                  print("Error signing out: $error");
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}


