import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nbrg_pdf_viewer_flutter/nbrg_pdf_viewer_flutter_plugin.dart';
import 'package:nbrg_pdf_viewer_flutter/viewer_params.dart';

class PDFViewerScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final String path;
  final bool primary;
  final ViewerParams viewerParams;

  const PDFViewerScaffold({
    Key? key,
    required this.appBar,
    required this.path,
    this.primary = true,
    this.viewerParams = const ViewerParams(),
  }) : super(key: key);

  @override
  _PDFViewScaffoldState createState() => new _PDFViewScaffoldState();
}

class _PDFViewScaffoldState extends State<PDFViewerScaffold> {
  final pdfViewerRef = new NbrgPdfViewerFlutterPlugin();
  Rect? _rect;
  Timer? _resizeTimer;

  @override
  void initState() {
    super.initState();
    pdfViewerRef.close();
  }

  @override
  void dispose() {
    super.dispose();
    pdfViewerRef.close();
    pdfViewerRef.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_rect == null) {
      _rect = _buildRect(context);
      pdfViewerRef.launch(
        widget.path,
        widget.viewerParams,
        rect: _rect,
      );
    } else {
      final rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = new Timer(new Duration(milliseconds: 300), () {
          pdfViewerRef.resize(_rect!);
        });
      }
    }
    return new Scaffold(
        appBar: widget.appBar,
        body: const Center(child: const CircularProgressIndicator()));
  }

  Rect _buildRect(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = widget.primary ? mediaQuery.padding.top : 0.0;
    final top = widget.appBar.preferredSize.height + topPadding;
    var height = mediaQuery.size.height - top;
    if (height < 0.0) {
      height = 0.0;
    }

    return new Rect.fromLTWH(0.0, top, mediaQuery.size.width, height);
  }
}
