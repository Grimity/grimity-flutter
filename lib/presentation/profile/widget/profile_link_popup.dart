import 'package:flutter/material.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/presentation/profile/enum/link_type_enum.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showProfileLinkPopup(BuildContext context, List<Link> links) {
  final Widget child = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ...links.map((link) {
        final linkType = LinkType.from(link);

        return GdsGesture(
          onTap: () {
            context.pop();
            final url = linkType == LinkType.email ? 'mailto:${link.link}' : link.link;
            launchUrl(Uri.parse(url));
          },
          child: GdsUserItem.link(
            icon: linkType.icon,
            siteText: link.linkName,
            linkText: link.link,
          ),
        );
      }),
    ],
  );

  if (context.isMobile) {
    return GdsBottomSheet(title: '프로필 링크', child: child).open(context);
  } else {
    return GdsModal(title: '프로필 링크', body: child).open(context);
  }
}
