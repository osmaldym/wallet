import 'package:dart_ipify/dart_ipify.dart';

class WebDao {
  Future<String> getPublicIp() async {
    return await Ipify.ipv4();
  }
}