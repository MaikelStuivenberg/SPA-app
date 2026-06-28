
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
    this.onboardingComplete,
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
    onboardingComplete = json['onboardingComplete'] as bool?;
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
  bool? onboardingComplete;

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
      'onboardingComplete': onboardingComplete,
    };
  }

  /// Applies [update] over this user; non-null fields in [update] win.
  UserData mergedWith(UserData update) {
    return UserData(
      id: update.id ?? id,
      firstname: update.firstname ?? firstname,
      lastname: update.lastname ?? lastname,
      age: update.age ?? age,
      major: update.major ?? major,
      minor: update.minor ?? minor,
      image: update.image ?? image,
      biblestudyGroup: update.biblestudyGroup ?? biblestudyGroup,
      biblestudyLeader: update.biblestudyLeader ?? biblestudyLeader,
      tent: update.tent ?? tent,
      tentLeader: update.tentLeader ?? tentLeader,
      staff: update.staff ?? staff,
      onboardingComplete: update.onboardingComplete ?? onboardingComplete,
    );
  }
}
