import '../Api/response.dart';

class Preload extends RData {
  final List<State>? states;
  Preload({this.states});
  static Preload? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Preload(
      states: State.listFromJson(json['country_states'])
    );
  }
  static List<Preload> listFromJson(List? json) {
    if (json == null) return [];
    List<Preload> list = [];
    for (var item in json) {
      list.add(Preload.fromJson(item)!);
    }
    return list;
  }
}

class State extends RData {
  final int? id;
  final String? name;
  final List<City>? cities;

  State({this.id, this.name, this.cities});

  static State? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return State(id: json['id'], name: json['name'], cities: City.listFromJson(json['cities']));
  }

  static List<State> listFromJson(List? json) {
    if (json == null) return [];
    List<State> list = [];
    for (var item in json) {
      list.add(State.fromJson(item)!);
    }
    return list;
  }
}

class City extends RData {
  final int? id;
  final String? name;
  final int? stateID;

  City({this.id, this.name, this.stateID});

  static City? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return City(id: json['id'], name: json['name'], stateID: json['country_state_id']);
  }

  static List<City> listFromJson(List? json) {
    if (json == null) return [];
    List<City> list = [];
    for (var item in json) {
      list.add(City.fromJson(item)!);
    }
    return list;
  }
}
