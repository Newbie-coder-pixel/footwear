import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "number")
  int? number;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "role")
  String? role;

  User({
    this.id,
    this.name,
    this.number,
    this.email,
    this.password,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
