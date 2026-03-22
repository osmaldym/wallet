import 'package:flutter/material.dart';

class InputSearchElement<T> {
  String text;
  IconData? icon;
  Widget? leading;
  List<String>? whereSearch;
  T? element;

  InputSearchElement({
    required this.text,
    this.icon,
    this.leading,
    this.whereSearch,
    this.element
  });
}

class InputSearch<T> extends StatefulWidget {
  List<InputSearchElement>? items;
  void Function(T element)? onSelectedItem;
  bool Function(String input, String element)? customSearch;

  InputSearch({
    super.key,
    this.items,
    this.customSearch,
    this.onSelectedItem,
  });

  @override
  State<StatefulWidget> createState() => _InputSearchState<T>();
}

class _InputSearchState<T> extends State<InputSearch<T>> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
          elevation: const WidgetStatePropertyAll(0),
          onTap: () => controller.openView(),
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        if (widget.items != null) {
          return widget.items!.where((el) {
            if (controller.text.isEmpty) return true;
            if (el.whereSearch == null) el.whereSearch = [el.text];
            for (final search in el.whereSearch!) {
              if (widget.customSearch != null) {
                if (widget.customSearch!(search, controller.text)) return true;
              } else {
                if (search.toLowerCase().startsWith(controller.text.toLowerCase())) return true;
              }
            }
            return false;
          }).map((el) => ListTile(
              title: Text(el.text),
              leading: el.leading ?? Icon(el.icon),
              onTap: () {
                controller.closeView(el.text);              
                if (widget.onSelectedItem != null) widget.onSelectedItem!(el.element);
              },
          ));
        }
          
        return [];
      },
    );
  }
}