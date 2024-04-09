class Language {
  final int id;

  final String flag;

  final String name;

  final String languageCode;

  Language(
      {required this.id,
      required this.flag,
      required this.name,
      required this.languageCode});

  // static List<Language> languageList() {
  //
  //   return <Language>[
  //
  //     Language(1, "🇺🇸", "English", "en"),
  //
  //     Language(2, "🇮🇳", "ગુજરાતી", "gu"),
  //
  //     Language(3, "🇮🇳", "हिंदी", "hi"),
  //
  //   ];
  //
  // }
}
