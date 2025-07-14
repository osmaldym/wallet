import 'package:wallet/core/utils/convertions.dart';
import 'package:wallet/modules/shared/drivers/local/models/category.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart';

class RelatedSubcategory extends Subcategories {
  Category? category;

  RelatedSubcategory({
    super.id,
    super.serverId,
    super.isCategoryReference,
    super.icon,
    super.iconFontFamily,
    super.name,
    this.category,
  });

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'server_id': serverId,
      'is_category_reference': isCategoryReference,
      'icon': icon,
      'icon_font_family': iconFontFamily,
      'name': name,
      'category': category,
    };
  }

  @override
  String toString() => Convertions.classToString("RelatedSubcategory", toMap());
}