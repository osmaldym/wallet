import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class CategoryGroup extends Defs {
  int? userId;
  String? name;
  int? icon;
  String? iconFontFamily;

  CategoryGroup({
    super.id,
    super.serverId,
    this.name,
    this.icon,
    this.iconFontFamily,
    this.userId,
  });

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'server_id': serverId,
      'user_id': userId,
      'name': name,
      'icon': icon,
      'icon_font_family': iconFontFamily,
    };
  }

  @override
  String toString() => Convertions.classToString("CategoryGroup", toMap());
}