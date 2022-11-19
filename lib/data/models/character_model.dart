class Character {
  int? charId;
  String? name;
  String? birthday;
  List<String>? occupation;
  String? img;
  String? status;
  String? nickname;
  List<int>? appearance;
  String? portrayed;
  String? category;
  List<dynamic>? betterCallSaulAppearance;

  Character({
    this.charId,
    this.name,
    this.birthday,
    this.occupation,
    this.img,
    this.status,
    this.nickname,
    this.appearance,
    this.portrayed,
    this.category,
    this.betterCallSaulAppearance,
  });

  Character.fromJson(Map<String, dynamic> json) {
    charId = json['char_id'] as int?;
    name = json['name'] as String?;
    birthday = json['birthday'] as String?;
    occupation = (json['occupation'] as List?)?.map((dynamic e) => e as String).toList();
    img = json['img'] as String?;
    status = json['status'] as String?;
    nickname = json['nickname'] as String?;
    appearance = (json['appearance'] as List?)?.map((dynamic e) => e as int).toList();
    portrayed = json['portrayed'] as String?;
    category = json['category'] as String?;
    betterCallSaulAppearance = json['better_call_saul_appearance'] as List?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['char_id'] = charId;
    json['name'] = name;
    json['birthday'] = birthday;
    json['occupation'] = occupation;
    json['img'] = img;
    json['status'] = status;
    json['nickname'] = nickname;
    json['appearance'] = appearance;
    json['portrayed'] = portrayed;
    json['category'] = category;
    json['better_call_saul_appearance'] = betterCallSaulAppearance;
    return json;
  }
}