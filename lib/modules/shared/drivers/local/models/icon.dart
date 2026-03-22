import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Icon extends Defs {
  String? name;
  int? hexCode;
  String? iconFontFamily;

  Icon({
    super.id,
    this.name,
    this.hexCode,
    this.iconFontFamily
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'server_id': serverId,
    'name': name,
    'hex_code': hexCode,
    'icon_font_family': iconFontFamily,
  };

  @override
  String toString() => Convertions.classToString("Icon", toMap());
}