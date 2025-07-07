import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Currency extends Defs {
  String? iso;
  String? symbol;
  String? locale;
  String? country;

  Currency({
    super.id,
    super.serverId,
    this.iso,
    this.symbol,
    this.locale,
    this.country
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'iso': iso,
      'symbol': symbol,
      'locale': locale,
      'country': country,
    };
  }

  @override
  String toString() => Convertions.classToString("Currency", toMap());
}