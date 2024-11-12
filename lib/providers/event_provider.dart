import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transitease_app/models/event.dart';
import 'package:transitease_app/providers/user_provider.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Event> _events = [];

  List<Event> get events => _events;

  Future<void> fetchEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      _events.clear();
      for (var doc in snapshot.docs) {
        _events.add(Event.fromMap(doc.data(), doc.id));
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
    notifyListeners();
  }

  Future<void> addEvent(Event event, UserProvider userProvider) async {
    try {
      final docRef = await _firestore.collection('events').add(event.toMap());
      event.id = docRef.id;

      _events.add(event);
      notifyListeners();

      await userProvider.addEvent(event);
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> updateEvent(Event updatedEvent) async {
    try {
      if (updatedEvent.id != null) {
        await _firestore
            .collection('events')
            .doc(updatedEvent.id)
            .update(updatedEvent.toMap());

        int index = _events.indexWhere((event) => event.id == updatedEvent.id);
        if (index != -1) {
          _events[index] = updatedEvent;
          notifyListeners();
        }
      } else {
        print("Error updating event: Event ID is null");
      }
    } catch (e) {
      print("Error updating event: $e");
    }
  }

  Future<void> deleteEvent(String docId, String userFullName) async {
    try {
      final filteredEvents = _events
          .where(
            (event) => event.id == docId && event.userName == userFullName,
          )
          .toList();

      if (filteredEvents.isNotEmpty) {
        final eventToDelete = filteredEvents.first;
        await _firestore.collection('events').doc(docId).delete();
        _events.remove(eventToDelete);
        notifyListeners();
      } else {
        print("No matching event found for deletion.");
      }
    } catch (e) {
      print("Error deleting event: $e");
    }
  }

  Future<List<Event>> fetchEventsByUserId(String userId) async {
    List<Event> userEvents = [];
    try {
      final snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        userEvents.add(Event.fromMap(doc.data(), doc.id));
      }
    } catch (e) {
      print("Error fetching events for user: $e");
    }
    return userEvents;
  }

  void removeEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  List<Event> filterEventsByCategory(String categoryId) {
    return _events
        .where((event) =>
            event.category.categoryId ==
            categoryId) // Adjust based on your Event model
        .toList();
  }
}
