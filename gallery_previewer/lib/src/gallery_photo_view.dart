import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'gallery_view_item.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper(
      {this.loadingChild,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialIndex,
      this.canEdit = false,
      this.pictureText,
      @required this.galleryItems})
      : pageController = PageController(initialPage: initialIndex);

  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final bool canEdit;
  final String pictureText;
  final PageController pageController;
  final List<GalleryViewItem> galleryItems;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;
  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        // padding: const EdgeInsets.all(8.0),
        body: Container(
            decoration: widget.backgroundDecoration,
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: widget.galleryItems.length,
                  loadingBuilder: (context, chunk) => widget.loadingChild,
                  backgroundDecoration: widget.backgroundDecoration,
                  pageController: widget.pageController,
                  onPageChanged: onPageChanged,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "${widget.pictureText} ${currentIndex + 1}/${widget.galleryItems.length}",
                    style: TextStyle(
                        shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3, color: Colors.black)],
                        color: Colors.white,
                        fontSize: 17.0),
                  ),
                ),
                Positioned(
                    left: 10,
                    bottom: 30,
                    child: RawMaterialButton(
                      constraints: BoxConstraints(maxWidth: 60, maxHeight: 60),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                        // size: 20.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                    )),
                widget.canEdit
                    ? Positioned(
                        left: 70,
                        bottom: 30,
                        child: RawMaterialButton(
                          constraints: BoxConstraints(maxWidth: 60, maxHeight: 60),
                          onPressed: () {
                            Navigator.of(context).pop(widget.galleryItems[currentIndex].url);
                          },
                          child: new Icon(
                            Icons.edit,
                            color: Colors.grey,
                            // size: 20.0,
                          ),
                          shape: new CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(10.0),
                        ),
                      )
                    : Container(),
              ],
            )),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryViewItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
        initialScale: PhotoViewComputedScale.contained,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        heroAttributes: PhotoViewHeroAttributes(tag: item.id),
        imageProvider: CachedNetworkImageProvider(item.url));
  }
}
