import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/EasyWidget.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/holiday_database/models/country.dart';

Future<Country> selectCountry(BuildContext context, {Country selected}) {
  return selectItem(
      context: context,
      items: Country.values.toList(),
      builder: (context, country) {
        return ListTile(
          title: Text(countryToName(context, country)),
          trailing: country == selected
              ? Icon(
                  Icons.done,
                  color: Colors.green,
                )
              : null,
          onTap: () {
            Navigator.pop(context, country);
          },
        );
      });
}

String countryToName(BuildContext context, Country country) {
  switch (country) {
    case Country.germany:
      return bothlang(context, en: 'Germany', de: 'Deutschland');
    case Country.austria:
      return bothlang(context, en: 'Austria', de: 'Österreich');
    case Country.switzerland:
      return bothlang(context, en: 'Switzerland', de: 'Schweiz');
    case Country.netherlands:
      return bothlang(context, en: 'Netherlands', de: 'Niederlanden');
  }
  return bothlang(context, en: 'All', de: 'Alle');
}
