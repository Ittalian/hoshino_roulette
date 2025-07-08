class Resort {
  String resortId;
  String name;
  String prefecture;
  bool isDone;
  bool isSelected;

  Resort({
    required this.resortId,
    required this.name,
    required this.prefecture,
    required this.isDone,
    this.isSelected = false,
  });
}