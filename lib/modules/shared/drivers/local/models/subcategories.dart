import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Subcategories extends Defs {
  String? name;
  String? iconFontFamily;
  int? icon;
  int? categoryGroupId;

  Subcategories({
    super.id,
    super.serverId,
    this.name,
    this.icon,
    this.categoryGroupId,
    this.iconFontFamily,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'icon': icon,
      'name': name,
      'icon_font_family': iconFontFamily,
      'category_group_id,': categoryGroupId,
    };
  }

  @override
  String toString() => Convertions.classToString("Subcategory", toMap());
}