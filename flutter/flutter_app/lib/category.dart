// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// To keep your imports tidy, follow the ordering guidelines at
// https://www.dartlang.org/guides/language/effective-dart/style#ordering
import 'package:flutter/material.dart';

/// A custom [Category] widget.
///
/// The widget is composed on an [Icon] and [Text]. Tapping on the widget shows
/// a colored [InkWell] animation.
class Category extends StatelessWidget {
  /// Creates a [Category].
  ///
  /// A [Category] saves the name of the Category (e.g. 'Length'), its color for
  /// the UI, and the icon that represents it (e.g. a ruler).
  // TODO: You'll need the name, color, and iconLocation from main.dart
  const Category({this.categoryName, this.icon, this.color});
  final String categoryName;
  final IconData icon;
  final Color color;

  /// Builds a custom widget that shows [Category] information.
  ///
  /// This information includes the icon, name, and color for the [Category].
  @override
  // This `context` parameter describes the location of this widget in the
  // widget tree. It can be used for obtaining Theme data from the nearest
  // Theme ancestor in the tree. Below, we obtain the display1 text theme.
  // See https://docs.flutter.io/flutter/material/Theme-class.html
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    var rowHeight = 100.0;
    var boarderRadius = BorderRadius.all(Radius.circular(50.0));
    var highlightColor = color.withAlpha(50);
    var tapColor = color;
    var iconLocation = icon;
    var name = categoryName;
    return Material(
      color: Colors.transparent,
      child: Container(
        height: rowHeight,
        child: InkWell(
            borderRadius: boarderRadius,
            highlightColor: highlightColor,
            splashColor: tapColor,
            onTap: () {
              print('tapped');
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(right: 16.0),
                    child: iconLocation != null ? Icon(Icons.cake) : iconLocation,
                  ),
                  Center(child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                      color: Colors.grey[700],
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ))
                ],),
            )),
      ),
    );
  }
}