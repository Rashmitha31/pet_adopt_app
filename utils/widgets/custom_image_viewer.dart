import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomImageViewer extends StatefulWidget {
  final String imageUrl;
  final String heroId;

  const CustomImageViewer({
    Key? key,
    required this.imageUrl,
    required this.heroId,
  }) : super(key: key);

  @override
  State<CustomImageViewer> createState() => _CustomImageViewerState();
}

class _CustomImageViewerState extends State<CustomImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: widget.heroId,
            child: Container(
              width: MediaQuery.of(context).size.width / 2, // Take half of the width of the screen
              height: MediaQuery.of(context).size.height / 2, // Take half of the height of the screen
              child: PhotoView(
                imageProvider: NetworkImage(widget.imageUrl),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



