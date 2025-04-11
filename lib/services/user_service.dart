import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> getAllUsers() async {
    final List<User> users = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id; 
        users.add(User.fromJson(data));
      }
      return users;
    } catch (e) {
      print('Load users error: $e');
      return users;
    }
  }

  Future<User?> getUserById(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        data['id'] = snapshot.id;
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Load user error: $e');
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      Get.snackbar('Thông báo', 'Xóa người dùng thành công',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print('Delete user error: $e');
    }
  }

}
