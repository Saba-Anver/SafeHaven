class Contact {
  String name;
  String phoneNo;

  Contact({required this.name, required this.phoneNo});

  Map<String, dynamic> toJson() {
    return {"name": this.name, "phoneNo": this.phoneNo};
  }

  static Contact fromJson(Map<String, dynamic> contact) {
    return Contact(name: contact["name"], phoneNo: contact["phoneNo"]);
  }
}
