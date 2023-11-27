// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String firstname;
  final String lastname;
  final String email;
  final String uid;
  final String division;
  final String district;
  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.uid,
    required this.division,
    required this.district,
  });

  UserModel copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? uid,
    String? division,
    String? district,
  }) {
    return UserModel(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      division: division ?? this.division,
      district: district ?? this.district,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'uid': uid,
      'division': division,
      'district': district,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
      division: map['division'] as String,
      district: map['district'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.firstname == firstname &&
        other.lastname == lastname &&
        other.email == email &&
        other.uid == uid &&
        other.division == division &&
        other.district == district;
  }

  @override
  int get hashCode {
    return firstname.hashCode ^
        lastname.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        division.hashCode ^
        district.hashCode;
  }
}
