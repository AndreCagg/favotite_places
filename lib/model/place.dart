import "dart:io";

import "package:favorite_places/model/custom_location.dart";
import "package:uuid/uuid.dart";

Uuid uuid = Uuid();

class Place {
  Place(this.place, this.file, this.location) : id = uuid.v7().toString();
  Place.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      place = json["place"] as String,
      file = File(json["file"].toString()),
      location = CustomLocation(
        json["location"]["latitudine"] as String,
        json["location"]["longitudine"] as String,
      );

  final String id;
  final String place;
  final File file;
  final CustomLocation location;
}
