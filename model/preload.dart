import '../CoreModel/core_model.dart';
import '../Api/response.dart';

class Preload extends RData {

  final List<IntroModel> introList;
  final List<CountryItem> countries;
  //final List<State>? states;

  static final shared = Preload();

  Preload({this.introList = const [], this.countries = const []});

  factory Preload.fromJson(Map<String, dynamic> json) {
    return Preload(
      introList: IntroModel.shared.listFromJson(json['corridors']),
      countries: CountryItem.shared.listFromJson(json['countries'])
    );
  }

  @override
  Preload? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Preload.fromJson(json);
  }

  @override
  List<Preload> listFromJson(List? json) {
    if (json == null) return [];
    List<Preload> list = [];
    for (var item in json) {
      list.add(Preload.fromJson(item));
    }
    return list;
  }
}

class CountryItem extends RData {
  final String name;
  final String code;
  final String dial;

  static final shared = CountryItem();

  CountryItem({this.name = '', this.code = '', this.dial = ''});

  factory CountryItem.fromJson(Map<String, dynamic> json) {
    return CountryItem(name: json['name'] ?? '', code: json['code'] ?? '', dial: json['dial']);
  }

  @override
  CountryItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return CountryItem.fromJson(json);
  }

  @override
  List<CountryItem> listFromJson(List? json) {
    if (json == null) return [];
    List<CountryItem> list = [];
    for (var item in json) {
      list.add(CountryItem.fromJson(item));
    }
    return list;
  }
}

class StateItem extends RData {
  final int? id;
  final String? name;
  final List<CityItem>? cities;

  static final shared = StateItem();

  StateItem({this.id, this.name, this.cities});

  factory StateItem.fromJson(Map<String, dynamic> json) {
    return StateItem(id: json['id'], name: json['name'], cities: CityItem.shared.listFromJson(json['cities']));
  }

  @override
  StateItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return StateItem.fromJson(json);
  }

  @override
  List<StateItem> listFromJson(List? json) {
    if (json == null) return [];
    List<StateItem> list = [];
    for (var item in json) {
      list.add(StateItem.fromJson(item));
    }
    return list;
  }
}

class CityItem extends RData {
  final int? id;
  final String? name;
  final int? stateID;

  static final shared = CityItem();

  CityItem({this.id, this.name, this.stateID});

  factory CityItem.fromJson(Map<String, dynamic> json) {
    return CityItem(id: json['id'], name: json['name'], stateID: json['country_state_id']);
  }

  @override
  CityItem? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return CityItem.fromJson(json);
  }

  @override
  List<CityItem> listFromJson(List? json) {
    if (json == null) return [];
    List<CityItem> list = [];
    for (var item in json) {
      list.add(CityItem.fromJson(item));
    }
    return list;
  }
}


class KeySortItem<T> {
  final String key;
  final List<T> items;

  KeySortItem(this.key, this.items);
}
