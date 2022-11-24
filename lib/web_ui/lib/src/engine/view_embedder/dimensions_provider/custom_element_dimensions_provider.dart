// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:ui/src/engine/window.dart';
import 'package:ui/ui.dart' as ui show Size;

import '../../dom.dart';
import 'dimensions_provider.dart';

/// This class provides the real-time dimensions of a "hostElement".
///
/// Note: all the measurements returned from this class are potentially
/// *expensive*, and should be cached as needed. Every call to every method on
/// this class WILL perform actual DOM measurements.
class CustomElementDimensionsProvider extends DimensionsProvider {

  CustomElementDimensionsProvider(this._hostElement) {
    // Hook up a resize observer on the hostElement (if supported!).
    _hostElementResizeObserver = createDomResizeObserver(
      (List<DomResizeObserverEntry> entries, DomResizeObserver _) {
        entries
          .map((DomResizeObserverEntry entry) => ui.Size(entry.contentRect.width, entry.contentRect.height))
          .forEach((ui.Size size) {
            _lastObservedSize = size;
            _onResizeStreamController.add(size);
          });
      }
    );

    assert(() {
      if (_hostElementResizeObserver == null) {
        domWindow.console.warn('ResizeObserver API not supported. Flutter will not resize with its hostElement.');
      }
      return true;
    }());

    _hostElementResizeObserver?.observe(_hostElement);
  }

  final DomElement _hostElement;
  ui.Size? _lastObservedSize;

  // Handle resize events
  late DomResizeObserver? _hostElementResizeObserver;
  final StreamController<ui.Size> _onResizeStreamController =
    StreamController<ui.Size>.broadcast();

  @override
  void onHotRestart() {
    _hostElementResizeObserver?.disconnect();
    // ignore:unawaited_futures
    _onResizeStreamController.close();
  }

  @override
  Stream<ui.Size> get onResize => _onResizeStreamController.stream;

  @override
  ui.Size computePhysicalSize() {
    final double devicePixelRatio = getDevicePixelRatio();

    return ui.Size(
      (_lastObservedSize?.width ?? _hostElement.clientWidth) * devicePixelRatio,
      (_lastObservedSize?.height ?? _hostElement.clientHeight) * devicePixelRatio,
    );
  }

  @override
  WindowPadding computeKeyboardInsets(double physicalHeight, bool isEditingOnMobile) {
    return const WindowPadding(
      top: 0,
      right: 0,
      bottom: 0,
      left: 0,
    );
  }
}
