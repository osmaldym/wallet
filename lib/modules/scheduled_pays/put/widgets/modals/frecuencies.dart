import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:collection/collection.dart';
import 'package:wallet/core/utils/utils.dart';
import 'package:wallet/modules/shared/drivers/local/models/frecuency.dart';
import 'package:wallet/modules/shared/drivers/local/models/record_repetition.dart';
import 'package:wallet/modules/shared/widgets/fragments/chip.dart' as component;
import 'package:wallet/modules/shared/widgets/fragments/input_date.dart';

class FrecuenciesModal extends StatefulWidget {
  void Function(FrecuencyData)? onCompleted;
  FrecuencyData? frecuencyData;
  DateTime datetimeBased;

  FrecuenciesModal({
    super.key,
    this.onCompleted,
    this.frecuencyData,
    required this.datetimeBased
  });

  @override
  State<StatefulWidget> createState() => _FrecuenciesModalState();
}

class _FrecuenciesModalState extends State<FrecuenciesModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final Iterable<String> _weekDays = DateFormat().dateSymbols.WEEKDAYS.map((el) => el[0].toUpperCase()[0]);  

  bool _chipOnceSelected = false;
  bool _chipDailySelected = false;
  bool _chipWeeklySelected = false;
  bool _chipMonthlySelected = false;
  bool _chipAnnuallySelected = false;

  bool _chipEverSelected = false;
  bool _chipToMaxDateSelect = false;
  bool _chipQuantityOfTimesSelect = false;

  late List<component.Chip> _chipsType;
  late List<component.Chip> _chipsRepetition;

  get isSomeChipTypeSelected => _chipOnceSelected || _chipDailySelected || _chipWeeklySelected || _chipMonthlySelected || _chipAnnuallySelected;
  get isSomeChipRepetitionSelected => _chipEverSelected || _chipToMaxDateSelect || _chipQuantityOfTimesSelect;

  String? _timesPlaced;
  String? _repeatedTimes;
  List<int> _daysOfWeekSelected = [];
  String? _selectedConstancyTitle;
  RepeatEvery? _repeatEvery;
  RRFor? _rrFor;
  FrecuencyMontlyOption? _selectedMonthlyOption;
  DateTime? _forDate;
  int? _weekNumber;
  int? _everyNumberDay;

  FrecuencyData onCompletedData = FrecuencyData();
  final Utils _utils = Utils();

  bool _isLastDayOfMonth = false;

  final FocusNode _everyDaysFocus = FocusNode();
  final TextEditingController _everyDaysController = TextEditingController();
  final FocusNode _timesFocus = FocusNode();

  void setDefaultsAllTypes() {
    _chipOnceSelected = false;
    _chipDailySelected = false;
    _chipWeeklySelected = false;
    _chipMonthlySelected = false;
    _chipAnnuallySelected = false;

    _daysOfWeekSelected.clear();
    _timesPlaced = "1";
    _selectedMonthlyOption = null;
  }

  void setDefaultsAllRepetitions() {
    _chipEverSelected = false;
    _chipToMaxDateSelect = false;
    _chipQuantityOfTimesSelect = false;

    _repeatedTimes = null;
    _forDate = null;
  }

  @override
  void initState() {
    super.initState();
    _everyDaysFocus.requestFocus();

    _isLastDayOfMonth = _utils.isLastDayOfMonth(widget.datetimeBased);

    _selectedConstancyTitle = widget.frecuencyData?.title ?? "Once";
    _repeatEvery = widget.frecuencyData?.repeatEvery ?? RepeatEvery.once;
    _rrFor = widget.frecuencyData?.rrFor;
    _selectedMonthlyOption = widget.frecuencyData?.selectedMonthlyOption;
    _timesPlaced = (widget.frecuencyData?.timesPlaced).toString();
    _repeatedTimes = (widget.frecuencyData?.repeatedTimes).toString();
    _daysOfWeekSelected = widget.frecuencyData?.selectedDaysOfWeek ?? [];
    _forDate = widget.frecuencyData?.forDate;

    switch (_repeatEvery) {
      case RepeatEvery.day:
        _chipDailySelected = true;
        break;

      case RepeatEvery.week:
        _chipWeeklySelected = true;
        break;

      case RepeatEvery.month:
        _chipMonthlySelected = true;
        break;

      case RepeatEvery.anual:
        _chipAnnuallySelected = true;
        break;

      default:
        _chipOnceSelected = true;
    }

    switch (_rrFor) {
      case RRFor.date:
        _chipToMaxDateSelect = true;

      case RRFor.toTimes:
        _chipQuantityOfTimesSelect = true;

      default:
        _chipEverSelected = true;
    }

    _everyDaysController.text = _timesPlaced ?? "";
  }

  @override
  void dispose() {
    onCompletedData.title = _selectedConstancyTitle;
    onCompletedData.repeatEvery = _repeatEvery;
    onCompletedData.timesPlaced = int.tryParse(_timesPlaced ?? "") ;
    onCompletedData.repeatedTimes = int.tryParse(_repeatedTimes ?? "");
    onCompletedData.selectedDaysOfWeek = _daysOfWeekSelected;
    onCompletedData.rrFor = _rrFor;
    onCompletedData.selectedMonthlyOption = _selectedMonthlyOption;
    onCompletedData.forDate = _forDate;
    onCompletedData.weekNumber = _weekNumber;
    onCompletedData.everyNumberDay = _everyNumberDay;
    
    if (widget.onCompleted != null) widget.onCompleted!(onCompletedData);

    if (onCompletedData.timesPlaced == null) {
      onCompletedData.title = "Once";
      onCompletedData.repeatEvery = RepeatEvery.once;
    }

    if (onCompletedData.repeatedTimes == null) onCompletedData.rrFor = RRFor.ever;

    super.dispose();
  }

  void focusAndCursorEnd(FocusNode focusNode, TextEditingController controller) {
    focusNode.requestFocus();
    controller.selection = TextSelection.collapsed(offset: controller.text.length);
  }
  
  @override
  Widget build(BuildContext context) {
    _chipsRepetition = [
      component.Chip(
        selected: _chipEverSelected,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllRepetitions();
            _chipEverSelected = selected;
            if (!isSomeChipRepetitionSelected) _chipEverSelected = true;
            _rrFor = RRFor.ever;
          });
        },
        txtColor: !_chipEverSelected ? AppTheme.of(context).textContrast : null,
        text: "Ever",
      ),
      component.Chip(
        selected: _chipToMaxDateSelect,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllRepetitions();
            _chipToMaxDateSelect = selected;
            if (!isSomeChipRepetitionSelected) _chipToMaxDateSelect = true;
            _rrFor = RRFor.date;
            _forDate = DateTime.now();
          });
        },
        txtColor: !_chipToMaxDateSelect ? AppTheme.of(context).textContrast : null,
        text: "To max date",
      ),
      component.Chip(
        selected: _chipQuantityOfTimesSelect,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllRepetitions();
            _chipQuantityOfTimesSelect = selected;
            if (!isSomeChipRepetitionSelected) _chipQuantityOfTimesSelect = true;
            _rrFor = RRFor.toTimes;
            _repeatedTimes = "5";
          });
          _timesFocus.requestFocus();
        },
        txtColor: !_chipQuantityOfTimesSelect ? AppTheme.of(context).textContrast : null,
        text: "To quantity of times",
      ),
    ];

    _chipsType = [
      component.Chip(
        selected: _chipOnceSelected,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllTypes();
            _chipOnceSelected = selected;
            if (!isSomeChipTypeSelected) _chipOnceSelected = true;
            _selectedConstancyTitle = "Once";
            _repeatEvery = RepeatEvery.once;
          });
        },
        txtColor: !_chipOnceSelected ? AppTheme.of(context).textContrast : null,
        text: "Once",
      ),
      component.Chip(
        selected: _chipDailySelected,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllTypes();
            _chipDailySelected = selected;
            if (!isSomeChipTypeSelected) _chipOnceSelected = true;
            _selectedConstancyTitle = "Repeat daily";
            _repeatEvery = RepeatEvery.day;
          });
          focusAndCursorEnd(_everyDaysFocus, _everyDaysController);
        },
        txtColor: !_chipDailySelected ? AppTheme.of(context).textContrast : null,
        text: "Repeat daily",
      ),
      component.Chip(
        selected: _chipWeeklySelected,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllTypes();
            _chipWeeklySelected = selected;
            if (!isSomeChipTypeSelected) _chipOnceSelected = true;
            _selectedConstancyTitle = "Repeat weekly";
            _repeatEvery = RepeatEvery.week;
          });
          focusAndCursorEnd(_everyDaysFocus, _everyDaysController);
        },
        txtColor: !_chipWeeklySelected ? AppTheme.of(context).textContrast : null,
        text: "Repeat weekly",
      ),
      component.Chip(
        selected: _chipMonthlySelected,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllTypes();
            _chipMonthlySelected = selected;
            if (!isSomeChipTypeSelected) _chipOnceSelected = true;
            _selectedConstancyTitle = "Repeat monthly";
            _repeatEvery = RepeatEvery.month;
            _selectedMonthlyOption = FrecuencyMontlyOption.sameDay;
          });
          focusAndCursorEnd(_everyDaysFocus, _everyDaysController);
        },
        txtColor: !_chipMonthlySelected ? AppTheme.of(context).textContrast : null,
        text: "Repeat monthly",
      ),
      component.Chip(
        selected: _chipAnnuallySelected,
        onSelected: (selected) {
          setState(() {
            setDefaultsAllTypes();
            _chipAnnuallySelected = selected;
            if (!isSomeChipTypeSelected) _chipDailySelected = true;
            _selectedConstancyTitle = "Repeat annually";
            _repeatEvery = RepeatEvery.anual;
          });
          focusAndCursorEnd(_everyDaysFocus, _everyDaysController);
        },
        txtColor: !_chipAnnuallySelected ? AppTheme.of(context).textContrast : null,
        text: "Repeat annually",
      ),
    ];

    return SingleChildScrollView(
      key: _scaffoldKey,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppTheme.of(context).seedBgColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Constancy:", style: TextStyle(fontSize: 22)),
                  IconButton(
                    icon: const Icon(Icons.done),
                    color: AppTheme.of(context).primary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _chipsType.length,
                  itemBuilder: (context, i) => Padding(
                    padding: EdgeInsets.only(right: i < _chipsType.length-1 ? 10 : 0,),
                    child: _chipsType[i],
                  )
                )
              ),
              if (!_chipOnceSelected)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 10,
                  children: [
                    const Text("Every"),
                    SizedBox(
                      width: 40,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _everyDaysController,
                        textAlign: TextAlign.center,
                        onChanged: (val) => _timesPlaced = val,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        focusNode: _everyDaysFocus,
                        autofocus: true,
                      ),
                    ),
                    if (_chipDailySelected) const Text("days"),
                    if (_chipWeeklySelected) const Text("weeks"),
                    if (_chipMonthlySelected) const Text("months"),
                    if (_chipAnnuallySelected) const Text("years"),
                  ],
                ),

              if (_chipWeeklySelected)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:  _weekDays.mapIndexed((i, text) =>
                    TextButton(
                      onPressed: () => setState(() {
                        _daysOfWeekSelected.contains(i) ? _daysOfWeekSelected.remove(i) : _daysOfWeekSelected.add(i);
                      }),
                      style: TextButton.styleFrom(
                        backgroundColor: _daysOfWeekSelected.contains(i) ? AppTheme.of(context).primary : Colors.grey.withAlpha(50),
                        padding: const EdgeInsets.all(0),
                        minimumSize: const Size(45, 45)
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: _daysOfWeekSelected.contains(i) ? Colors.black : AppTheme.of(context).textContrast,
                        ),
                      ),
                    )
                  ).toList(),
                ),

              if (_chipMonthlySelected)
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RadioListTile<FrecuencyMontlyOption>(
                      title: const Text("Same day of month"),
                      selected: FrecuencyMontlyOption.sameDay == _selectedMonthlyOption,
                      value: FrecuencyMontlyOption.sameDay,
                      groupValue: _selectedMonthlyOption,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      onChanged: (FrecuencyMontlyOption? option) => setState(() { _selectedMonthlyOption = option; }),
                    ),
                    RadioListTile<FrecuencyMontlyOption>(
                      title: Text("Every ${ _utils.getWeekPositionInMonth(widget.datetimeBased) } ${DateFormat("EEEE").format(widget.datetimeBased)}"),
                      selected: FrecuencyMontlyOption.everySemanalDay == _selectedMonthlyOption,
                      value: FrecuencyMontlyOption.everySemanalDay,
                      groupValue: _selectedMonthlyOption,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      onChanged: (FrecuencyMontlyOption? option) => setState(() {
                        _selectedMonthlyOption = option;
                        _weekNumber = _utils.getWeekPositionInMonth(widget.datetimeBased);
                        _everyNumberDay = widget.datetimeBased.weekday;
                      }),
                    ),
                    RadioListTile<FrecuencyMontlyOption>(
                      title: const Text("Every last day of month"),
                      selected: FrecuencyMontlyOption.everyLastDay == _selectedMonthlyOption,
                      value: FrecuencyMontlyOption.everyLastDay,
                      groupValue: _selectedMonthlyOption,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      onChanged: _isLastDayOfMonth ? (FrecuencyMontlyOption? option) => setState(() { _selectedMonthlyOption = option; }) : null,
                    ),
                  ],
                ),

              if (!_chipOnceSelected) ...[
                const Text("Repetition:", style: TextStyle(fontSize: 22)),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _chipsRepetition.length,
                    itemBuilder: (context, i) => Padding(
                      padding: EdgeInsets.only(right: i < _chipsRepetition.length-1 ? 10 : 0,),
                      child: _chipsRepetition[i],
                    )
                  )
                ),

                if (_chipToMaxDateSelect)
                  InputDate(
                    selectedDate: _forDate!,
                    firstDate: DateTime.now(),
                    onChanged: (newDate) => _forDate = newDate,
                  ),

                if (_chipQuantityOfTimesSelect)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 10,
                    children: [
                      SizedBox(
                        width: 40,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text: _repeatedTimes,
                          ),
                          textAlign: TextAlign.center,
                          onChanged: (val) => _repeatedTimes = val,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          focusNode: _timesFocus,
                          autofocus: true,
                        ),
                      ),
                      const Text("times"),
                    ],
                  ),
              ]
            ]
          )
        )
      )
    );
  }
}