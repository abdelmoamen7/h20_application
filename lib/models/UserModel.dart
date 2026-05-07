class UserModel{
  String name;
  String id;
  String email;
  static UserModel? currentUser;
  UserModel({required this.name,required this.id,required this.email});
  /// here  we create to get from jason
  UserModel.fromjson(Map<String, dynamic>json):this(
    name:json["name"],
    id:json["id"],
    email:json["email"],
  );
  /// here i crate the or delacre the place  of what the data well store as what :
  Map<String, dynamic>toJosn(){
    return {
      "name":name,
      "id":id,
      "email":email,
    };
  }
}