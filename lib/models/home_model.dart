class HomeModel {
  String id;
  String building;
  String floor;
  String bed;
  bool active;
  String createdAt;
  String updatedAt;

  HomeModel(
      {this.id,
      this.building,
      this.floor,
      this.bed,
      this.active,
      this.createdAt,
      this.updatedAt});

  HomeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    building = json['building'];
    floor = (json['floor'] != null) ? json['floor']['desc'] : '';
    bed = json['bed'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['building'] = this.building;
    data['floor'] = this.floor;
    data['bed'] = this.bed;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
