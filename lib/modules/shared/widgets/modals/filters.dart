import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/core/extensions/datetime_ext.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';

class FiltersModalData {
  bool allYear = false;
  bool allMonth = false;
  bool allWeek = true;
  bool custom = false;
  DateTime? dateFrom;
  DateTime? dateTo;
}

class FiltersModal extends StatefulWidget {
  void Function(FiltersModalData filterData)? onSave;
  FiltersModalData? filters;
  DateTime? dateToShow;
  DateTime? dateFromToShow;

  FiltersModal({
    super.key,
    this.onSave,
    this.filters,
  });

  @override
  StatefulElement createElement() {
    filters ??= FiltersModalData();
    if (filters!.custom) {
      dateFromToShow = filters!.dateFrom;
      dateToShow = filters!.dateFrom;
    } else {
      filters!.dateFrom = DateTime.now().subtract(const Duration(days: 7));
      filters!.dateTo = DateTime.now();
    }

    return super.createElement();
  }

  @override
  State<StatefulWidget> createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void unselectAll(bool isChecked) {
    widget.filters!.allWeek = !isChecked;
    widget.filters!.allMonth = false;
    widget.filters!.allYear = false;
    widget.filters!.custom = false;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "${tr.period}:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              CheckboxListTile(
                value: widget.filters!.allWeek,
                onChanged: (isChecked) => setState(() {
                  if (isChecked ?? false) {
                    unselectAll(isChecked ?? false);
                    widget.filters!.allWeek = isChecked!;
                  }
                }),
                dense: false,
                enabled: true,
                enableFeedback: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(tr.allWeek),
              ),
              CheckboxListTile(
                value: widget.filters!.allMonth,
                onChanged: (isChecked) => setState(() {
                  unselectAll(isChecked ?? false);
                  widget.filters!.allMonth = isChecked!;
                }),
                dense: false,
                enabled: true,
                enableFeedback: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(tr.allMonth),
              ),
              CheckboxListTile(
                value: widget.filters!.allYear,
                onChanged: (isChecked) => setState(() {
                  unselectAll(isChecked ?? false);
                  widget.filters!.allYear = isChecked!;
                }),
                dense: false,
                enabled: true,
                enableFeedback: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(tr.allYear),
              ),
              CheckboxListTile(
                value: widget.filters!.custom,
                onChanged: (isChecked) => setState(() {
                    unselectAll(isChecked ?? false);
                    widget.filters!.custom = isChecked!;
                }),
                dense: false,
                enabled: true,
                enableFeedback: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(tr.custom),
              ),
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: InputDate(
                      title: tr.from,
                      enabled: widget.filters!.custom,
                      selectedDate: widget.filters!.dateFrom!,
                      onChanged: (val) => widget.dateFromToShow = val,
                    )
                  ),
                  Expanded(
                    child: InputDate(
                      enabled: widget.filters!.custom,
                      title: tr.to,
                      selectedDate: widget.filters!.dateTo!,
                      onChanged: (val) => widget.dateToShow = val,
                    )
                  ),
                ]
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: CButton(
                  onPressed: () {
                    DateTime now = DateTime.now();

                    if (widget.filters!.allWeek) {
                      widget.filters!.dateFrom = now.getFirstDayOfWeek();
                      widget.filters!.dateTo = now.getLastDayOfWeek();
                    }

                    if (widget.filters!.allMonth) {
                      widget.filters!.dateFrom = now.recreateInTimeZero(day: 1);
                      widget.filters!.dateTo = now.recreateInTimeLastSecond(year: now.year, month: now.month+1, day: 0);
                    }

                    if (widget.filters!.allYear) {
                      widget.filters!.dateFrom = now.recreateInTimeZero(month: now.month, day: 1);
                      widget.filters!.dateTo = now.recreateInTimeLastSecond(year: now.year+1, month: 1, day: 1).subtract(const Duration(days: 1));
                    }

                    if (widget.filters!.custom) {
                      widget.filters!.dateFrom = widget.dateFromToShow;
                      widget.filters!.dateTo = widget.dateToShow;
                    }

                    if (widget.onSave != null) widget.onSave!(widget.filters!); 
                  },
                  text: tr.save,
                ),
              )
            ],
          )
        )
      ),
    );
  }
}