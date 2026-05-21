import 'package:appdle/localization/localization_en.dart';
import 'package:appdle/localization/localization_es.dart';

class TextManager {
    static String language = "es";

    static final Map<String, Map> _texts = {
        "es": LocalizationEs.texts,
        "en": LocalizationEn.texts,
    };

    static String get(String key) {
        return _texts[language]?[key] ?? key;
    }

    static void changeLanguage(String lang) {
        language = lang;
    }
}