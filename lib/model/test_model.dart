import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Person {
  Person({this.name, this.age, this.city, this.address});

  String? name;
  int? age;
  String? city;
  List<Address>? address;
}

class Address {
  Address({this.country, this.city});

  String? country;
  String? city;
}

class TestModel extends StatelessWidget {
  var myMap = {
    "name": "Steve",
    "age": 34,
    "city": "Stoney Creek",
    "address": [
      {"Country": "China", "City": "Shanghai"},
      {"Country": "South Korea", "City": "Pusan"}
    ],
  };

  @override
  Widget build(BuildContext context) {
    List myList = myMap['address'] as List;
    (myList).forEach((element) {
      element['country'];
    });
    return Scaffold(
      body: Center(child: Text((myList)[1].toString())),
    );
  }
}
