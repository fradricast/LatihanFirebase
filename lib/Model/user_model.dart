class UserModel {
  String? firstname;
  String? email;
  String? noHp;

  UserModel({
    required this.firstname,
    required this.email,
    required this.noHp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstname: json['firstname'],
        email: json['email'],
        noHp: json['noHp'],
      );

  toJson() => {
        'firstname': firstname,
        'email': email,
        'noHp': noHp,
      };
}
