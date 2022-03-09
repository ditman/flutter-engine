// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
@JS()
library js_interop_engine;

import 'package:js/js.dart';

import 'package:ui/src/engine/assets.dart' show AssetManager;

import 'package:ui/src/engine/js_interop/plugins.dart';


/// Typedef for the function that can initialize a Flutter Web Engine.
typedef WebOnlyInitializePlatformFn = Future<void> Function({AssetManager assetManager});

/// JS-Interop definition for the _flutterEngine object
@JS()
@anonymous
class JsInteropEngine {
  external JsInteropPlugins? get plugins;
  external set plugins(JsInteropPlugins? plugins);

  external set initEngine(WebOnlyInitializePlatformFn fn);
  external WebOnlyInitializePlatformFn get initEngine;
}

/// The global js-interop entrypoint to window._flutterEngine
@JS('_flutterEngine')
external JsInteropEngine? get jsInteropEngine;
/// The global js-interop setter to window._flutterEngine
@JS('_flutterEngine')
external set jsInteropEngine(JsInteropEngine? instance);
