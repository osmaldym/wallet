import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';

class SavingOperationModal extends StatefulWidget {
  String? suggested;
  double? saved;
  bool? decrease;
  void Function(double? amount)? onPress;

  SavingOperationModal({
    super.key,
    this.saved,
    this.suggested,
    this.onPress,
    this.decrease,
  });

  @override
  State<StatefulWidget> createState() => _SavingOperationModalState();
}

class _SavingOperationModalState extends State<SavingOperationModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  double? amount = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 1,
      initialChildSize: .62,
      minChildSize: .4,
      snap: true,
      snapSizes: const [.62, 1],
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        children: [
          Container(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.decrease ?? false ? context.l10n!.decreaseSavings : context.l10n!.increaseSavings,
                    style: const TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  InputCalculator(
                    currentValue: amount,
                    onChange: (double? val) => amount = val,
                  ),
                  if (widget.decrease != null && widget.decrease == false)
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
          )  
        ],
      )
    );
  }
}