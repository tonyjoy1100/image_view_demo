import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:js_util';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter Demo', home: HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State management for [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String? _imageUrl;
  bool _isMenuVisible = false;

  /// Loads the image from the given URL.
  void _loadImage() {
    setState(() {
      _imageUrl = _urlController.text.trim();
    });
  }

  /// Toggles fullscreen mode for the browser window.
  void _toggleFullscreen() {
    if (html.document.fullscreenElement == null) {
      promiseToFuture(callMethod(html.document.documentElement!, 'requestFullscreen', []));
    } else {
      _exitFullscreen();
    }
  }

  /// Exits fullscreen mode.
  void _exitFullscreen() {
    promiseToFuture(callMethod(html.document, 'exitFullscreen', []));
  }

  /// Toggles the visibility of the context menu.
  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Viewer')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imageUrl != null
                      ? GestureDetector(
                    onDoubleTap: _toggleFullscreen,
                    child: Image.network(_imageUrl!, fit: BoxFit.cover),
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(hintText: 'Image URL'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _loadImage,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (_isMenuVisible)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black54,
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isMenuVisible)
                  Column(
                    children: [
                      FloatingActionButton(
                        onPressed: _toggleFullscreen,
                        child: const Icon(Icons.fullscreen),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: _exitFullscreen,
                        child: const Icon(Icons.fullscreen_exit),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                FloatingActionButton(
                  onPressed: _toggleMenu,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
