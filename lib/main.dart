import 'package:bhagavadgita/src/resources/repository/common_repository.dart';
import 'package:bhagavadgita/src/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  CommonRepository _repository = CommonRepository();
  runApp(MyApp(commonRepository : _repository));
}

class MyApp extends StatelessWidget {
  final CommonRepository commonRepository;


  MyApp({this.commonRepository,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Bhagavad Geeta",
      theme: ThemeData.light(),
      home:HomePage(commonRepository:commonRepository),
    );
  }
}
