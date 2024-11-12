import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transitease_app/models/app_user.dart';
import 'package:transitease_app/models/event.dart';
import 'package:transitease_app/services/auth/auto_services.dart';

class UserProvider with ChangeNotifier {
  AppUser? _currentUser;
  final List<Notification> _notifications = [];
  final AuthService _authService = AuthService();

  AppUser? get currentUser => _currentUser;
  List<Event> get postedEvents => _currentUser?.postedEvents ?? [];
  List<Notification> get notifications => _notifications;

  void initializeUser() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user == null) {
        print('No user is currently logged in');
      } else {
        final userData = await _authService.getUserData();

        if (userData != null) {
          List<Event> postedEvents = (userData['postedEvents'] as List?)
                  ?.map((e) {
                    if (e is Map<String, dynamic> && e.containsKey('id')) {
                      return Event.fromMap(e, e['id']);
                    } else {
                      return null;
                    }
                  })
                  .whereType<Event>()
                  .toList() ??
              [];

          setUser(
            userId: userData['userId'],
            fullName: userData['fullName'],
            email: userData['email'],
            phone: userData['phone'],
            location: userData['location'],
            postedEvents: postedEvents,
            profileImageUrl: userData['profileImageUrl'] ?? '',
          );
        }

        notifyListeners();
      }
    });
  }

  void setUser({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
    required String location,
    required List<Event> postedEvents,
    String? profileImageUrl,
  }) {
    _currentUser = AppUser(
      userId: userId,
      fullName: fullName,
      email: email,
      phone: phone,
      location: location,
      postedEvents: postedEvents,
      profileImageUrl: profileImageUrl,
    );
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    if (_currentUser != null) {
      try {
        await _authService.addEventToUser(_currentUser!.userId, event);
        _currentUser!.postedEvents.add(event);
        notifyListeners();
      } catch (e) {
        print("Error adding event: $e");
      }
    } else {
      print("No current user available to add event.");
    }
  }

  void updateProfileImage(String newImageUrl) {
    if (_currentUser != null) {
      _currentUser!.updateProfileImage(newImageUrl);
      notifyListeners();
    }
  }

  void removeProfileImage() {
    if (_currentUser != null) {
      _currentUser!.removeProfileImage();
      notifyListeners();
    }
  }

  void addPostedEvent(Event event) {
    if (_currentUser != null) {
      _currentUser!.postedEvents.add(event);
      notifyListeners();
    }
  }

  void addNotification(Notification notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  Future<void> updateUserDetails({
    String? fullName,
    String? email,
    String? phone,
    String? location,
  }) async {
    if (_currentUser != null) {
      try {
        await _authService.updateUserData(
          _currentUser!.userId,
          fullName ?? _currentUser!.fullName,
          email ?? _currentUser!.email,
          phone ?? _currentUser!.phone,
          location ?? _currentUser!.location ?? '',
        );

        _currentUser = AppUser(
          userId: _currentUser!.userId,
          fullName: fullName ?? _currentUser!.fullName,
          email: email ?? _currentUser!.email,
          phone: phone ?? _currentUser!.phone,
          location: location ?? _currentUser!.location,
          postedEvents: _currentUser!.postedEvents,
          profileImageUrl: _currentUser!.profileImageUrl,
        );

        notifyListeners();
      } catch (e) {
        print("Error updating user details: $e");
      }
    } else {
      print(
          "No current user available to update."); 
    }
  }

  void logoutUser() {
    _currentUser = null;
    _notifications.clear();
    notifyListeners();
  }

  Future<void> removeEvent(String eventId) async {
    if (_currentUser != null) {
      try {
        _currentUser!.postedEvents.removeWhere((event) => event.id == eventId);
        await _authService.removeEventFromUser(_currentUser!.userId, eventId);
        notifyListeners();
      } catch (e) {
        print("Error removing event: $e");
      }
    } else {
      print("No current user available to remove event.");
    }
  }
}