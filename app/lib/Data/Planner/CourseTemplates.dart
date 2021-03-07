import 'package:flutter/material.dart';
import 'package:schulplaner_widgets/schulplaner_theme.dart';

class CourseTemplate {
  String name, shortname;
  Design design;
  int category;
  CourseTemplate(
      {required this.name,
      required this.shortname,
      required this.design,
      this.category = 0});
}

class TemplateCategory {
  int category;
  String name;
  TemplateCategory({
    required this.category,
    required this.name,
  });
}

List<dynamic> getTemplateList_DE() {
  return [
    TemplateCategory(category: 0, name: 'Hauptfächer'),
    CourseTemplate(
        name: 'Deutsch',
        shortname: 'Deu',
        design: Design(
          name: 'Rot',
          primary: Colors.red,
        ),
        category: 0),
    CourseTemplate(
        name: 'Mathematik',
        shortname: 'Mat',
        design: Design(
          name: 'Blau',
          primary: Colors.blue,
        ),
        category: 0),
    CourseTemplate(
        name: 'Englisch',
        shortname: 'Eng',
        design: Design(
          name: 'Tiefes Orange',
          primary: Colors.deepOrange,
        ),
        category: 0),
    CourseTemplate(
        name: 'Französisch',
        shortname: 'Fra',
        design: Design(
          name: 'Gelb',
          primary: Colors.yellow,
        ),
        category: 0),
    CourseTemplate(
        name: 'Spanisch',
        shortname: 'Spa',
        design: Design(
          name: 'Teal',
          primary: Colors.teal,
        ),
        category: 0),
    CourseTemplate(
        name: 'Latein',
        shortname: 'Lat',
        design: Design(
          name: 'Braun',
          primary: Colors.brown,
        ),
        category: 0),
    TemplateCategory(category: 1, name: 'Naturwissenschaften'),
    CourseTemplate(
        name: 'Biologie',
        shortname: 'Bio',
        design: Design(
          name: 'Grün',
          primary: Colors.green,
        ),
        category: 1),
    CourseTemplate(
        name: 'Chemie',
        shortname: 'Che',
        design: Design(
          name: 'Blaues Grau',
          primary: Colors.blueGrey,
        ),
        category: 1),
    CourseTemplate(
        name: 'Physik',
        shortname: 'Phy',
        design: Design(
          name: 'Tiefes Rot',
          primary: Colors.red[800]!,
        ),
        category: 1),
    TemplateCategory(category: 2, name: 'Nebenfächer'),
    CourseTemplate(
        name: 'Sport',
        shortname: 'Spo',
        design: Design(
          name: 'Tiefes Rot',
          primary: Colors.red[800]!,
        ),
        category: 2),
    CourseTemplate(
        name: 'Religion',
        shortname: 'Reli',
        design: Design(
          name: 'Pink',
          primary: Colors.pink,
        ),
        category: 2),
    CourseTemplate(
        name: 'Kunst',
        shortname: 'Kun',
        design: Design(
          name: 'Schwarz',
          primary: Colors.black87,
        ),
        category: 2),
    CourseTemplate(
        name: 'Musik',
        shortname: 'Mus',
        design: Design(
          name: 'Weiß',
          primary: Colors.white,
        ),
        category: 2),
    TemplateCategory(category: 3, name: 'Gesellschaftswissenschaften'),
    CourseTemplate(
        name: 'Geschichte',
        shortname: 'Ges',
        design: Design(
          name: 'Orange',
          primary: Colors.orange,
        ),
        category: 3),
    CourseTemplate(
        name: 'Politik',
        shortname: 'Pol',
        design: Design(
          name: 'Grau',
          primary: Colors.grey,
        ),
        category: 3),
    CourseTemplate(
        name: 'Erdkunde',
        shortname: 'Geo',
        design: Design(
          name: 'Leichtes Grün',
          primary: Colors.lightGreen[300]!,
        ),
        category: 3),
    CourseTemplate(
        name: 'Sozialwissenschaften',
        shortname: 'Sowi',
        design: Design(
          name: 'Tiefes Rot',
          primary: Colors.red[800]!,
        ),
        category: 3),
    CourseTemplate(
        name: 'Pädagogik',
        shortname: 'Päda',
        design: Design(
          name: 'Cyan',
          primary: Colors.cyan,
        ),
        category: 3),
    CourseTemplate(
        name: 'Philosophie',
        shortname: 'Philo',
        design: Design(
          name: 'Indigo',
          primary: Colors.indigo,
        ),
        category: 3),
  ];
}
