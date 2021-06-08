/*
    Copyright 2020-2021. Huawei Technologies Co., Ltd. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License")
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

import 'package:huawei_map/components/components.dart';
import 'package:huawei_map/utils/toJson.dart';

Map<MarkerId, Marker> markerToMap(Iterable<Marker> markers) {
  if (markers == null) {
    return <MarkerId, Marker>{};
  }
  return Map<MarkerId, Marker>.fromEntries(markers.map((Marker marker) =>
      MapEntry<MarkerId, Marker>(marker.markerId, marker.clone())));
}

List<Map<String, dynamic>> markerToList(Set<Marker> markers) {
  if (markers == null) return null;

  return markers
      .map<Map<String, dynamic>>((Marker m) => markerToJson(m))
      .toList();
}
