
import 'package:bmi_app/services/cloud_firestore_service.dart';
import 'package:bmi_app/utils/functions/calculate_bmi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBody extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> userData;
  const EditBody({super.key, required this.documentId, required this.userData});

  @override
  State<EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  CloudFirestoreService? service;

  @override
  void initState() {
    super.initState();
    heightController.text = widget.userData['height'];
    weightController.text = widget.userData['weight'];
    ageController.text = widget.userData['age'];

    service = CloudFirestoreService(FirebaseFirestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Model>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: heightController,
            decoration: const InputDecoration(labelText: 'Height'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: weightController,
            decoration: const InputDecoration(labelText: 'Weight'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(labelText: 'Age'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final updatedHeight = heightController.text.trim();
              final updatedWeight = weightController.text.trim();
              final updatedAge = ageController.text.trim();

              model.calculateBmi(
                  double.parse(updatedWeight), double.parse(updatedHeight));

              await service?.edit(widget.documentId, {
                'height': updatedHeight,
                'weight': updatedWeight,
                'age': updatedAge,
                'bmi': model.bmi,
                'bmiStatus': model.status,
              });

              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
