import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class TextEditingScreen extends StatefulWidget {
  const TextEditingScreen({super.key});

  @override
  State<TextEditingScreen> createState() => _TextEditingScreenState();
}

class _TextEditingScreenState extends State<TextEditingScreen> {
  final fontList = GoogleFonts.asMap();
  List<String> texts = [];
  String selectedFont = 'Default';
  double selectedSize = 16.0;
  Color selectedColor = Colors.black;

  List<String> undoStack = [];
  List<String> redoStack = [];

  TextEditingController inputTextController = TextEditingController();

  void addText(String customText) {
    setState(() {
      if (customText.isNotEmpty) {
        texts.add(customText);
        addToUndoStack();
      }
    });
  }

  void changeFont(String font) {
    setState(() {
      selectedFont = font;
      addToUndoStack();
    });
  }

  Future<void> _showChangeFontDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Font'),
          content: Column(
            children: [
              for (var font in [
                'Default',
                'Arial',
                'Roboto',
                'Georgea',
                'Helvetica',
                'Courier New',
                'Tahoma',
              ])
                ListTile(
                  title: Text(font),
                  onTap: () {
                    changeFont(font);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void changeSize(double size) {
    setState(() {
      selectedSize = size;
      addToUndoStack();
    });
  }

  Future<void> _showChangeSizeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Size'),
          content: Column(
            children: [
              for (var size in [
                10.0,
                12.0,
                14.0,
                16.0,
                18.0,
                20.0,
                22.0,
                24.0,
                26.0,
                28.0
              ])
                ListTile(
                  title: Text(size.toString()),
                  onTap: () {
                    changeSize(size);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
      addToUndoStack();
    });
  }

  Future<void> _showChangeColorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                changeColor(color);
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Okay button is pressed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Okay',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showInputTextDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Text'),
          content: TextField(
            controller: inputTextController,
            decoration: const InputDecoration(labelText: 'Enter Text'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addText(inputTextController.text);
                inputTextController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addToUndoStack() {
    undoStack.add(texts.last);
    redoStack.clear();
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      redoStack.add(texts.last);
      texts.removeLast();

      // if (undoStack.isNotEmpty) {
      //   texts.add(undoStack.removeLast());
      // }
      setState(() {});
    } else {
      return;
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      undoStack.add(texts.last);
      texts.add(redoStack.removeLast());
      setState(() {});
    } else {
      return;
    }
  }

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text Editor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.cyan,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: OutlinedButton(
              onPressed: () {
                _showInputTextDialog(context);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(10),
                ),
              ),
              child: const Text(
                'Input Text',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: 300,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ListView(
                    children: texts
                        .map(
                          (text) => Text(
                            text,
                            style: TextStyle(
                              fontSize: selectedSize,
                              fontFamily: selectedFont,
                              color: selectedColor,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.cyan,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_size),
            label: 'Size',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.font_download),
            label: 'Font',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_color_text),
            label: 'Color',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.undo),
            label: 'Undo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redo),
            label: 'Redo',
          ),
        ],
        onTap: (int index) {
          handleBottomNavBarTap(index);
        },
      ),
    );
  }

  void handleBottomNavBarTap(int index) {
    switch (index) {
      case 0:
        _showChangeSizeDialog(context);
        break;
      case 1:
        _showChangeFontDialog(context);
        break;
      case 2:
        _showChangeColorDialog(context);
        break;
      case 3:
        undo();
        break;
      case 4:
        redo();
        break;
    }
  }
}
