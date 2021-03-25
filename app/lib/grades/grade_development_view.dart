import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/OldGrade/Grade.dart';
import 'package:schulplaner8/OldGrade/GradePackage.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';

class GradeDevelopmentView extends StatelessWidget {
  final List<Grade> grades;
  final GradePackage gradePackage;

  final List<Color> gradientColors = const [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];

  const GradeDevelopmentView(
      {Key? key, required this.grades, required this.gradePackage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double lowestGradeValue = 0.0;
    double highestGradeValue = 100.0;
    try {
      final List<double> gradevalues = grades
          .map((it) => gradePackage.getGradeValue!(it.valuekey!).value)
          .toList()
            ..sort((item1, item2) => item1.compareTo(item2));

      lowestGradeValue = gradevalues.isNotEmpty ? gradevalues.first : 0.0;
      highestGradeValue = gradevalues.isNotEmpty ? gradevalues.last : 100.0;
    } catch (e) {
      print(e);
    }

    final Map<double, String> lefttexts = gradePackage.gradevalues
        .asMap()
        .map((key, value) => MapEntry(value.value, value.name));

    final List<double> rangevalues = lefttexts.keys.toList()
      ..sort((item1, item2) => item1.compareTo(item2));
    final bool containsValues = rangevalues.isNotEmpty;
    final double lowest = containsValues ? rangevalues.first : lowestGradeValue;
    print('LOWEST: $lowest');
    final double highest =
        containsValues ? rangevalues.last : highestGradeValue;
    print('HIGHEST: $highest');
    if (grades.isEmpty) {
      return Card(
        child: Center(
          child:
              Text(bothlang(context, de: 'Keine Daten', en: 'Fehlende Daten')),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          color: Color(0xff232d37)),
      child: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              FormHeader(
                bothlang(context,
                    de: 'Notenentwicklung', en: 'Development of grades'),
                color: Colors.white,
              ),
              AspectRatio(
                aspectRatio: 1.70,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Color(0xff37434d),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Color(0xff37434d),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTextStyles: (value) => TextStyle(
                                color: const Color(0xff68737d),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            getTitles: (value) {
                              return '';
                            },
                            margin: 8,
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => TextStyle(
                              color: const Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            getTitles: (value) {
                              if (containsValues) {
                                return lefttexts[value] ?? '';
                              } else {
                                return value.toString();
                              }
                            },
                            reservedSize: 25,
                            margin: 10,
                          ),
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border:
                                Border.all(color: Color(0xff37434d), width: 1)),
                        minX: 0,
                        maxX: grades.length.toDouble(),
                        minY: lowest,
                        maxY: highest,
                        lineBarsData: [
                          LineChartBarData(
                            spots: grades
                                .map((grade) => FlSpot(
                                    grades.indexOf(grade).toDouble(),
                                    gradePackage
                                        .getGradeValue!(grade.valuekey!).value))
                                .toList(),
                            isCurved: true,
                            colors: gradientColors,
                            barWidth: 5,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: false,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: gradientColors
                                  .map((color) => color.withOpacity(0.3))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          );
        },
      ),
    );
  }
}
