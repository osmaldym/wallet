import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/core/extensions/datetime_ext.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';

class FiltersModalData {
  bool allYear = false;
  bool allMonth = true;
  bool allWeek = false;
  bool custom = false;
  DateTime? dateFrom;
  DateTime? dateTo;
  DateTime? customDateFrom;
  DateTime? customDateTo;

  FiltersModalData() {
    DateTime now = DateTime.now();
    dateFrom = now.recreateInTimeZero(day: 1);
    dateTo = now.recreateInTimeLastSecond(year: now.year, month: now.month+1, day: 0);
  }
}

class FiltersModal extends StatefulWidget {
  void Function(FiltersModalData filterData)? onSave;
  FiltersModalData? filters;

  FiltersModal({
    super.key,
    this.onSave,
    this.filters,
  });

  @override
  StatefulElement createElement() {
    filters ??= FiltersModalData();
    return super.createElement();
  }

  @override
  State<StatefulWidget> createState() => _FiltersModalState();
}

class _FiltersModalState extends State<FiltersModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void unselectAll(bool isChecked) {
    widget.filters!.allMonth = !isChecked;
    widget.filters!.allWeek = false;
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
                      selectedDate: widget.filters!.customDateFrom ?? widget.filters!.dateFrom!,
                      onChanged: (val) => widget.filters!.customDateFrom = val,
                    )
                  ),
                  Expanded(
                    child: InputDate(
                      enabled: widget.filters!.custom,
                      title: tr.to,
                      selectedDate: widget.filters!.customDateTo ?? widget.filters!.dateTo!,
                      onChanged: (val) => widget.filters!.customDateTo = val,
                    )
                  ),
                ]
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: CButton(
                  onPressed: () {
                    DateTime now = DateTime.now();

                    if (widget.filters?.allWeek ?? false) {
                      widget.filters!.dateFrom = now.getFirstDayOfWeek();
                      widget.filters!.dateTo = now.getLastDayOfWeek();
                    }

                    if (widget.filters?.allMonth ?? false) {
                      widget.filters!.dateFrom = now.recreateInTimeZero(day: 1);
                      widget.filters!.dateTo = now.recreateInTimeLastSecond(year: now.year, month: now.month+1, day: 0);
                    }

                    if (widget.filters?.allYear ?? false) {
                      widget.filters!.dateFrom = now.recreateInTimeZero(month: now.month, day: 1);
                      widget.filters!.dateTo = now.recreateInTimeLastSecond(year: now.year+1, month: 1, day: 1).subtract(const Duration(days: 1));
                    }

                    if (widget.filters?.custom ?? false) {
                      widget.filters!.dateFrom =  widget.filters!.customDateFrom;
                      widget.filters!.dateTo = widget.filters!.customDateTo;
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