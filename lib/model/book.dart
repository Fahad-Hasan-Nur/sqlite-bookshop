class BookEntity {
  int? id;
  String? name;
  String? des;
  String? image;
  int? countryId;
  String? dop;
  String? createdAt;
  String? updatedAt;

  BookEntity(
      {this.id,
      this.name,
      this.des,
      this.image,
      this.dop,
      this.createdAt,
      this.countryId,
      this.updatedAt});

  BookEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    des = json['des'];
    image = json['image'];
    dop = json['dop'];
    countryId = json['countryId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
