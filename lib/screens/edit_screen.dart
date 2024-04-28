import 'package:bmi_app/screens/widgets/edit_screen_body.dart';
import 'package:bmi_app/utils/functions/calculate_bmi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatelessWidget {
  final String documentId;
  final Map<String, dynamic> userData;
  const EditScreen(
      {super.key, required this.documentId, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Model(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Record'),
          ),
          body: EditBody(documentId: userData['id'], userData: userData),
        ));
  }
}
