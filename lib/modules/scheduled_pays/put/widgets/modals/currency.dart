import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/currency.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_search.dart';

class CurrencyModal extends StatefulWidget {
  void Function(Currency element)? onSelectedItem;
  Currency? selectedCurrency;

  CurrencyModal({
    super.key,
    this.onSelectedItem,
    this.selectedCurrency,
  });

  @override
  State<StatefulWidget> createState() => _CurrencyModalState();
}

class _CurrencyModalState extends State<CurrencyModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final Dao dao = Dao();

  @override
  Widget build(BuildContext context) {
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
            spacing: 15,
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<List<Currency>>(
                future: dao.currencies(),
                builder: (BuildContext context, AsyncSnapshot<List<Currency>> snapshotSubcategories) {
                  List<InputSearchElement> elemsToSearch = [];
                  List<ListTile> elemsToRender = [];

                  if (snapshotSubcategories.hasData) {
                    for (final currency in snapshotSubcategories.data!){
                      elemsToRender.add(ListTile(
                        title: Text(currency.iso!),
                        leading: CircleAvatar(
                          child: Text(currency.symbol!),
                        ),
                        enabled: true,
                        selected: widget.selectedCurrency != null ? widget.selectedCurrency?.id == currency.id : false,
                        onTap: () {
                          if (widget.onSelectedItem != null) widget.onSelectedItem!(currency);
                          Navigator.pop(context);
                        },
                      ));

                      elemsToSearch.add(InputSearchElement(
                        text: currency.iso!,
                        whereSearch: [currency.iso!, currency.symbol!],
                        leading: CircleAvatar(
                          child: Text(currency.symbol!),
                        ),
                        element: currency,
                      ));
                    }
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 10,
                    children: [
                      InputSearch<Currency>(
                        items: elemsToSearch,
                        onSelectedItem: (element) {
                          if (widget.onSelectedItem != null) widget.onSelectedItem!(element);
                          Navigator.pop(context);
                        }
                      ),
                      SizedBox(
                        height: 350,
                        child: ListView.builder(
                          itemCount: elemsToRender.length,
                          itemBuilder: (context, i) => elemsToRender[i],
                        )
                      ),
                    ],
                  );
                }
              ),
            ]
          ),
        ),
      )
    );
  }
}