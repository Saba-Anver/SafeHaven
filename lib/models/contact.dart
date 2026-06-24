class Contacts {
  String name;
  String phoneNo;

  Contacts({required this.name, required this.phoneNo});

  Map<String, dynamic> toJson() {
    return {"name": this.name, "phoneNo": this.phoneNo};
  }

  static Contacts fromJson(Map<String, dynamic> contact) {
    return Contacts(name: contact["name"], phoneNo: contact["phoneNo"]);
  }
}
