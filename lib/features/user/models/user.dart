
class UserData {
  UserData({
    this.id,
    this.firstname,
    this.lastname,
    this.age,
    this.major,
    this.minor,
    this.image,
    this.biblestudyGroup,
    this.biblestudyLeader,
    this.tent,
    this.tentLeader,
    this.staff,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    firstname = json['firstname'] as String;
    lastname = json['lastname'] as String;
    age = json['age'] as String;
    major = json['major'] as String;
    minor = json['minor'] as String;
    image = json['image'] as String;
    biblestudyGroup = json['biblestudyGroup'] as String;
    biblestudyLeader = json['biblestudyLeader'] as bool;
    tent = json['tent'] as String;
    tentLeader = json['tentLeader'] as bool;
    staff = json['staff'] as bool;
  }

  String? id;
  String? firstname;
  String? lastname;
  String? age;
  String? major;
  String? minor;
  String? image;
  String? get imageUrl => image != null
      ? 'https://firebasestorage.googleapis.com/v0/b/school-of-performing-arts.appspot.com/o/users%2F$id%2Fprofile%2F$image?alt=media'
      : null;
  String? biblestudyGroup;
  bool? biblestudyLeader;
  String? tent;
  bool? tentLeader;
  bool? staff;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'major': major,
      'minor': minor,
      'image': image,
      'biblestudyGroup': biblestudyGroup,
      'biblestudyLeader': biblestudyLeader,
      'tent': tent,
      'tentLeader': tentLeader,
      'staff': staff,
    };
  }
}
