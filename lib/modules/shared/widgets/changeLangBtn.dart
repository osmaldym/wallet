import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/core/providers/LocaleNotifier.dart';
import 'package:wallet/core/utils/LocalData.dart';
import 'package:wallet/main/main.dart';

class ChangeLangBtn extends StatelessWidget {
  ChangeLangBtn({ super.key });

  List<Map<String, String>> languageOptions = [
    {
      "tag": "en",
      "name": "English"
    },
    {
      "tag": "es",
      "name": "Español"
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: const Icon(Icons.language),
      onSelected: (lang) async {
        await LocalData.set("locale", lang);
        context.read<LocaleNotifier>().notify();
      },
      itemBuilder: (context) {
        return languageOptions.map((language) {
          return PopupMenuItem(
            value: language["tag"],
            child: Row(
              children: [
                const Icon(Icons.language),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10
                  ),
                  child: Text(language["name"] ?? "languaje"),
                ),
              ],
            ),
          );
        }).toList();
      }
    );
  }
}