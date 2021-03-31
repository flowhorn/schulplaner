import 'package:schulplaner8/utils/models/coder.dart';

enum Country { germany, austria, switzerland, netherlands }

Country countryFromJson(String json) =>
    enumFromJson<Country>(Country.values, json);

String? countryToJson(Country country) => enumToJson<Country>(country);
