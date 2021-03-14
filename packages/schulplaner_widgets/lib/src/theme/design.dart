import 'dart:math';

import 'package:flutter/material.dart';
import 'color_design.dart';

class Design {
  final Color primary;
  final Color? accent;
  final String? id;
  final String name;

  Design({
    this.id,
    required this.name,
    required this.primary,
    this.accent,
  });

  factory Design.fromData(dynamic data) {
    if (data != null) {
      return Design(
        id: data['id'],
        name: data['name'],
        accent: fromHex(data['accent'] ?? data['primary']),
        primary: fromHex(data['primary']),
      );
    } else {
      return Design(
        id: "000",
        name: "Standard",
        primary: Colors.blue,
        accent: Colors.redAccent,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': getHex(primary),
      'accent': accent != null ? getHex(accent!) : null,
      'name': name,
    };
  }

  Map<String, dynamic> toWidgetJson() {
    return {
      'id': id,
      'primary': getHex(primary),
      'accent': accent != null ? getHex(accent!) : null,
      'name': name,
    };
  }

  bool validate() {
    if (primary == null) return false;
    if (accent == null) return false;
    if (name == null || name == '') return false;
    return true;
  }

  Design copyWith({
    String? name,
    Color? primary,
    Color? accent,
  }) {
    return Design(
      id: id,
      name: name ?? this.name,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
    );
  }
}

List<Design> designPresets() {
  return [
    Design(
        id: "000",
        name: "Standard",
        primary: Colors.blue,
        accent: Colors.redAccent),
    Design(
        id: "001",
        name: "Grün",
        primary: Colors.green,
        accent: Colors.amberAccent),
    Design(
        id: "002",
        name: "Teal",
        primary: Colors.teal,
        accent: Colors.pinkAccent),
    Design(
        id: "003",
        name: "Orange",
        primary: Colors.orange,
        accent: Colors.greenAccent),
    Design(
        id: "004", name: "Rot", primary: Colors.red, accent: Colors.blueAccent),
    Design(
        id: "005",
        name: "Pink",
        primary: Colors.pink,
        accent: Colors.lightBlueAccent),
    Design(
        id: "006",
        name: "Brown",
        primary: Colors.brown,
        accent: Colors.greenAccent),
    Design(
      id: "007",
      name: "Blue Grey",
      primary: Colors.blueGrey,
      accent: Colors.blueGrey,
    ),
    Design(
      id: "008",
      name: "Deep Purple",
      primary: Colors.deepPurpleAccent,
      accent: Colors.deepPurpleAccent,
    ),
    Design(
      id: "009",
      name: "Yellow",
      primary: Colors.yellow,
      accent: Colors.yellow,
    ),
    Design(
      id: "010",
      name: "Green",
      primary: Colors.green,
      accent: Colors.green,
    ),
    Design(
      id: "011",
      name: "Deep Orange",
      primary: Colors.deepOrange[800]!,
      accent: Colors.deepOrange[800],
    ),
    Design(
      id: "012",
      name: "Light Blue",
      primary: Colors.lightBlue[300]!,
      accent: Colors.lightBlue[300],
    ),
    Design(
      id: "013",
      name: "Black",
      primary: Colors.black,
      accent: Colors.black,
    ),
    Design(
      id: "014",
      name: "White",
      primary: Colors.white,
      accent: Colors.white,
    ),
    //Design(id: "004", name: "Weiß", primary: Colors.white, accent: Colors.blueAccent),
  ];
}

Design getRandomDesign() {
  final _random = Random();
  final list = designPresets();
  return list[_random.nextInt(list.length)];
}

class PresetsDesisgn {}
