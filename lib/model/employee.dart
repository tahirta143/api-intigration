class Employee {
  String? id;
  String? name;
  String? image;
  String? company;

  Employee({
    this.id,
    this.name,
    this.image,
    this.company,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"]?.toString(),
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      company: json["company"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "company": company,
    };
  }
}
