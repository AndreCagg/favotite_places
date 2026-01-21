import 'package:favorite_places/model/place.dart';
import 'package:flutter/material.dart';

class PlaceProvider extends ChangeNotifier {
  late Map<String, Place> _places = {};

  Map<String, Place> get places {
    return _places;
  }

  void addPlace(Place p) {
    _places[p.id] = p;
    notifyListeners();
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
