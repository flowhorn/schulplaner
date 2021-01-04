import 'package:schulplaner_translations/schulplaner_translations.dart';

class BaseTranslations {
  static TranslatableString get pleaseWait {
    return TranslationString((context) => getString(context).pleasewait);
  }

  static TranslatableString get error {
    return TranslationString((context) => getString(context).error);
  }

  static TranslatableString get successfull {
    return BothLangString(de: 'Erfolgreich', en: 'Successful');
  }

  static TranslatableString get noInternetAccess {
    return BothLangString(
        de: 'Keine Internetverbindung', en: 'No internet access');
  }

  static TranslatableString get unknownException {
    return BothLangString(de: 'Unbekannter Fehler', en: 'Unknown Exception');
  }
}
