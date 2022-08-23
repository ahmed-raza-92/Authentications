class TaskModel {
  String? title;
  String? detail;

  TaskModel(this.title, this.detail);

  String get getTitle => title!;

  String get getDetail => detail!;
}
