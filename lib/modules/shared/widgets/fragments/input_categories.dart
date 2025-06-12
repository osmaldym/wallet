import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart';
import 'package:wallet/modules/shared/widgets/modals/categories.dart';

class InputCategories extends StatefulWidget {
  final bool? readOnly;
  final InputDecoration? decoration;
  final void Function()? onTap;
  final void Function(Subcategories value)? onChange;
  Subcategories? controllerValue;
  int? tabSelectedIndex;
  AppLocalizations? tr;

  InputCategories({
    super.key,
    this.onTap,
    this.readOnly,
    this.decoration,
    this.onChange,
    this.controllerValue,
  });

  @override
  State<StatefulWidget> createState() => _InputCategoriesState();
}

class _InputCategoriesState extends State<InputCategories> {
  @override
  Widget build(BuildContext context) {
    widget.tr = AppLocalizations.of(context)!;
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.decoration?.labelText ?? widget.tr!.category,
        suffixIcon: widget.decoration?.suffixIcon ?? const Icon(Icons.keyboard_arrow_down_sharp),
        iconColor: widget.decoration?.iconColor ?? AppTheme.of(context).contrast,
        suffixIconConstraints: const BoxConstraints(maxWidth: 24),
      ),
      controller: TextEditingController(
        text: widget.controllerValue?.name,
      ),
      readOnly: widget.readOnly ?? true,
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => CategoriesModal(
          onSelectedItem: (subcategory, tabIndex) {
            if (widget.onChange != null) widget.onChange!(subcategory);
            setState(() {
              widget.controllerValue = subcategory;
              widget.tabSelectedIndex = tabIndex;
            });
          },
          initialTab: widget.tabSelectedIndex,
          selectedSubcategory: widget.controllerValue,
        ),
      ),
    );
  }
}