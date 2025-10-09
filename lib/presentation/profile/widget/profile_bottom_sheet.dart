import 'package:flutter/material.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/presentation/common/widget/popup/grimity_profile_link_bottom_sheet.dart';

void showProfileLinkBottomSheet(BuildContext context, List<Link> links) {
  GrimityProfileLinkBottomSheet.show(context, links: links);
}
