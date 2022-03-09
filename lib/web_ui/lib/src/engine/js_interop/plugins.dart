// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
@JS()
library js_interop_plugins;

import 'dart:typed_data';

import 'package:js/js.dart';
import 'package:ui/ui.dart' as ui show PlatformMessageResponseCallback;

// Installs some initialization methods in the correct spot

/// Typedef for the function that can handle a platform/framework message.
typedef FrameworkMessageHandlerFn = Future<void> Function(String channel, ByteData? data, ui.PlatformMessageResponseCallback? cb);

/// Typedef for the function that registers a PluginHandler in the Flutter Web Engine.
typedef WebOnlySetPluginHandlerFn = void Function(FrameworkMessageHandlerFn);

@JS()
@anonymous
class JsInteropPlugins {
  /// JS function that sets up a plugin handler in the currently running Flutter web app.
  ///
  /// The JS function is setup by the Flutter engine in engine/initialization.dart,
  /// and used to be called: `ui.webOnlySetPluginHandler`
  external set setPluginHandler(WebOnlySetPluginHandlerFn fn);
  external WebOnlySetPluginHandlerFn get setPluginHandler;
}
