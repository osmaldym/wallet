import 'package:dart_ipify/dart_ipify.dart';

class WebDao {
  Future<String?> getPublicIp() async {
    try {
      return await Ipify.ipv4();
    } catch (e) {
      return null;
    }
  }
}