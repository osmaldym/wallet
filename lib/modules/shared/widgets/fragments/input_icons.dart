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
  TextEditingController? controller;

  InputIcon({
    super.key,
    this.readOnly,
    this.selectedIcon,
    this.decoration,
    this.onChange,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() => _InputIconState();
}

class _InputIconState extends State<InputIcon> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool controllerWasNull = false;
  TextEditingController? controller;

  @override
  void initState() {
    controllerWasNull = widget.controller == null;
    controller = widget.controller ?? TextEditingController(text: widget.selectedIcon?.name ?? '');
    super.initState();
  }

  @override
  void dispose() {
    if (!controllerWasNull) controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InputIcon oldWidget) {
    widget.selectedIcon = widget.selectedIcon;
    if (controllerWasNull) controller?.text = widget.selectedIcon?.name ?? '';
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.decoration?.labelText ?? context.l10n!.icon,
        suffixIcon: widget.decoration?.suffixIcon ?? const Icon(Icons.keyboard_arrow_down_sharp),
        prefixIcon: Icon(widget.selectedIcon == null ? Icons.mood : IconData(widget.selectedIcon!.hexCode!, fontFamily: widget.selectedIcon?.iconFontFamily)),
        iconColor: widget.decoration?.iconColor ?? AppTheme.of(context).contrast,
        suffixIconConstraints: const BoxConstraints(maxWidth: 24),
      ),
      controller: controller,
      readOnly: widget.readOnly ?? true,
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => IconsModal(
          selectedIcon: widget.selectedIcon,
          onChange: (icon) {
            if (widget.onChange != null) widget.onChange!(icon);
            setState(() {
              widget.selectedIcon = icon;
            });
            controller?.text = widget.selectedIcon?.name ?? '';
            Navigator.of(context).pop();
          },
        )
      ),
    );
  }
}