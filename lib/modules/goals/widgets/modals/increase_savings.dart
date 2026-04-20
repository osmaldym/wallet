import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';

class IncreaseSavingsModal extends StatefulWidget {
  String? suggested;
  double? saved;
  void Function(double? amount)? onPress;

  IncreaseSavingsModal({
    super.key,
    this.saved,
    this.suggested,
    this.onPress,
  });

  @override
  State<StatefulWidget> createState() => _IncreaseSavingsModalState();
}

class _IncreaseSavingsModalState extends State<IncreaseSavingsModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  double? amount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              context.l10n!.increaseSavings,
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            InputCalculator(
              currentValue: amount,
              onChange: (double? val) => amount = val,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                spacing: 15,
                children: [
                  Icon(Icons.lightbulb_outlined, color: AppTheme.of(context).primary,),
                  Text(
                    "${context.l10n!.suggested}: ${widget.suggested ?? 0}",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.of(context).primary
                    ),
                  ),
                ],
              ),
            ),
            CButton(
              text: context.l10n!.save,
              onPressed: () {
                if (widget.onPress != null) widget.onPress!(amount);
              },
            )
          ]
        ),
      ),
    );
  }
}