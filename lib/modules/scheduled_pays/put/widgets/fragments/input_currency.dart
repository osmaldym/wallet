import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/scheduled_pays/put/widgets/modals/currency.dart';
import 'package:wallet/modules/shared/drivers/local/models/currency.dart';

class InputCurrency extends StatefulWidget {
  final bool? readOnly;
  final InputDecoration? decoration;
  Currency? controllerValue;
  final void Function(Currency value)? onChange;

  InputCurrency({
    super.key,
    this.readOnly,
    this.decoration,
    this.controllerValue,
    this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _InputCurrencyState();
}

class _InputCurrencyState extends State<InputCurrency> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.decoration?.labelText ?? context.l10n!.currency,
        suffixIcon: widget.decoration?.suffixIcon ?? const Icon(Icons.keyboard_arrow_down_sharp),
        iconColor: widget.decoration?.iconColor ?? AppTheme.of(context).contrast,
        suffixIconConstraints: const BoxConstraints(maxWidth: 24),
      ),
      controller: TextEditingController(
        text: widget.controllerValue?.iso,
      ),
      readOnly: widget.readOnly ?? true,
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => CurrencyModal(
          onSelectedItem: (Currency currency) {
            if (widget.onChange != null) widget.onChange!(currency);
            setState(() {
              widget.controllerValue = currency;
            });
          },
          selectedCurrency: widget.controllerValue,
        ),
      ),
    );
  }
}