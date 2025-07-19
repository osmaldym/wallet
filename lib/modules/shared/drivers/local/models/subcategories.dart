import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/defs.dart';

class Subcategories extends Defs {
  String? name;
  String? iconFontFamily;
  int? icon;
  int? categoryId;
  bool? isCategoryReference;

  Subcategories({
    super.id,
    super.serverId,
    this.name,
    this.icon,
    this.categoryId,
    this.iconFontFamily,
    this.isCategoryReference,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'server_id': serverId,
    'icon': icon,
    'name': name,
    'icon_font_family': iconFontFamily,
    'category_id,': categoryId,
    'is_category_reference': isCategoryReference.toBool(),
  };

  @override
  String toString() => Convertions.classToString("Subcategory", toMap());
}