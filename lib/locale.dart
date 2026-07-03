import 'package:flutter/foundation.dart';

/// Very lightweight bilingual (Hindi + English) string provider.
/// No codegen needed — just a toggleable map, kept simple for a
/// small app and easy CI builds.
enum AppLang { en, hi }

class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  AppLang _lang = AppLang.hi;
  AppLang get lang => _lang;

  void toggle() {
    _lang = _lang == AppLang.en ? AppLang.hi : AppLang.en;
    notifyListeners();
  }

  void set(AppLang l) {
    _lang = l;
    notifyListeners();
  }
}

class S {
  static const Map<String, Map<AppLang, String>> _strings = {
    'app_name': {AppLang.en: 'DawaCheck', AppLang.hi: 'दवा चेक'},
    'cabinet': {AppLang.en: 'Medicine Cabinet', AppLang.hi: 'दवाई अलमारी'},
    'scan_medicine': {AppLang.en: 'Scan Medicine', AppLang.hi: 'दवाई स्कैन करें'},
    'add_manually': {AppLang.en: 'Add Manually', AppLang.hi: 'खुद जोड़ें'},
    'no_medicines': {
      AppLang.en: 'No medicines yet.\nTap + to scan or add one.',
      AppLang.hi: 'अभी कोई दवाई नहीं है।\nस्कैन या जोड़ने के लिए + दबाएँ।'
    },
    'expired': {AppLang.en: 'Expired', AppLang.hi: 'एक्सपायर हो चुकी'},
    'expiring_soon': {AppLang.en: 'Expiring soon', AppLang.hi: 'जल्द खत्म होगी'},
    'valid': {AppLang.en: 'Valid', AppLang.hi: 'ठीक है'},
    'medicine_name': {AppLang.en: 'Medicine Name', AppLang.hi: 'दवाई का नाम'},
    'expiry_date': {AppLang.en: 'Expiry Date', AppLang.hi: 'एक्सपायरी डेट'},
    'batch_no': {AppLang.en: 'Batch No. (optional)', AppLang.hi: 'बैच नंबर (वैकल्पिक)'},
    'save': {AppLang.en: 'Save', AppLang.hi: 'सेव करें'},
    'cancel': {AppLang.en: 'Cancel', AppLang.hi: 'रद्द करें'},
    'delete': {AppLang.en: 'Delete', AppLang.hi: 'हटाएं'},
    'take_photo': {AppLang.en: 'Take Photo', AppLang.hi: 'फोटो लें'},
    'gallery': {AppLang.en: 'Choose from Gallery', AppLang.hi: 'गैलरी से चुनें'},
    'reading_label': {
      AppLang.en: 'Reading label…',
      AppLang.hi: 'लेबल पढ़ा जा रहा है…'
    },
    'date_found': {AppLang.en: 'Date found', AppLang.hi: 'तारीख मिली'},
    'date_not_found': {
      AppLang.en: 'Could not detect a date. Enter manually.',
      AppLang.hi: 'तारीख नहीं मिली। खुद डालें।'
    },
    'confirm_details': {AppLang.en: 'Confirm Details', AppLang.hi: 'जानकारी जांचें'},
    'retake': {AppLang.en: 'Retake', AppLang.hi: 'फिर से लें'},
    'days_left': {AppLang.en: 'days left', AppLang.hi: 'दिन बचे'},
    'days_ago': {AppLang.en: 'days ago', AppLang.hi: 'दिन पहले'},
    'settings': {AppLang.en: 'Settings', AppLang.hi: 'सेटिंग्स'},
    'language': {AppLang.en: 'Language', AppLang.hi: 'भाषा'},
    'camera_permission_needed': {
      AppLang.en: 'Camera permission is needed to scan medicines.',
      AppLang.hi: 'दवाई स्कैन करने के लिए कैमरा अनुमति चाहिए।'
    },
    'edit': {AppLang.en: 'Edit', AppLang.hi: 'बदलें'},
    'select_expiry_date': {
      AppLang.en: 'Select expiry date',
      AppLang.hi: 'एक्सपायरी डेट चुनें'
    },
    'notes': {AppLang.en: 'Notes (optional)', AppLang.hi: 'नोट्स (वैकल्पिक)'},
  };

  static String of(String key) {
    final entry = _strings[key];
    if (entry == null) return key;
    return entry[LocaleController.instance.lang] ?? entry[AppLang.en] ?? key;
  }
}
