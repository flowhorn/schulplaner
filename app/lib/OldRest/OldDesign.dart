import 'package:color/color.dart' as colorlib;
import 'package:flutter/material.dart';

class OldDesign {
  Color primary;
  Color accent;
  String name;
  String id;

  OldDesign({this.id, this.name, this.primary, this.accent});

  String getKey() => id;

  OldDesign.fromSnapshot(dynamic it)
      : id = it['id'],
        name = it['name'],
        primary = DataUtil_Design.fromHex(it['primary']),
        accent = DataUtil_Design.fromHex(it['accent']);

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'primary': DataUtil_Design.getHex(primary),
      'accent': DataUtil_Design.getHex(accent)
    };
  }
}

class DataUtil_Design {
  static List<OldDesign> allprefilleddesigns = [
    OldDesign(
        id: 'PREDESIGN_0',
        name: 'Blue',
        primary: Colors.blue,
        accent: Colors.redAccent),
    OldDesign(
        id: 'PREDESIGN_1',
        name: 'Indigo',
        primary: Colors.indigo,
        accent: Colors.pinkAccent),
    OldDesign(
        id: 'PREDESIGN_2',
        name: 'Deep Orange',
        primary: Colors.deepOrange,
        accent: Colors.greenAccent),
    OldDesign(
        id: 'PREDESIGN_3',
        name: 'Red',
        primary: Colors.red,
        accent: Colors.blueAccent),
    OldDesign(
        id: 'PREDESIGN_4',
        name: 'Teal',
        primary: Colors.teal,
        accent: Colors.redAccent),
    OldDesign(
        id: 'PREDESIGN_5',
        name: 'Green',
        primary: Colors.green,
        accent: Colors.deepOrangeAccent),
    OldDesign(
        id: 'PREDESIGN_6',
        name: 'Yellow',
        primary: Colors.yellow,
        accent: Colors.redAccent),
    OldDesign(
        id: 'PREDESIGN_7',
        name: 'Deep Purple',
        primary: Colors.deepPurpleAccent,
        accent: Colors.greenAccent),
    OldDesign(
        id: 'PREDESIGN_8',
        name: 'Blue Grey',
        primary: Colors.blueGrey,
        accent: Colors.redAccent),
    OldDesign(
        id: 'PREDESIGN_9',
        name: 'Brown',
        primary: Colors.brown,
        accent: Colors.greenAccent),
    OldDesign(
        id: 'PREDESIGN_10',
        name: 'Pink',
        primary: Colors.pink,
        accent: Colors.lightBlueAccent),
    OldDesign(
        id: 'PREDESIGN_11',
        name: 'Black',
        primary: Colors.black,
        accent: Colors.redAccent),
    OldDesign(
        id: 'PREDESIGN_12',
        name: 'White',
        primary: Colors.white,
        accent: Colors.redAccent),
  ];
  static List<OldDesign> oldprefilleddesigns = [
    OldDesign(
        id: '001',
        name: 'Standard',
        primary: fromHex('3f51b5'),
        accent: fromHex('ff4081')),
    OldDesign(
        id: '002',
        name: 'Red',
        primary: fromHex('f44336'),
        accent: fromHex('448aff')),
    OldDesign(
        id: '003',
        name: 'Green',
        primary: fromHex('4caf50'),
        accent: fromHex('ffab40')),
    OldDesign(
        id: '004',
        name: 'Deep Orange',
        primary: fromHex('ff5722'),
        accent: fromHex('69f0ae')),
    OldDesign(
        id: '005',
        name: 'Blue Grey',
        primary: fromHex('607d8b'),
        accent: fromHex('ff4081')),
    OldDesign(
        id: '006',
        name: 'Blue',
        primary: fromHex('2196f3'),
        accent: fromHex('ff5252')),
    OldDesign(
        id: '007',
        name: 'Yellow',
        primary: fromHex('ffeb3b'),
        accent: fromHex('64ffda')),
    OldDesign(
        id: '008',
        name: 'Teal',
        primary: fromHex('009688'),
        accent: fromHex('ff5252')),
  ];

  static OldDesign decodeDesignHash(final String designhash) {
    if (designhash == null || designhash == '') {
      return OldDesign(
          id: 'invalid',
          name: 'None',
          primary: Colors.blueGrey,
          accent: Colors.pinkAccent);
    }
    if (!designhash.contains('=')) {
      return oldprefilleddesigns.firstWhere((OldDesign d) {
        return d.id == designhash;
      }, orElse: () {
        return allprefilleddesigns[0];
      });
    }
    switch (designhash.split('=')[0]) {
      case 'VALUE':
        {
          List<String> values = designhash.split('=')[1].split('#');
          colorlib.RgbColor primary_rgb =
              colorlib.HexColor(values[2]).toRgbColor();
          colorlib.RgbColor accent_rgb =
              colorlib.HexColor(values[3]).toRgbColor();

          return OldDesign(
              id: values[0],
              name: values[1],
              primary: Color.fromARGB(
                  255, primary_rgb.r, primary_rgb.g, primary_rgb.b),
              accent: Color.fromARGB(
                  255, accent_rgb.r, accent_rgb.g, accent_rgb.b));
        }
      case 'ID':
        {
          return oldprefilleddesigns.firstWhere((OldDesign d) {
            return d.id == designhash.split('=')[1];
          }, orElse: () {
            return allprefilleddesigns[0];
          });
        }
      case 'NEWID':
        {
          return allprefilleddesigns.firstWhere((OldDesign d) {
            return d.id == designhash.split('=')[1];
          }, orElse: () {
            return allprefilleddesigns[0];
          });
        }
    }
    return OldDesign(
        id: 'autogenerated',
        name: 'Auto',
        primary: Colors.red,
        accent: Colors.blueAccent);
  }

  static String getHex(Color c) {
    colorlib.RgbColor rgbcolor = colorlib.RgbColor(c.red, c.green, c.blue);
    return rgbcolor.toHexColor().toString();
  }

  static Color fromHex(String hex) {
    colorlib.RgbColor primary_rgb = colorlib.HexColor(hex).toRgbColor();
    return Color.fromARGB(255, primary_rgb.r, primary_rgb.g, primary_rgb.b);
  }

  static OldDesign getMainDesign() {
    return OldDesign(
        id: 'PREDESIGN_4',
        name: 'Teal',
        primary: Colors.teal,
        accent: Colors.redAccent);
  }
}
