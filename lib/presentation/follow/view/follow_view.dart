import 'package:flutter/material.dart';

class FollowView extends StatelessWidget {
  final PreferredSizeWidget followAppBar;
  final Widget followBody;

  const FollowView({super.key, required this.followAppBar, required this.followBody});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: followAppBar, body: followBody);
  }
}
