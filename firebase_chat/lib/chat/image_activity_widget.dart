import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/models.dart';
import 'package:firebase_chat/chat/base_chat_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_previewer/gallery_previewer.dart';
import 'package:http/http.dart' as http;

class ImageActivityWidget extends StatelessWidget {
  final ImageActivity imageActivity;
  final List<GalleryViewItem> images;
  final Widget loadingWidget;
  const ImageActivityWidget({this.imageActivity, this.images, this.loadingWidget});

  @override
  Widget build(BuildContext context) {
    // double imageMaxWidth = MediaQuery.of(context).size.width / 2;
    GalleryViewItem item = images.firstWhere((x) {
      return x.id == imageActivity.documentId;
    }, orElse: () => null);
    if (item == null) return SizedBox();

    return LayoutBuilder(builder: (context, constraints) {
      double imageMaxWidth = constraints.maxWidth * 2 / 3;
      return GestureDetector(
        child: Hero(
            tag: item.id,
            child: CachedNetworkImage(
              imageUrl: item.thumbnail ?? item.url,
              placeholder: (context, url) => loadingWidget,
              // placeholderFadeInDuration: Duration(milliseconds: 50),
              fit: BoxFit.fitHeight,
              width: imageMaxWidth,
            )
            // child: FadeInImage(
            //   image: NetworkImage(item.thumbnail ?? item.url),
            //   placeholder: AssetImage('assets/loading.gif'),
            //   width: imageMaxWidth,
            //   fit: BoxFit.fitHeight,
            // ),
            ),
        onTap: () async {
          String url = await Navigator.of(context).push(PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => GalleryPhotoViewWrapper(
                    pictureText: 'სურათი',
                    loadingChild: loadingWidget,
                    galleryItems: images,
                    canEdit: true && !kIsWeb,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    initialIndex: images.indexOf(item),
                  )));

          // edit image
          if (url != null && url != "") {
            var client = http.Client();
            var req = await client.get(Uri.parse(url));
            var data = req.bodyBytes;

            BaseChat.of(context).editAndUpload(data);
          }
        },
      );
    });
  }

  // @override
  // bool get wantKeepAlive => false;
}
