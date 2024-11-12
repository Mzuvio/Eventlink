import 'package:transitease_app/models/event.dart';
class AppUser {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  String? location;
  final List<Event> postedEvents;
  String? profileImageUrl;

  AppUser({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    this.location,
    required this.postedEvents,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'postedEvents': postedEvents.map((event) => event.toMap()).toList(),
      'profileImageUrl': profileImageUrl,
    };
  }

    void updateProfileImage(String? newImageUrl) {
    profileImageUrl = newImageUrl;
  }

  void removeProfileImage() {
    profileImageUrl = null;
  }
}
