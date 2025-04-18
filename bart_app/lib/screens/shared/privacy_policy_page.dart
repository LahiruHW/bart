import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as md;

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({
    super.key,
    required this.fileName,
  });

  final String fileName;

  @override
  State<StatefulWidget> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final ScrollController _scrollController;
  final Map<String, GlobalKey> _headerKeys = {};
  final Map<String, double> _scrollOffsetKeys = {};
  late final Future<String> _future;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _future = rootBundle.loadString(widget.fileName);
  }

  /// Check if the link is a header link
  bool isJumpLink(String? href) {
    return (href != null) && _headerKeys.containsKey(href);
  }

  bool isJumpDest(String? href) {
    return (href != null) && href.startsWith('#');
  }

  /// preprocess the markdown data to store the keys of the headers
  /// and scroll offsets to allow jumping to sections
  Map<String, GlobalKey> _preprocessMDData(String data) {
    final width = MediaQuery.of(context).size.width;

    // get (num of chars possible per line) per width
    final int charPerLine = (width / 5).floor();
    final Map<String, GlobalKey> headerKeys = {};
    final List<String> lines = data.split('\n');
    String? header;
    int lineCount = 0;
    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      // num of characters on this line + 1 for \n
      final int charCount = line.length + 1;
      // num of lines the text will take
      lineCount += (charCount / charPerLine).ceil();
      if (isJumpDest(line)) {
        // only get the text after the hash
        final line2 = line.replaceAll('#', '').trimLeft().trimRight();
        header = line2;
        headerKeys[header] = GlobalKey();
        _scrollOffsetKeys[header] = lineCount * 20;
      }
    }
    return headerKeys;
  }

  /// find the section in the page and jump to it
  void jumpToSection(String key, GlobalKey keyText, double keyOffset) {
    // approx. first scroll using offset, then scroll using key
    _scrollController
        .animateTo(
      keyOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    )
        .then(
      (_) {
        Scrollable.ensureVisible(
          keyText.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  /// Check if the link is a mail link
  bool isMailLink(String href) {
    return href.startsWith('mailto:');
  }

  /// open the email app with the receiver's email address filled
  void openEmailApp(String email) {
    final Uri mailUri = Uri(scheme: 'mailto', path: email);
    launchUrl(mailUri);
  }

  bool isUrl(String url) {
    return url.startsWith('http');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerKeys.clear();
    _scrollOffsetKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        primary: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: FutureBuilder<String>(
          // future: rootBundle.loadString(widget.fileName),
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final String markdownData = snapshot.data!;
              _headerKeys.clear();
              _scrollOffsetKeys.clear();
              _headerKeys.addAll(_preprocessMDData(markdownData));
              return md.Markdown(
                controller: _scrollController,
                data: markdownData,
                shrinkWrap: true,
                selectable: true,
                onTapLink: (text, href, title) {
                  if (isMailLink(href!)) {
                    openEmailApp(text);
                    return;
                  }
                  if (isJumpLink(text)) {
                    jumpToSection(
                        text, _headerKeys[text]!, _scrollOffsetKeys[text]!);
                    return;
                  }
                  if (isUrl(href)) {
                    launchUrl(Uri.parse(href));
                    return;
                  }
                },
                builders: {
                  'h1': HeaderBuilder(headerKeys: _headerKeys),
                  'h2': HeaderBuilder(headerKeys: _headerKeys),
                  'h3': HeaderBuilder(headerKeys: _headerKeys),
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class HeaderBuilder extends md.MarkdownElementBuilder {
  HeaderBuilder({
    required this.headerKeys,
  });

  final Map<String, GlobalKey> headerKeys;

  @override
  bool isBlockElement() => false;

  // "text" is md.Text, not material!
  @override
  Widget? visitText(text, preferredStyle) {
    // final data = text as ast.Text;
    final data = text;
    return Text(
      key: headerKeys[data.textContent],
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      data.textContent,
    );
  }
}
