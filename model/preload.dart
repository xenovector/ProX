import '../Api/response.dart';

class Preload extends RData {

  final List<State>? states;

  static final shared = Preload();

  Preload({this.states});

  factory Preload.fromJson(Map<String, dynamic> json) {
    return Preload(states: State.shared.listFromJson(json['country_states']));
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

class State extends RData {
  final int? id;
  final String? name;
  final List<City>? cities;

  static final shared = State();

  State({this.id, this.name, this.cities});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(id: json['id'], name: json['name'], cities: City.shared.listFromJson(json['cities']));
  }

  @override
  State? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return State.fromJson(json);
  }

  @override
  List<State> listFromJson(List? json) {
    if (json == null) return [];
    List<State> list = [];
    for (var item in json) {
      list.add(State.fromJson(item));
    }
    return list;
  }
}

class City extends RData {
  final int? id;
  final String? name;
  final int? stateID;

  static final shared = City();

  City({this.id, this.name, this.stateID});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(id: json['id'], name: json['name'], stateID: json['country_state_id']);
  }

  @override
  City? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return City.fromJson(json);
  }

  @override
  List<City> listFromJson(List? json) {
    if (json == null) return [];
    List<City> list = [];
    for (var item in json) {
      list.add(City.fromJson(item));
    }
    return list;
  }
}
