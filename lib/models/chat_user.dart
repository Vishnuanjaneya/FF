class ChatUser {
  ChatUser({
    required this.image,
    required this.created_,
    required this.name,
    required this.about,
    required this.id,
    required this.lastActive,
    required this.isOnline,
    required this.email,
    required this.pushToken,
    required String createdAt,
  });
  late String image;
  late String created_;
  late String name;
  late String about;
  late String id;
  late String lastActive;
  late bool isOnline;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    created_ = json['created_'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['created_'] = created_;
    data['name'] = name;
    data['about'] = about;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
