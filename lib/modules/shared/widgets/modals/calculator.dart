import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class CalculatorModal extends StatefulWidget {
  String toShow = "0";
  String plain = "";
  double? value = 0;
  void Function(double value)? onChange;
  void Function()? onOkTap;

  CalculatorModal({
    super.key,
    this.onChange,
    this.value,
    this.onOkTap,
  });

  @override
  State<StatefulWidget> createState() => _CalculatorModalState();
}

class _CalculatorModalState extends State<CalculatorModal> {
  @override
  void initState() {
    widget.value ??= 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.of(context).seedBgColor,
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(15),
          topStart: Radius.circular(15),
        )
      ),
      child: Column(
        spacing: 15,
        children: [
          Row(
            spacing: 5,
            children: [
              Expanded(
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  widget.toShow,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                )
              )
            ],
          ),
          Flexible(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              padding: const EdgeInsets.all(5),
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: [
                "AC", "del", "%", "÷",
                "7", "8", "9", "x",
                "4", "5", "6", "-",
                "1", "2", "3", "+",
                "OK", "0", ".", "=",
              ].map(
                (String txt) => GridTile(
                    child: TextButton(
                      onPressed: () => _evalAndUpdate(txt),
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        backgroundColor: Colors.white.withAlpha(10),
                      ),
                      child: txt == "del" ? const Icon(Icons.backspace_outlined) : Text(
                        txt,
                        style: TextStyle(
                          color: txt == "OK" ? Colors.green : null,
                        ),
                      ),
                    ),
                  )
              ).toList(),
            )
          ),
        ],
      ),
    );
  }

  void _evalAndUpdate(String txt){
    RegExp aritmetic = RegExp(r'[\+\-\x\÷]');
    RegExp digit = RegExp(r'[0-9]');
    RegExp isNumber = RegExp(r'^([0-9]+)+$|^([0-9]+).([0-9]+)$');
    setState(() {
      if ((widget.toShow == "0" || !digit.hasMatch(widget.toShow)) && digit.hasMatch(txt)) {
        widget.toShow = txt;
      } else if (txt == 'OK') {
        if (widget.onOkTap != null) widget.onOkTap!();
      } else if (txt == 'AC' || widget.toShow.isEmpty) {
        widget.toShow = "0";
        widget.value = 0;
      } else if (txt == 'del') {
        widget.toShow = widget.toShow.substring(0, widget.toShow.length-1);
        if (widget.toShow != "0" && widget.toShow.isEmpty) widget.toShow = "0";
      } else if (txt == "=" || (aritmetic.hasMatch(txt) && (aritmetic.hasMatch(widget.toShow)))) {
        if (isNumber.hasMatch(widget.toShow) && !aritmetic.hasMatch(widget.toShow) && widget.onOkTap != null) {
          widget.onOkTap!();
          return;
        }

        if (widget.toShow.endsWith("÷0")) {
          widget.toShow = "∞";
          return;
        }

        widget.value = _calculate(widget.toShow) ?? 0;
        widget.toShow = widget.value!.toStringAsFixed(widget.value! > widget.value!.toInt() ? 2 : 0);
        if (aritmetic.hasMatch(txt)) widget.toShow += txt;
      } else if (widget.toShow.endsWith("%")) {
        widget.toShow += "x$txt";
      } else {
        RegExp operation = RegExp(r'^([0-9]+)+$|^([0-9]+.[0-9]+[\+\-\x\÷][0-9]+)$');
        if ((txt == "." && !operation.hasMatch(widget.toShow)) 
            || widget.toShow.length > 20) return;
        widget.toShow += txt;
      }
      if (isNumber.hasMatch(widget.toShow) && !aritmetic.hasMatch(widget.toShow)) {
        widget.value = double.parse(widget.toShow.replaceAll(",", ""));
      }
    });
    if (widget.onChange != null) widget.onChange!(widget.value!);
  }

  double? _calculate(String operation) {
    List<String> splitted = [];

    if (operation.contains("%")){
      splitted = operation.split("%");
      double dec = double.tryParse(splitted[0])! / 100;
      if (splitted[1].length > 1 && splitted[1].contains("x"))
        return dec * double.tryParse(splitted[1].replaceAll("x", ""))!;
      return dec;
    }

    if (operation.contains("÷")){
      splitted = operation.split("÷");
      return double.tryParse(splitted[0])! / double.tryParse(splitted[1])!;
    }

    if (operation.contains("x")){
      splitted = operation.split("x");
      return double.tryParse(splitted[0])! * double.tryParse(splitted[1])!;
    }

    if (operation.contains("+")){
      splitted = operation.split("+");
      return double.tryParse(splitted[0])! + double.tryParse(splitted[1])!;
    }

    if (operation.contains("-")){
      splitted = operation.split("-");
      return double.tryParse(splitted[0])! - double.tryParse(splitted[1])!;
    }
    
    return double.tryParse(operation)!;
  }
}