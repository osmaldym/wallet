import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/goals/widgets/fragments/circular_progress_bar.dart';
import 'package:wallet/modules/shared/drivers/local/models/icon.dart' as model;

class GoalModal extends StatefulWidget {
  String? title;
  model.Icon? icon;
  double? total;
  double? saved;
  String? suggestedAdding;
  DateTime? dateFrom;
  DateTime? dateTo;
  bool? automatic;

  GoalModal({
    super.key,
    this.automatic,
    this.dateFrom,
    this.dateTo,
    this.icon,
    this.saved,
    this.title,
    this.total,
    this.suggestedAdding,
  });

  @override
  State<StatefulWidget> createState() => _GoalModalState();
}

class _GoalModalState extends State<GoalModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final double fontSize = 18;
  final FontWeight fontWeight = FontWeight.bold;

  NumberFormat? format;
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    format ??= NumberFormat("#,###.##", context.l10n?.localeName ?? "en_US");
    int monthQuantity = DateUtils.monthDelta(widget.dateFrom ?? DateTime.now(), widget.dateTo ?? DateTime.now());

    return SingleChildScrollView(
      key: _scaffoldKey,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppTheme.of(context).seedBgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                spacing: 15,
                children: [
                  CCircularProgressIndicator(
                    size: 120,
                    value: (widget.saved ?? 0) / (widget.total ?? 0),
                    strokeWidth: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          size: 58,
                          color: AppTheme.of(context).textContrast,
                          widget.icon?.hashCode != null ? IconData(widget.icon!.hexCode!, fontFamily: widget.icon?.iconFontFamily) : Icons.flag_outlined,
                        ),
                        Text(
                          '${format!.format(((widget.saved ?? 0) / (widget.total ?? 0) * 100))}%',
                          style: TextStyle(
                            color: AppTheme.of(context).greenContrast,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    widget.title ?? 'My goal',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ],
              ),
              Container(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3,
                  children: [
                    Text(
                      context.l10n!.total,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight
                        ),
                    ),
                    Text(
                      format!.format(widget.total ?? 0),
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      context.l10n!.saved,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      format!.format(widget.saved ?? 0),
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      context.l10n!.finalization,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight
                      ),
                    ),
                    Text(
                      utils.toReadableRelativeDate(widget.dateTo ?? DateTime.now(), context),
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      context.l10n!.suggestedAdding,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                    Text(
                      widget.suggestedAdding ?? '0',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Text(
                      context.l10n!.savingType,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                      ),
                    ),
                    Text(
                      (widget.automatic ?? false) ? context.l10n!.automatic : context.l10n!.manual,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}