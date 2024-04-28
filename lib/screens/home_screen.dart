import 'package:bmi_app/screens/widgets/home_body.dart';
import 'package:bmi_app/utils/functions/calculate_bmi.dart';
import 'package:bmi_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Model(),
      child: const Scaffold(
        appBar: CustomAppBar(),
        body: HomeBodyWidget(),
      ),
    );
  }
}

