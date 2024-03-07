// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@JS()
library js_app;

import 'dart:js_interop';
import 'package:ui/src/engine.dart';

/// The JS bindings for the configuration object passed to [FlutterApp.addView].
@JS()
@anonymous
@staticInterop
class JsFlutterViewOptions {
  external factory JsFlutterViewOptions();
}

/// The attributes of the [JsFlutterViewOptions] object.
extension JsFlutterViewOptionsExtension on JsFlutterViewOptions {
  @JS('hostElement')
  external DomElement? get _hostElement;
  DomElement get hostElement {
    assert (_hostElement != null, '`hostElement` passed to addView cannot be null.');
    return _hostElement!;
  }

  @JS('viewConstraints')
  external JsViewConstraints? get _viewConstraints;
  JsViewConstraints? get viewConstraints {
    return _viewConstraints;
  }

  external JSAny? get initialData;
}

/// The JS bindings for a [ViewConstraints] object.
@JS()
@anonymous
@staticInterop
class JsViewConstraints {
  external factory JsViewConstraints({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  });
}

/// The attributes of a [JsViewConstraints] object.
///
/// These attributes are expressed in *logical* pixels.
extension JsViewConstraintsExtension on JsViewConstraints {
  external double? get maxHeight;
  external double? get maxWidth;
  external double? get minHeight;
  external double? get minWidth;
}

/// The public JS API of a running Flutter Web App.
@JS()
@anonymous
@staticInterop
abstract class FlutterApp {
  factory FlutterApp({
    required MountFlutterViewFn mount,
    required UnmountFlutterViewFn unmount,
  }) =>
      FlutterApp._(
        mount: mount.toJS,
        unmount: ((JSNumber id) => unmount(id.toDartInt)).toJS,
      );
  external factory FlutterApp._({
    required JSFunction mount,
    required JSFunction unmount,
  });
}

/// Typedef for the function that mounts a view to the app.
///
/// Returns the ID of the newly created view.
typedef MountFlutterViewFn = int Function(JsFlutterViewOptions);

/// Typedef for the function that unmounts a view from the app.
///
/// Returns the configuration used to create the view.
typedef UnmountFlutterViewFn = JsFlutterViewOptions? Function(int);
