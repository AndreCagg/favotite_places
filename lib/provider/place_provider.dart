import 'dart:convert';
import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as path;

class PlaceProvider extends ChangeNotifier {
  late Map<String, Place> _places = {};

  Map<String, Place> get places {
    return _places;
  }

  void addPlace(Place p) {
    _places[p.id] = p;
    notifyListeners();
  }

  void savePlace(Place p, bool saveImg) async {
    late String newPath = p.file.path;
    if (saveImg) {
      Directory appDir = await pp.getApplicationDocumentsDirectory();
      String filename = path.basename(p.file.path);
      File newFile = await p.file.copy("${appDir.path}/$filename");
      newPath = newFile.path;
    }

    http.post(
      Uri.https(
        "place-937c1-default-rtdb.firebaseio.com",
        "places/${p.id}.json",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": p.id,
        "place": p.place,
        "file": newPath,
        "location": {
          "latitudine": p.location.latitudine,
          "longitudine": p.location.longitudine,
        },
      }),
    );

    addPlace(p);
  }

  void removePlace(String id) {
    _places.remove(id);
    notifyListeners();
  }

  void initState(Map<String, Place> batch) {
    _places = batch;
    notifyListeners();
  }
}
