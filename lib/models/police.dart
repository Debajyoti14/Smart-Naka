import 'dart:convert';

Police policeFromJson(String str) => Police.fromJson(json.decode(str));

String policeToJson(Police data) => json.encode(data.toJson());

class Police {
  Police({
    required this.policeStation,
    required this.post,
    required this.number,
    required this.id,
    required this.name,
    required this.age,
    required this.avatar,
  });

  String policeStation;
  String post;
  String number;
  String id;
  String name;
  int age;
  String avatar;

  factory Police.fromJson(Map<String, dynamic> json) => Police(
        policeStation: json["policeStation"],
        post: json["post"],
        number: json["number"],
        id: json["id"],
        name: json["name"],
        age: json["age"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "policeStation": policeStation,
        "post": post,
        "number": number,
        "id": id,
        "name": name,
        "age": age,
        "avatar": avatar,
      };
}
