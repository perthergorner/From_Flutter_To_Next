class CarouselModel {
  String carouselType = "社員";
  int id = 0;
  String imageUrl = "";
  String title = "";

  CarouselModel(this.carouselType, this.id, this.title, this.imageUrl);

  CarouselModel.fromJson(Map<String, dynamic> json) {
    carouselType = json['carouselType'] ?? "社員";
    id = json['id'] ?? 0;
    imageUrl = json['imageUrl']?? "";
    title = json['title']?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carouselType'] = this.carouselType;
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['title'] = this.title;
    return data;
  }
}