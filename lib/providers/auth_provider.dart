import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user; // Firebase Auth 유저 객체
  UserModel? _userModel; // 우리가 정의한 유저 데이터 (role 포함)

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isAdmin => _userModel?.role == 'admin'; // 관리자 여부 확인

  AuthProvider() {
    _checkCurrentUser();
  }

  // 앱 켜질 때 로그인 상태 체크
  void _checkCurrentUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _fetchUserModel(_user!.uid);
    }
    notifyListeners();
  }

  // 로그인 기능
  Future<void> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = cred.user;
      await _fetchUserModel(_user!.uid);
      notifyListeners();
    } catch (e) {
      throw Exception('로그인 실패: ${e.toString()}');
    }
  }

  // 회원가입 기능 (일반 유저로 생성)
  Future<void> signUp(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = cred.user;

      // Firestore에 유저 정보 저장
      UserModel newUser = UserModel(
        uid: _user!.uid,
        email: email,
        role: 'user', // 기본은 일반 유저
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(_user!.uid).set(newUser.toMap());
      _userModel = newUser;
      notifyListeners();
    } catch (e) {
      throw Exception('회원가입 실패: ${e.toString()}');
    }
  }

  // 로그아웃
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  // DB에서 유저 정보 가져오기 (관리자 확인용)
  Future<void> _fetchUserModel(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
    }
  }
}