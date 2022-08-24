class TaskModel {
  String? title;
  String? detail;
  bool check = false;
  String? id;
  TaskModel(this.title, this.detail);

  String get getTitle => title!;

  String get getDetail => detail!;

  String get getID => id!;

  set setCheck(bool val) {
    check = val;
  }

  set setID(String id) {
    this.id = id;
  }

  TaskModel.fromMap(Map<String,dynamic> data) {
    title = data['title'];
    detail = data['detail'];
    check = data['check'];

  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'detail': detail, 'check': check};
  }
}
