// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:ui/src/engine/js_interop/engine.dart';
import 'package:ui/src/engine/js_interop/plugins.dart';

import 'package:ui/src/engine/safe_browser_api.dart';

/// This class acts as a façade for the whole JS-interop layer of the engine,
/// allowing parts of it to be set as needed.
class EngineJsInteropLayer {

  // We use these to not litter the code with ! later on
  late JsInteropEngine _engine;
  late JsInteropPlugins _plugins;

  /// Ensure that the window._flutterEngine exists (and all its internal bits)
  EngineJsInteropLayer() {
    // Write the js_interop_engine if it doesn't exist already.
    _engine = jsInteropEngine ??= JsInteropEngine();
    _plugins = _engine.plugins ??= JsInteropPlugins();
  }

  /// Configure the function that kickstarts the engine.
  /// AKA ui.webOnlyInitializePlatform
  set initEngine (WebOnlyInitializePlatformFn handler) {
    _engine.initEngine = allowInterop(handler);
  }

  /// Configure a setter function to handle plugins.
  /// AKA ui.webOnlySetPluginHandler
  set jsPluginHandler (WebOnlySetPluginHandlerFn handler) {
    // The below will throw an assertion error without allowInterop!!
    _plugins.setPluginHandler = allowInterop(handler);
  }
}
