import '../Api/response.dart';

class UserJson extends RData {
  final UserItem? user;
  final String? accessToken;

  static final shared = UserJson();

  UserJson({this.user, this.accessToken});

  factory UserJson.fromJson(Map<String, dynamic> json) {
    return UserJson(user: UserItem.shared.fromJson(json['user']), accessToken: json['access_token']);
  }

  @override
  UserJson? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return UserJson.fromJson(json);
  }

  @override
  listFromJson(List? json) {
    if (json == null) return [];
    List<UserJson> list = [];
    for (var item in json) {
      list.add(UserJson.fromJson(item));
    }
    return list;
  }
}

class UserItem extends RData {
  final int? id;
  final String? name;
  final int? role; // 0 = null, 1 = super admin, 2 = admin, 3 = customer.
  final String? email;
  final String? mobileNo;
  final String? telNo;
  final String? regNo;
  final String? picName;
  final bool? isActive;
  final String? address1;
  final String? address2;
  final String? postcode;
  final String? city;
  final String? countryState;
  final String? createAt;

  static final shared = UserItem();

  UserItem(
      {this.id,
      this.name,
      this.role,
      this.email,
      this.mobileNo,
      this.telNo,
      this.regNo,
      this.picName,
      this.isActive,
      this.address1,
      this.address2,
      this.postcode,
      this.city,
      this.countryState,
      this.createAt});

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
        id: json['id'],
        name: json['name'],
        role: json['role'],
        email: json['email'],
        mobileNo: json['mobile_no'],
        telNo: json['tel_no'],
        regNo: json['reg_no'],
        picName: json['pic_name'],
        isActive: json['is_active'],
        address1: json['address_1'],
        address2: json['address_2'],
        postcode: json['postcode'],
        city: json['city'],
        countryState: json['country_state'],
        createAt: json['created_at']);
  }

  @override
  UserItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return UserItem.fromJson(json);
  }

  @override
  listFromJson(List? json) {
    if (json == null) return [];
    List<UserItem> list = [];
    for (var item in json) {
      list.add(UserItem.fromJson(item));
    }
    return list;
  }
}
