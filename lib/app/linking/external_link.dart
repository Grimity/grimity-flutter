enum ExternalLinkType { profile, post, feed, unknown }

class ExternalLink {
  const ExternalLink(this.type, {this.url, this.id});

  final ExternalLinkType type;
  final String? url;
  final String? id;
}
