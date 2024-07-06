class TodoModel{
  final int? id;
  String? title;
  String? description;
  TodoModel({this.id,required this.title, required this.description});

  factory TodoModel.fromMap(Map<String, dynamic> map){
    return TodoModel(id: map['id'], title: map['title'], description: map['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

}