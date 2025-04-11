import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Authservice {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential> login(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Đăng nhập thất bại: Sai email hoặc mật khẩu',
          backgroundColor: Colors.red, colorText: Colors.white);
      throw Exception("Đăng nhập thất bại: $e");
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Đăng ký thất bại: $e");
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<String> getUserRole() async {
    String role = '';
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      role = value.get('role');
    });
    return role;
  }

  Future<String> getUserName() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          print('User document: ${userDoc.data()}');
          return userDoc['name'] ?? '';
        } else {
          print('No user document found for UID: ${user.uid}');
          return '';
        }
      }
      return '';
    } catch (e) {
      print('Error fetching username: $e');
      return '';
    }
  }

  Future<Map<String, String>> getUserInfo(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return {
          'name': doc['name'] ?? '',
          'role': doc['role'] ?? '',
        };
      }
      return {'name': '', 'role': ''};
    } catch (e) {
      print('Lỗi lấy thông tin người dùng: $e');
      return {'name': '', 'role': ''};
    }
  }
}
