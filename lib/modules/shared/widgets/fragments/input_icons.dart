import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/drivers/local/models/icon.dart' as model;
import 'package:wallet/modules/shared/widgets/modals/icons.dart';

class InputIcon extends StatefulWidget {
  final bool? readOnly;
  final InputDecoration? decoration;
  final void Function(model.Icon value)? onChange;
  model.Icon? selectedIcon;

  InputIcon({
    super.key,
    this.readOnly,
    this.selectedIcon,
    this.decoration,
    this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _InputIconState();
}

class _InputIconState extends State<InputIcon> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  
  model.Icon? selectedIcon;
  TextEditingController? controller;

  @override
  void initState() {
    selectedIcon = widget.selectedIcon;
    controller = TextEditingController(text: selectedIcon?.name);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.decoration?.labelText ?? context.l10n!.icon,
        suffixIcon: widget.decoration?.suffixIcon ?? const Icon(Icons.keyboard_arrow_down_sharp),
        prefixIcon: Icon(selectedIcon == null ? Icons.mood : IconData(selectedIcon!.hexCode!, fontFamily: selectedIcon?.iconFontFamily)),
        iconColor: widget.decoration?.iconColor ?? AppTheme.of(context).contrast,
        suffixIconConstraints: const BoxConstraints(maxWidth: 24),
      ),
      controller: controller,
      readOnly: widget.readOnly ?? true,
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => IconsModal(
          selectedIcon: selectedIcon,
          onChange: (icon) {
            if (widget.onChange != null) widget.onChange!(icon);
            widget.selectedIcon = icon; 
            setState(() {
              selectedIcon = widget.selectedIcon;
              controller?.text = selectedIcon?.name ?? '';
            });
            Navigator.of(context).pop();
          },
        )
      ),
    );
  }
}