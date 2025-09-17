import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {
  const ReportView({
    super.key,
    required this.reportAppBar,
    required this.reportBodyView,
    required this.reportSendButton,
  });

  final PreferredSizeWidget reportAppBar;
  final Widget reportBodyView;
  final Widget reportSendButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: reportAppBar, body: reportBodyView, bottomNavigationBar: reportSendButton);
  }
}
