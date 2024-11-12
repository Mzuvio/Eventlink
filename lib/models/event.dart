import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transitease_app/models/category.dart';

class Event {
  String? id;
  String title;
  String description;
  DateTime date;
  DateTime time;
  String location;
  String userName;
  String userId; 
  Category category;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.userName,
    required this.userId, 
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time),
      'location': location,
      'userName': userName,
      'userId': userId, 
      'category': category.toMap(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map, String documentId) {
    return Event(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: (map['time'] as Timestamp).toDate(),
      location: map['location'] ?? '',
      userName: map['userName'] ?? '',
      userId: map['userId'] ?? '', 
      category: Category.fromMap(map['category']),
    );
  }
}
