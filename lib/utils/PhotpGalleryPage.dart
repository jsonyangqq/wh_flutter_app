import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotpGalleryPage extends StatefulWidget {

  Map arguments;
  PageController controller;
  PhotpGalleryPage({Key key,this.arguments}) : super(key: key){
    controller=PageController(initialPage: this.arguments["index"]);
  }

  @override
  _PhotpGalleryPageState createState() => _PhotpGalleryPageState();
}

class _PhotpGalleryPageState extends State<PhotpGalleryPage> {

  int currentIndex = 0;
  int initialIndex; //初始index


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex=widget.arguments["index"];
  }

  void onPageChanged(int index) {
    setState(() {
      initialIndex = 0;
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.arguments["galleryItems"][index]),
              initialScale: PhotoViewComputedScale.contained * 0.8
            );
          },
          itemCount: widget.arguments["galleryItems"].length,
          pageController: widget.controller,
          onPageChanged: onPageChanged,
        )
    );
  }
}
