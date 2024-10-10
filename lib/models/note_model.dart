class NoteModel {
  int? id;
  String title;
  String description;

  NoteModel({
    this.id,
    required this.title,
    required this.description,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}
