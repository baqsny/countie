import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  const RefreshWidget(
      {Key? key, @required this.child, @required this.onRefresh})
      : super(key: key);
  final Widget? child;
  final Future Function()? onRefresh;

  @override
  State<RefreshWidget> createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) => buildList();

  Widget buildList() =>
      RefreshIndicator(child: widget.child!, onRefresh: widget.onRefresh!);
}
