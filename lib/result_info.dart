class ResultInfo {
  ResultInfo(String title, String distance, String location, bool isLake, bool isOpen) {
    this.title = title;
    this.distance = distance;
    this.location = location;
    this.isLake = isLake;
    this.isOpen = isOpen;
  }

  String title;
  String distance;
  String location;
  bool isLake;
  bool isOpen;
}