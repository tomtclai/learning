import 'package:flutter/material.dart';

Widget _buildCategoryWidgets(bool portrait) {
  var _categories = Array<Widget>();
  if (portrait) {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) => _categories[index],
          itemCount: _categories.count
      ,);
  } else {
    return GridView.count(crossAxisCount: 2, childAspectRatio: 3.0, children: _categories,);
  }
}