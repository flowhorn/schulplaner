//@dart=2.11
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schulplaner8/Data/plannerdatabase.dart';
import 'package:schulplaner8/Helper/helper_data.dart';
import 'package:schulplaner8/models/planner_settings.dart';
import 'package:schulplaner_translations/schulplaner_translations.dart';
import 'package:schulplaner_widgets/schulplaner_forms.dart';
import 'package:schulplaner8/Helper/helper_views.dart';
import 'package:schulplaner8/holiday_database/models/country.dart';
import 'package:schulplaner8/holiday_database/models/region.dart';
import 'package:schulplaner8/holiday_database/pages/country_picker.dart';
import 'package:schulplaner_widgets/schulplaner_common.dart';

class SelectRegionPage extends StatelessWidget {
  final PlannerDatabase database;
  final ValueNotifier<RegionsFilter> regionsFilter;

  const SelectRegionPage._({Key key, this.database, this.regionsFilter})
      : super(key: key);

  factory SelectRegionPage({Key key, PlannerDatabase database}) {
    return SelectRegionPage._(
      key: key,
      database: database,
      regionsFilter: ValueNotifier(RegionsFilter(
        country: null,
        isOfficial: false,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppHeader(
        title: getString(context).select,
      ),
      body: StreamBuilder<PlannerSettingsData>(
          stream: database.settings.stream,
          initialData: database.settings.data,
          builder: (context, settingsSnapshot) {
            final settingsData = settingsSnapshot.data;
            return ValueListenableBuilder<RegionsFilter>(
              valueListenable: regionsFilter,
              builder: (context, filterValue, _) {
                return Column(
                  children: <Widget>[
                    FormHeader2(bothlang(context, en: 'Filter', de: 'Filter')),
                    ListTile(
                      title: Text(bothlang(context, en: 'Country', de: 'Land')),
                      trailing:
                          Text(filterValue.country != null ? countryToName(context, filterValue.country) : '???'),
                      onTap: () {
                        selectCountry(context, selected: filterValue.country)
                            .then((selectedCountry) {
                          if (selectedCountry != null) {
                            setRegionsFilter(RegionsFilter(
                                country: selectedCountry,
                                isOfficial: filterValue.isOfficial));
                          }
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      title: Text(bothlang(context,
                          de: 'Nur offizielle', en: 'Officials only')),
                      value: filterValue.isOfficial,
                      onChanged: (newValue) {
                        setRegionsFilter(RegionsFilter(
                            country: filterValue.country,
                            isOfficial: newValue));
                      },
                    ),
                    FormDivider(),
                    StreamBuilder<List<Region>>(
                      stream: getRegionsStream(filterValue),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final regions = snapshot.data;
                        return Expanded(
                          child: ListView(
                            children: <Widget>[
                              Text(
                                regions.length.toString() +
                                    bothlang(context,
                                        en: ' results', de: ' Ergebnisse'),
                                textAlign: TextAlign.center,
                              ),
                              for (final region in regions)
                                RegionTile(
                                  region: region,
                                  onTap: () {
                                    PlannerSettingsData newdata =
                                        settingsData.copy();
                                    newdata.vacationpackageid = region.id.key;
                                    _updateSettings(newdata, database);
                                  },
                                  isSelected: settingsData.vacationpackageid ==
                                      region.id.key,
                                )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                );
              },
            );
          }),
    );
  }

  Stream<List<Region>> getRegionsStream(RegionsFilter filter) {
    return database.holidayGateway
        .getRegions(isOfficial: filter.isOfficial, country: filter.country);
  }

  void setRegionsFilter(RegionsFilter newFilter) {
    regionsFilter.value = newFilter;
  }
}

class RegionTile extends StatelessWidget {
  final Region region;
  final VoidCallback onTap;
  final bool isSelected;

  const RegionTile({Key key, this.region, this.onTap, this.isSelected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(region.name.text),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            bothlang(context, en: 'Country', de: 'Land') +
                ': ' +
                (region.country != null
                    ? countryToName(context, region.country)
                    : '/'),
          ),
          Text(getString(context).refreshed +
              ': ' +
              region.lastRefreshed.parser.toYMMMd),
          Row(
            children: <Widget>[
              if (region.isOfficial)
                RegionTileTag(
                    text: bothlang(context, de: 'Offiziell', en: 'Official'))
              else
                RegionTileTag(text: 'Community'),
            ],
          )
        ],
      ),
      trailing: isSelected
          ? RButton(
              iconData: Icons.done,
              text: getString(context).selected,
              onTap: null,
              disabledColor: Colors.green,
            )
          : RButton(text: getString(context).select, onTap: onTap),
    );
  }
}

class RegionTileTag extends StatelessWidget {
  final String text;

  const RegionTileTag({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      color: Colors.deepOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

class RegionsFilter {
  final Country country;
  final bool isOfficial;

  const RegionsFilter({@required this.country, @required this.isOfficial});
}

void _updateSettings(PlannerSettingsData newdata, PlannerDatabase database) {
  database.settings.reference.set(
    newdata.toJson(),
    SetOptions(
      merge: true,
    ),
  );
}
