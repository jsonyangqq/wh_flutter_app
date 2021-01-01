import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotpAssetGalleryPage extends StatefulWidget {

  Map arguments;
  PageController controller;
  PhotpAssetGalleryPage({Key key,this.arguments}) : super(key: key){
    controller=PageController(initialPage: this.arguments["index"]);
  }

  @override
  _PhotpAssetGalleryPageState createState() => _PhotpAssetGalleryPageState();

}

class _PhotpAssetGalleryPageState extends State<PhotpAssetGalleryPage> {

  int currentIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex=widget.arguments["index"];
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  /*加载本地相册或拍照图片*/
  __generateImage(String path) {
    File file = new File(path);
    return MemoryImage(file.readAsBytesSync().buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
                imageProvider: __generateImage(widget.arguments["galleryItems"][index]),
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

