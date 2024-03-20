import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat_user.dart'; // Assuming you have a 'chat_user.dart' file in the 'models' directory

class APIs {
  // For authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // For accessing Cloud Firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;
  static User? get user => auth.currentUser; // Use nullable operator

  // For checking if user exists
  static Future<bool> userExists() async {
    // Return false if user is null
    return (await firestore.collection('users').doc(user!.uid).get())
        .exists; // Return whether the user document exists or not
  }

  // For retrieving self information
  static Future<void> getSelfInfo() async {
    if (user == null) return; // Return if user is null
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(user!.uid).get();
    if (userSnapshot.exists) {
      me = ChatUser.fromJson(userSnapshot.data() as Map<String, dynamic>);
      print('My Data: ${userSnapshot.data()}');
    } else {
      await createUser().then((value) => getSelfInfo());
    }
    return; // Minor indentation adjustment
  }

  // For creating a new user document
  static Future<void> createUser() async {
    if (user == null) return; // Return if user is null
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user!.uid, // Use user! to assert non-null
      name: user!.displayName ??
          '', // Use null-aware operators to handle possible null values
      email: user!.email ?? '',
      about: "Hey, I'm using 🔥Fire Flut💧!",
      image: user!.photoURL ?? '',
      createdAt: time, // Assign 'time' directly
      isOnline: false,
      lastActive: time, // Assign 'time' directly
      pushToken: '',
      created_: '',
    );

    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(chatUser.toJson());
  }

  // For retrieving all users except the current user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    if (user == null) {
      // Handle case where user is null
      return Stream.empty();
    }
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user!.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    // Return false if user is null
    await firestore.collection('users').doc(user!.uid).update({
      'name': me.name,
      'about': me.about,
    }); // Return whether the user document exists or not
  }

  static updateActiveStatus(bool bool) {}

  static void updateProfilePicture() async {
    //
  }
}
