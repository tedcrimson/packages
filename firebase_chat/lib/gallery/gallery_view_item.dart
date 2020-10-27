import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GalleryViewItem {
  GalleryViewItem({this.id, this.url, this.thumbnail});

  final String id;
  final String thumbnail;
  final String url;
}

class GalleryViewItemThumbnail extends StatelessWidget {
  const GalleryViewItemThumbnail({Key key, this.galleryViewItem, this.onTap, this.placeholder, this.errorWidget})
      : super(key: key);

  final GalleryViewItem galleryViewItem;

  final GestureTapCallback onTap;
  final Widget placeholder;
  final Widget errorWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: GestureDetector(
            onTap: onTap,
            child: Hero(
                tag: galleryViewItem.id,
                // child: FadeInImage(
                //   placeholder: this.placeholder,
                //   // width: 50,
                //     image: NetworkImage(galleryViewItem.thumbnail),
                //     fit: BoxFit.fitHeight,
                //     alignment: Alignment.center),
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                  imageUrl: galleryViewItem.thumbnail,
                  placeholder: (context, url) => this.placeholder ?? Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => this.errorWidget ?? Icon(Icons.error),
                ))));
  }
}
