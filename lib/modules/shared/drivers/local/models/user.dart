import 'package:flutter/material.dart';
import 'package:wallet/core/utils/convertions.dart';

class User {
  final int ?id;
  final int ?serverId;
  final String ?names;
  final String ?email;
  final String ?password;
  final String ?img;

  const User({
    this.id,
    this.serverId,
    this.names,
    this.email,
    this.password,
    this.img,
  });

  Map<String, Object?> toMap() {
    return { 'id': id, 'server_id': serverId, 'names': names, 'email': email, 'img': img, 'password': password };
  }

  @override
  String toString(){
    return Convertions.classToString("User", toMap());
  }
}