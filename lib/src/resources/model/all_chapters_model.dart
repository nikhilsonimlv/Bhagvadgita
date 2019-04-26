class AllChaptersModel {
  final List<ChaptersModel> chapterList;

  AllChaptersModel({this.chapterList});

  factory AllChaptersModel.fromJson(List<dynamic> parsedJson) {
    List<ChaptersModel> chapters =
        parsedJson.map((i) => ChaptersModel.fromJson(i)).toList();

    return new AllChaptersModel(chapterList: chapters);
  }
}

class ChaptersModel {
  final String chapterNumber;
  final String chapterSummary;
  final String name;
  final String nameMeaning;
  final String nameTranslation;
  final String nameTransliterated;
  final String versesCount;

  ChaptersModel(
      {this.chapterNumber,
      this.chapterSummary,
      this.name,
      this.nameMeaning,
      this.nameTranslation,
      this.nameTransliterated,
      this.versesCount});

  factory ChaptersModel.fromJson(Map<String, dynamic> json) {
    return new ChaptersModel(
      chapterNumber: json['chapter_number'].toString(),
      chapterSummary: json['chapter_summary'],
      name: json['name'],
      nameMeaning: json['name_meaning'],
      nameTranslation: json['name_translation'],
      nameTransliterated: json['name_transliterated'],
      versesCount: json['verses_count'].toString(),
    );
  }
}
