import 'package:flutter/material.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';
import 'package:wallet/modules/shared/drivers/local/dao.dart';
import 'package:wallet/modules/shared/drivers/local/models/subcategories.dart' as model;
import 'package:wallet/modules/shared/drivers/local/models/category.dart';

class CategoriesModal extends StatefulWidget {
  void Function(model.Subcategories category, int tabIndex)? onSelectedItem;
  model.Subcategories? selectedSubcategory;
  int? initialTab;

  CategoriesModal({
    super.key,
    required this.onSelectedItem,
    this.selectedSubcategory,
    this.initialTab,
  });

  @override
  State<StatefulWidget> createState() => _CategoriesModalState();
}

class _CategoriesModalState extends State<CategoriesModal> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TabController? _tabController;
  Dao dao = Dao();

  List<Tab> _tabs = [];
  late Future<List<Category>> _categoryGroups;

  @override
  void initState() {
    super.initState();
    _categoryGroups = dao.categoryGroups();
  }

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    super.dispose();
  }

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
          )
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<List<Category>>(
                future: _categoryGroups,
                builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshotCategoryGroups) {

                  if (snapshotCategoryGroups.hasData) {
                    if (_tabs.isEmpty) {
                      _tabs.add(const Tab(text: "All"));

                      for (Category group in snapshotCategoryGroups.data!) {
                        _tabs.add(
                          Tab(
                            icon: group.icon != null ? Icon(IconData(group.icon!, fontFamily: group.iconFontFamily)) : null,
                            text: group.name!,
                          )
                        );
                      }

                      _tabController = TabController(
                        length: _tabs.length,
                        initialIndex: widget.initialTab ?? 0,
                        vsync: this,
                      );
                    }

                    return FutureBuilder<List<model.Subcategories>>(
                      future: dao.subcategories(),
                      builder: (BuildContext context, AsyncSnapshot<List<model.Subcategories>> snapshotSubcategories) {
                        if (snapshotSubcategories.hasData) {
                          return Column(
                            children: [
                              TabBar(
                                controller: _tabController,
                                tabs: _tabs,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                              ),
                              SizedBox(
                                height: 500,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: _tabs.asMap().entries.map((entryElTab) {

                                    List<dynamic> listToRender = snapshotSubcategories.data!.where(
                                      (elSubcategory) =>
                                      (entryElTab.key == 0) // If pos is 0 returns all data
                                      || (entryElTab.key > 0 // Else return by category
                                      && snapshotCategoryGroups.data![entryElTab.key-1].id == elSubcategory.categoryId)
                                    ).map((subcategory) => ListTile(
                                      title: Text(subcategory.name!),
                                      leading: subcategory.icon != null ? Icon(IconData(subcategory.icon!, fontFamily: subcategory.iconFontFamily!)) : null,
                                      enabled: true,
                                      enableFeedback: true,
                                      selected: widget.selectedSubcategory != null ? widget.selectedSubcategory?.id == subcategory.id : false,
                                      onTap: () {
                                        if (widget.onSelectedItem != null) widget.onSelectedItem!(subcategory, entryElTab.key);
                                        Navigator.pop(context);
                                      },
                                    ) as Widget).toList();

                                    // This code will be implemented soon 👀
                                    // if (entryElTab.key == 0){
                                    //   listToRender.insert(0,
                                    //       Row(
                                    //         mainAxisSize: MainAxisSize.max,
                                    //         children: [
                                    //           components.Chip(
                                    //             selected: false,
                                    //             txtColor: AppTheme.of(context).textContrast,
                                    //             onSelected: (isSelected){},
                                    //             label: const Text("Most used"),
                                    //           )
                                    //         ],
                                    //       )
                                    //   );
                                    // }
                                    
                                    return ListView.builder(
                                      padding: const EdgeInsets.only(top: 15),
                                      itemCount: listToRender.length,
                                      addSemanticIndexes: true,
                                      semanticChildCount: listToRender.length,
                                      itemBuilder: (context, i) => listToRender[i]
                                    );
                                  }).toList()
                                )
                              ),
                            ],
                          );
                        }
                        if (snapshotSubcategories.hasError) print(snapshotSubcategories.error);
                        return const Center(child: CircularProgressIndicator());
                      });

                  }
                  if (snapshotCategoryGroups.hasError) print(snapshotCategoryGroups.error);
                  return const Center(child: Text("No categories to display"));
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}