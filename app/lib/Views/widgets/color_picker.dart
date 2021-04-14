import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

Future<Color?> selectColor(BuildContext context, Color? selectedColor) {
  return showDialog<Color>(
    context: context,
    builder: (context) => _ColorPicker(
      selectedColor: selectedColor,
    ),
  );
}

class _ColorPicker extends StatelessWidget {
  final Color? selectedColor;
  final ValueNotifier<Color?> color;
  _ColorPicker({Key? key, required this.selectedColor})
      : color = ValueNotifier(selectedColor),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(bothlang(context, de: 'Farbe', en: 'Color')),
      contentPadding: EdgeInsets.zero,
      content: MaterialPicker(
        pickerColor: selectedColor ?? Colors.teal,
        onColorChanged: (newColor) {
          color.value = newColor;
          Navigator.pop(context, color.value);
        },
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context, color.value);
            },
            child: Text(getString(context).done))
      ],
    );
  }
}
