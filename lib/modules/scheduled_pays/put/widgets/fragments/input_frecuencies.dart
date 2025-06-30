import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/scheduled_pays/put/widgets/modals/frecuencies.dart';
import 'package:wallet/modules/shared/drivers/local/models/frecuency.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';

class InputFrecuencies extends StatefulWidget {
  final bool? readOnly;
  final InputDecoration? decoration;
  final void Function(FrecuencyData value)? onChange;
  FrecuencyData? value;
  AppLocalizations? tr;
  String? text;
  ValueNotifier<DateTime?>? dateTimeBasedNotifier;

  InputFrecuencies({
    super.key,
    this.readOnly,
    this.decoration,
    this.onChange,
    this.dateTimeBasedNotifier,
    this.value
  });

  @override
  State<StatefulWidget> createState() => _InputFrecuenciesState();
}

class _InputFrecuenciesState extends State<InputFrecuencies> {
  @override
  Widget build(BuildContext context) {

    if (widget.value != null) {
      if (widget.value?.title == null || (widget.value?.title! ?? "").isEmpty)
        switch(widget.value?.repeatEvery) {
          case RepeatEvery.once: 
            widget.value?.title = "Once";
            break;
          case RepeatEvery.day: 
            widget.value?.title = "Repeat daily";
            break;
          case RepeatEvery.week: 
            widget.value?.title = "Repeat weekly";
            break;
          case RepeatEvery.month: 
            widget.value?.title = "Repeat monthly";
            break;
          case RepeatEvery.anual: 
            widget.value?.title = "Repeat annually";
            break;
          default:
        }
      
      widget.text = widget.value?.title;
    }

    widget.tr = AppLocalizations.of(context)!;
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.decoration?.labelText ?? widget.tr!.frecuency,
        suffixIcon: widget.decoration?.suffixIcon ?? const Icon(Icons.keyboard_arrow_down_sharp),
        iconColor: widget.decoration?.iconColor ?? AppTheme.of(context).contrast,
        suffixIconConstraints: const BoxConstraints(maxWidth: 24),
      ),
      controller: TextEditingController(
        text: widget.text,
      ),
      readOnly: widget.readOnly ?? true,
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => FrecuenciesModal(
          datetimeBased: widget.dateTimeBasedNotifier?.value ?? DateTime.now(),
          onCompleted: (data) {
            // This code is necessatry if don't use it, it throws an "setState() or markNeedsBuild() called when widget tree was locked" for some reason.
            WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              widget.value = data;
              widget.text = data.title!;
            }));

            if (widget.onChange != null) widget.onChange!(data);
          },
          frecuencyData: widget.value,
        ),
      ),
    );
  }
}