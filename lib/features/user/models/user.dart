import 'dart:typed_data';

class User {
  User({
    this.id,
    this.firstname,
    this.lastname,
    this.age,
    this.major,
    this.minor,
    this.image,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    firstname = json['firstname'] as String;
    lastname = json['lastname'] as String;
    age = json['age'] as String;
    major = json['major'] as String;
    minor = json['minor'] as String;
    image = json['image'] as Uint8List;
  }

  String? id;
  String? firstname;
  String? lastname;
  String? age;
  String? major;
  String? minor;
  Uint8List? image;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'major': major,
      'minor': minor,
      'image': image,
    };
  }
}
