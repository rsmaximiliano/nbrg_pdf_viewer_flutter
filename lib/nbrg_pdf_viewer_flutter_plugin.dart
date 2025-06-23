import 'dart:async';
import 'package:flutter/services.dart';
import 'package:nbrg_pdf_viewer_flutter/viewer_params.dart';

enum PDFViewState { shouldStart, startLoad, finishLoad }

class NbrgPdfViewerFlutterPlugin {
  final _channel = const MethodChannel("nbrg_pdf_viewer_flutter");
  static NbrgPdfViewerFlutterPlugin? _instance;

  factory NbrgPdfViewerFlutterPlugin() =>
      _instance ??= new NbrgPdfViewerFlutterPlugin._();

  NbrgPdfViewerFlutterPlugin._() {
    _channel.setMethodCallHandler(_handleMessages);
  }

  final _onDestroy = new StreamController<Null>.broadcast();
  Stream<Null> get onDestroy => _onDestroy.stream;
  Future<Null> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case 'onDestroy':
        _onDestroy.add(null);
        break;
    }
  }

  /* Future<Null> launch(String path, {Rect? rect}) async {
    final args = <String, dynamic>{'path': path};
    if (rect != null) {
      args['rect'] = {
        'left': rect.left,
        'top': rect.top,
        'width': rect.width,
        'height': rect.height
      };
    }
    await _channel.invokeMethod('launch', args);
  } */

  Future<Null> launch(String path, ViewerParams params, {Rect? rect}) async {
    final basicArgs = <String, dynamic>{'path': path};
    if (rect != null) {
      basicArgs['rect'] = {
        'left': rect.left,
        'top': rect.top,
        'width': rect.width,
        'height': rect.height
      };
    }
    final Map<String, dynamic> args = params.toMap(basicArgs);
    await _channel.invokeMethod('launch', args);
  }

  /// Close the PDFViewer
  /// Will trigger the [onDestroy] event
  Future close() => _channel.invokeMethod('close');

  /// adds the plugin as ActivityResultListener
  /// Only needed and used on Android
  Future registerAcitivityResultListener() =>
      _channel.invokeMethod('registerAcitivityResultListener');

  /// removes the plugin as ActivityResultListener
  /// Only needed and used on Android
  Future removeAcitivityResultListener() =>
      _channel.invokeMethod('removeAcitivityResultListener');

  /// Close all Streams
  void dispose() {
    _onDestroy.close();
    _instance = null;
  }

  /// resize PDFViewer
  Future<Null> resize(Rect rect) async {
    final args = {};
    args['rect'] = {
      'left': rect.left,
      'top': rect.top,
      'width': rect.width,
      'height': rect.height
    };
    await _channel.invokeMethod('resize', args);
  }
}
