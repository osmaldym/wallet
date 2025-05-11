import 'package:flutter/material.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class User extends Defs {
  final String ?names;
  final String ?email;
  final String ?password;
  final String ?img;

  User({
    super.id,
    super.serverId,
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