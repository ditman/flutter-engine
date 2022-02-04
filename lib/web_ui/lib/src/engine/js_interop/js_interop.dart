// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:html' as html show window;
import 'dart:js_util' as js_util;
import 'package:ui/src/engine/js_interop/plugins.dart';
import 'package:ui/src/engine/safe_browser_api.dart';

// Keep this in sync with the one in flutter.js!
const String _defaultFlutterNamespace = '_flutter';

const Set<String> _defaultNamespaces = <String>{
  'loader',
  'plugins',
};

/// This class acts as a façade for the whole JS-interop layer of the engine,
/// allowing parts of it to be set as needed.
class EngineJsInteropLayer {

  // Keeps references to each of the namespaces inside `_defaultFlutterNamespace`
  Map<String, Object> _refs = <String, Object>{};

  /// Creates the engine JS Interop layer, and pre-populates the desired
  /// top-level [namespaces] on it.
  /// [namespaces] defaults to [_defaultNamespaces].
  EngineJsInteropLayer([Set<String> namespaces = _defaultNamespaces]) {
    if (!hasJsProperty(html.window, _defaultFlutterNamespace)) {
      setJsProperty(html.window, _defaultFlutterNamespace, createPlainJsObject());
    }
    final Object _flutterNamespace = getJsProperty(html.window, _defaultFlutterNamespace);
    for (final String namespace in namespaces) {
      if (hasJsProperty(_flutterNamespace, namespace)) {
        _refs[namespace] = getJsProperty(_flutterNamespace, namespace);
        continue;
      } else {
        _refs[namespace] = js_util.setProperty(_flutterNamespace, namespace, createPlainJsObject());
      }
    }
  }

  /// Configure a setter function to handle plugins.
  /// AKA ui.webOnlySetPluginHandler
  set jsPluginHandler (WebOnlySetPluginHandlerFn handler) {
    // The below will throw an assertion error without allowInterop!!
    js_util.setProperty(_refs['plugins']!, 'setPluginHandler', allowInterop(handler));
    // The @JS('setPluginHandler') setter doesn't work
    // jsPluginHandlerSetter = allowInterop(handler);
  }
}
