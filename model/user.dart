import '../Core/extension.dart';
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
  final String uuid;
  final String type;
  final String firstName;
  final String lastName;
  final Nationality? nationality;
  final String status;
  final String nickName;
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
      this.uuid = '',
      this.type = '',
      this.firstName = '',
      this.lastName = '',
      this.nationality,
      this.status = '',
      this.nickName = '',
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
        id: json['id'] ?? 0,
        uuid: json['uuid'] ?? '',
        type: json['type'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        nationality: Nationality.shared.fromJson(json['nationality']),
        status: json['status'] ?? '',
        nickName: json['nick_name'] ?? '',
        role: json['role'] ?? 0,
        email: json['email'] ?? '',
        mobileNo: json['mobile_no'] ?? '',
        telNo: json['tel_no'] ?? '',
        regNo: json['reg_no'] ?? '',
        picName: json['pic_name'] ?? '',
        isActive: json['is_active'] ?? false,
        address1: json['address_1'] ?? '',
        address2: json['address_2'] ?? '',
        postcode: json['postcode'] ?? '',
        city: json['city'] ?? '',
        countryState: json['country_state'] ?? '',
        createAt: json['created_at'] ?? '');
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

class Nationality extends RData {
  final int id;
  final String name;
  final String code;
  final String dial;

  static final shared = Nationality();

  Nationality({this.id = 0, this.name = '', this.code = '', this.dial = ''});

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      dial: json['dial'] ?? '',
    );
  }

  @override
  Nationality? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Nationality.fromJson(json.checkIsArrayEmpty);
  }

  @override
  List<Nationality> listFromJson(List? json) {
    if (json == null) return [];
    List<Nationality> list = [];
    for (Map<String, dynamic> item in json) {
      list.add(Nationality.fromJson(item.checkIsArrayEmpty));
    }
    return list;
  }
}
