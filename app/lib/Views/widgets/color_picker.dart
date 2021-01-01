import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';

Future<Color> selectColor(BuildContext context, Color selectedColor) {
  return showDialog(
    context: context,
    builder: (context) => _ColorPicker(
      selectedColor: selectedColor,
    ),
  );
}

class _ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueNotifier<Color> color;
  _ColorPicker({Key key, this.selectedColor})
      : color = ValueNotifier(selectedColor),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(bothlang(context, de: "Farbe", en: "Color")),
      contentPadding: EdgeInsets.zero,
      content: MaterialColorPicker(
        selectedColor: selectedColor,
        onColorChange: (newColor) {
          color.value = newColor;
          Navigator.pop(context, color.value);
        },
        onMainColorChange: (newMainColor) {
          color.value = newMainColor;
        },
        shrinkWrap: true,
        onlyShadeSelection: true,
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, color.value);
            },
            child: Text(getString(context).done))
      ],
    );
  }
}
