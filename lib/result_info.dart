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

class MockResultInfo {
  MockResultInfo();

   static List<ResultInfo> searchResults = [
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
    ResultInfo("Bluebell Lakes", "2.45 miles", "Oundle", true, false),
    ResultInfo("Cawcutts Lakes", "120 miles", "Impington", true, true),
    ResultInfo("Manor Farm Lakes", "5 miles", "Biggleswade", true, true),
  ];

}