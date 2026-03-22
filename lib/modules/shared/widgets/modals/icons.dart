import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/core/utils/app_localizations_x.dart';
import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/icon.dart' as model;
import 'package:wallet/modules/shared/widgets/fragments/input_search.dart';

class IconsModal extends StatefulWidget {
  model.Icon? selectedIcon;
  void Function(model.Icon icon)? onChange;
  Dao dao = Dao();

  IconsModal({
    super.key,
    this.selectedIcon,
    this.onChange,
  });

  @override
  State<StatefulWidget> createState() => _IconsModalState();
}

class _IconsModalState extends State<IconsModal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  model.Icon? selectedIcon;
  Future<List<model.Icon>>? allIcons;

  @override
  void initState() {
    selectedIcon = widget.selectedIcon;
    allIcons = widget.dao.icons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: _scaffoldKey,
      child: Container(
        width: double.maxFinite,
        height: 500,
        decoration: BoxDecoration(
          color: AppTheme.of(context).seedBgColor,
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(25),
            topEnd: Radius.circular(25)
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child:
            FutureBuilder<List<model.Icon>>(
              future: allIcons,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<InputSearchElement> elemsToSearch = [];

                  if (snapshot.hasData) elemsToSearch = [ 
                    for (final icon in snapshot.data!)
                      InputSearchElement(
                        text: icon.name!,
                        icon: IconData(icon.hexCode!, fontFamily: icon.iconFontFamily),
                        element: icon,
                      )
                  ];

                  return Column(
                    spacing: 25,
                    children: [
                      InputSearch<model.Icon>(
                        items: elemsToSearch,
                        onSelectedItem: (model.Icon icon) {
                          if (widget.onChange != null) widget.onChange!(icon);
                        },
                        customSearch: (input, element) {
                          if (input.toLowerCase().contains(element)) return true;
                          return false;
                        },
                      ),
                      Expanded(
                        child:
                        ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(snapshot.data?[i].name ?? context.l10n!.unknown),
                              selected: selectedIcon != null && snapshot.data![i].id == selectedIcon?.id,
                              leading: Icon(IconData(snapshot.data![i].hexCode!, fontFamily: snapshot.data![i].iconFontFamily)),
                              onTap: () {
                                if (widget.onChange != null) widget.onChange!(snapshot.data![i]);
                              }
                            );
                          }
                        )
                      )
                    ]
                  );
                }

                if (snapshot.hasError) return const Text('ERROR');

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            ),
        )
      ),
    );
  }
}