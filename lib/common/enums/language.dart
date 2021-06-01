enum Language {
  english,
  spanish,
}

extension LanguagesExtension on Language {
  String get code {
    switch (this) {
      case Language.english: return 'en';
      case Language.spanish: return 'es';
      default: return '';
    }
  }

  String get name {
    switch (this) {
      case Language.english: return 'English';
      case Language.spanish: return 'Spanish';
      default: return '';
    }
  }
}