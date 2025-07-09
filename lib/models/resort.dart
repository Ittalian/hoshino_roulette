class Resort {
  String resortId;
  String name;
  String prefecture;
  String url;
  bool isDone;
  bool isSelected;

  Resort({
    required this.resortId,
    required this.name,
    required this.prefecture,
    required this.url,
    required this.isDone,
    this.isSelected = false,
  });
}