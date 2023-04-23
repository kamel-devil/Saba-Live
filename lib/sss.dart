import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class MultiSelectListDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MultiSelectContainer(
          itemsPadding: const EdgeInsets.all(5),
          itemsDecoration: MultiSelectDecorations(
            decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1)),
            selectedDecoration: const BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.green, Colors.lightGreen]),
            ),
          ),
          items: [
            MultiSelectCard(
              value: '',
              child: getChild('https://images.unsplash.com/photo-1681420038105-0a9c2ba5ebaf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNnx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60', 'Dart'),
            )
          ],
          onChange: (List<String> selectedItems, String selectedItem) {},
        ),
      ),
    );
  }

  Widget getChild(String imagePath, String title) {
    return SizedBox(
      width: 75,
      height: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Image.network(
            imagePath,
            fit: BoxFit.contain,
          )),
        ],
      ),
    );
  }
}
