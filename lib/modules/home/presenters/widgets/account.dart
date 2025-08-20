import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/extensions/object_ext.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/drivers/local/models/account.dart';
import 'package:wallet/modules/shared/widgets/fragments/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wallet/modules/shared/widgets/fragments/input_calculator.dart';
import 'package:wallet/modules/shared/widgets/fragments/alert_card.dart';

class AccountModal extends StatefulWidget {
  bool? isEditing;
  bool? showAlertCreatingNewAccount;
  void Function(Account account) onSave;
  Account? account;

  AccountModal({
    super.key,
    required this.onSave,
    this.showAlertCreatingNewAccount,
    this.isEditing,
    this.account
  }) {
    if (account == null){
      account = Account();
      account?.isTotal = false;
    }
  }

  @override
  _AccountModalState createState() => _AccountModalState();
}

class _AccountModalState extends State<AccountModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? title;
  double? amount;

  @override
  void initState() {
    title = widget.account?.title;
    amount = widget.account?.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? tr = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      key: _scaffoldKey,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
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
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isEditing.toBool() ? tr.editingAccount : tr.newAccount,
                style: const TextStyle(fontSize: 32)
              ),
              if (widget.showAlertCreatingNewAccount ?? false)
                AlertCard(
                  subtitle: Text(
                    context.l10n!.warningCreatingNewAccount,
                    style: const TextStyle(
                      color: Colors.black
                    ),
                  ),
                ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: tr.account,
                ),  
                autofocus: true,
                enabled: !(widget.account?.isTotal ?? false),
                controller: TextEditingController(text: title),
                onChanged: (String val) => title = val,
              ),
              InputCalculator(
                controllerValue: amount,
                onChange: (amount) => this.amount = amount,
              ),
              CButton(
                text: tr.save,
                onPressed: () {
                  widget.account?.title = title;
                  widget.account?.amount = amount;

                  widget.onSave(widget.account!);
                  Navigator.pop(context);
                }
              )
            ],
          ),
        )
      )
    );
  }
}