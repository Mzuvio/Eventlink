import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:transitease_app/models/event.dart';
import 'package:transitease_app/providers/user_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'fullName': fullName,
          'email': email,
          'location': "",
          'phone': "",
          'profileImageUrl': "",
          'postedEvents': [],
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('New user with id => ${user.uid}');
        await FirebaseMessaging.instance.subscribeToTopic('all');
        print("User subscribed to topic 'all'");
      }
      return user;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  Future<void> loginUser(
      String email, String password, UserProvider userProvider) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        print("User document exists: ${userDoc.exists}");

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          await FirebaseMessaging.instance.subscribeToTopic('all');
          print("User subscribed to topic 'all'");
          print("Fetched user data: $userData");

          userProvider.setUser(
            userId: userData['userId'],
            fullName: userData['fullName'],
            email: userData['email'],
            phone: userData['phone'] ?? '',
            location: userData['location'] ?? '',
            postedEvents: [],
            profileImageUrl: userData['profileImageUrl'] ?? '',
          );
        } else {
          print("User document does not exist in Firestore.");
        }
      }
    } catch (e) {
      print("Error during login: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print("User document does not exist in Firestore.");
        return null;
      }
    } else {
      print("No user is currently logged in.");
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('all');
    await _auth.signOut();
    print('User signed out and unsubscribed from topic');
  }

  Future<void> deleteCurrentUser(UserProvider userProvider) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
        userProvider.logoutUser();
        print('This user is deleted');
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<void> updateUserData(String userId, String fullName, String email,
      String phone, String location) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        await _firestore.collection('users').doc(userId).update({
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'location': location,
        });
        print("User data updated successfully.");
      } else {
        print("Error: Document does not exist.");
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  Future<void> addEventToUser(String userId, Event event) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(userId);
      await userDoc.update({
        'postedEvents': FieldValue.arrayUnion([event.toMap()])
      });
      print("Event added to user document successfully.");
    } catch (e) {
      print("Error adding event to user document: $e");
    }
  }

  Future<void> removeEventFromUser(String userId, String eventId) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(userId);
      userDoc.update({
        'postedEvents': FieldValue.arrayRemove([
          {'id': eventId}
        ])
      });
      print("Event removed from user document successfully.");
    } catch (e) {
      print("Error removing event from user document: $e");
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }
}
