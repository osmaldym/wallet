import 'package:flutter/material.dart';

class InputSearchElement<T> {
  String text;
  IconData? icon;
  T? element;

  InputSearchElement({
    required this.text,
    this.icon,
    this.element
  });
}

class InputSearch<T> extends StatefulWidget {
  List<InputSearchElement>? items;
  void Function(T element)? onSelectedItem;

  InputSearch({
    super.key,
    this.items,
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
          return widget.items!.where((el) => el.text.toLowerCase().contains(controller.text.toLowerCase())).map((el) => ListTile(
            title: Text(el.text),
            leading: Icon(el.icon),
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