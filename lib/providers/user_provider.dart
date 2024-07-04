import 'dart:developer';

import 'package:flutter/material.dart';

import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: -1, 
    username: '', 
    email: '', 
    passwordHash: '',
    createdAt: '',
    updatedAt: '',
    hashedRt: ''
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  } 
}