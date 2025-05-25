import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/core/constants/theme/app_theme.dart';

class ExpandableFabItem {
  IconData icon;
  String? helper;
  void Function()? onTapped;

  ExpandableFabItem({
    this.icon = Icons.wallet,
    this.helper,
    this.onTapped,
  });
}

class ExpandableFab extends StatefulWidget {  
  final List<ExpandableFabItem> items;

  ExpandableFab({
    required this.items,
  });

  @override
  State createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 250
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.items.length, 
        (int index) => _buildChild(index)
      ).toList()..add(
        _buildFab(),
      ),
    );
  }

  Widget _buildChild(int index) {
    Color bgColor = AppTheme.of(context).seedBgColor;
    Color fgColor = AppTheme.of(context).textContrast;

    return Container(
      height: 70,
      width: 56,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0,
            1.0 - index / widget.items.length / 2,
            curve: Curves.easeOut
          )
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (widget.items[index].helper != null)
              Positioned(
                right: 55,
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5
                    ),
                    child: Text(
                      widget.items[index].helper!,
                      style: GoogleFonts.urbanist(
                        color: fgColor
                      ),
                    ),
                  )
                ),
              ),
            FloatingActionButton(
              backgroundColor: bgColor,
              mini: true,
              heroTag: index,
              child: Icon(widget.items[index].icon, color: fgColor),
              onPressed: () => _onTapped(index),
            ),
          ]
        )
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) _controller.forward();
        else _controller.reverse();
      },
      elevation: 2,
      child: const Icon(Icons.add),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.items[index].onTapped!();
  }
}