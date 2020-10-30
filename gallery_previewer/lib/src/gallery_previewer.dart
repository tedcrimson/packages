import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPreviewer extends StatefulWidget {
  final bool collapsed;
  final ScrollController controller;
  final ValueChanged<List<Uint8List>> onTap;
  final Duration duration;
  final ScrollPhysics physics;
  final double height;
  final double maxWidth;
  final double maxHeight;
  final bool multiSelect;
  final Widget loadingWidget;

  const GalleryPreviewer(
      {@required this.collapsed,
      @required this.onTap,
      this.controller,
      this.physics,
      this.duration = Duration.zero,
      this.height = 400,
      this.multiSelect = true,
      this.maxWidth,
      this.maxHeight,
      this.loadingWidget});

  @override
  _GalleryPreviewerState createState() => _GalleryPreviewerState();
}

class _GalleryPreviewerState extends State<GalleryPreviewer> {
  // List<AssetEntity> images = new List<AssetEntity>();
  List<AssetPathEntity> _albums;
  Map<String, Uint8List> _thumbs = new Map<String, Uint8List>();
  bool _multiSelect = false;
  List<AssetEntity> _selectedImages = new List<AssetEntity>();

  bool _expandedAlbums = false;
  AssetPathEntity _selectedAlbum;
  int perPage = 40;

  PagewiseLoadController<AssetEntity> _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PagewiseLoadController<AssetEntity>(pageFuture: loadMore, pageSize: perPage);

    _getGalleryImagePaths();
  }

  void _getGalleryImagePaths() async {
    var result = await PhotoManager.requestPermission();
    if (!result) {
      PhotoManager.openSetting();
      return;
    }
    List<AssetPathEntity> allImageTemp = await PhotoManager.getAssetPathList(type: RequestType.image);

    setState(() {
      if (allImageTemp.length > 0) {
        _albums = new List<AssetPathEntity>();
        for (var album in allImageTemp) {
          _albums.add(album);
        }
        _selectedAlbum = _albums[0];
      }
    });
  }

  Future<List<AssetEntity>> loadMore(int page) async {
    return await _selectedAlbum.getAssetListPaged(page, perPage);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        height: widget.collapsed ? 0 : widget.height,
        duration: widget.duration,
        color: Colors.grey,
        child: Column(
          // direction: Axis.vertical,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 50,
              // fit: FlexFit.tight,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Spacer(
                        // flex: 2,
                        ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(_expandedAlbums ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                          Text(_albums != null ? _selectedAlbum.name : "Albums"),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _expandedAlbums = !_expandedAlbums;
                        });
                      },
                    ),
                    if (widget.multiSelect)
                      Flexible(
                        child: CheckboxListTile(
                          title: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Multi select",
                              textAlign: TextAlign.end,
                            ),
                          ),
                          // materialTapTargetSize: MaterialTapTargetSize.padded,
                          value: _multiSelect,
                          onChanged: (value) {
                            setState(() {
                              _multiSelect = !_multiSelect;
                              _selectedImages.clear();
                            });
                          },
                        ),
                      )
                    else
                      Spacer(),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: Container(
                child: _albums == null
                    ? null
                    : Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Positioned.fill(
                              child: PagewiseGridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            // cacheExtent: 9,
                            controller: widget.controller,
                            // physics: widget.physics ?? BouncingScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            pageLoadController: _pageController,
                            itemBuilder: (BuildContext context, AssetEntity a, int index) {
                              return Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                child: InkWell(
                                    onTap: () async {
                                      Uint8List data;
                                      if (widget.maxWidth == null && widget.maxHeight == null)
                                        data = await a.originBytes;
                                      else {
                                        int width = widget.maxWidth == null
                                            ? widget.maxHeight.toInt()
                                            : widget.maxWidth.toInt();
                                        int height = widget.maxHeight == null
                                            ? widget.maxWidth.toInt()
                                            : widget.maxHeight.toInt();
                                        data = await a.thumbDataWithSize(width, height);
                                      }
                                      if (_multiSelect && widget.multiSelect) {
                                        setState(() {
                                          if (!_selectedImages.contains(a))
                                            _selectedImages.add(a);
                                          else {
                                            _selectedImages.remove(a);
                                          }
                                        });
                                      } else {
                                        widget.onTap([data]);
                                      }
                                    },
                                    // onLongPress: () async {
                                    //   // File file = File(gallerya.);
                                    //   setLoading = true;

                                    //   // var data = await file.readAsBytes();
                                    //   Uint8List data = await gallerya.fullData;
                                    //   _uploadFile(data);
                                    // },
                                    child: _thumbs[a.id] == null
                                        ? FutureBuilder(
                                            future: a.thumbDataWithSize(200, 200),
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                _thumbs[a.id] = snapshot.data;
                                                return _buildThumbnail(a);
                                              }
                                              return Container(
                                                color: Colors.grey,
                                              );
                                            },
                                          )
                                        : _buildThumbnail(a)),
                              );
                            },
                          )),
                          if (_multiSelect && _selectedImages.length > 0)
                            Positioned(
                              bottom: 25,
                              child: RaisedButton(
                                child: Text('Send'), //TODO: change with builder
                                color: Colors.blue,
                                // backgroundColor: Colors.blue,
                                onPressed: () async {
                                  List<Uint8List> imgs = [];
                                  for (var item in _selectedImages) {
                                    imgs.add(await item.originBytes);
                                  }
                                  widget.onTap(imgs);
                                },
                              ),
                            ),
                          if (_expandedAlbums && _albums != null)
                            Positioned(
                                top: 0,
                                right: 0,
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.white,
                                  // height: _expandedAlbums ? 0 : double.infinity,
                                  // duration: Duration(microseconds: 500),
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    child: ListView(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        controller: widget.controller,
                                        children: _albums
                                            .map((f) => ListTile(
                                                  contentPadding: EdgeInsets.zero,
                                                  leading: Icon(Icons.done,
                                                      color: _selectedAlbum == f ? Colors.black : Colors.transparent),
                                                  title: Text(f.name),
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedAlbum = f;
                                                      _expandedAlbums = false;
                                                      _pageController.reset();
                                                    });
                                                  },
                                                ))
                                            .toList()),
                                  ),
                                )),
                        ],
                      ),
              ),
            ),
          ],
        ));
  }

  _buildThumbnail(AssetEntity imageData) {
    var thumb = _thumbs[imageData.id];

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.memory(
          thumb,
          gaplessPlayback: true,
          fit: BoxFit.cover, //just for testing, will fill with image later
        ),
        if (_multiSelect)
          Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 24,
                height: 24,
                // padding: EdgeInsets.all(1.0),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: _selectedImages.contains(imageData)
                    ? Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                        child: Center(
                            child: Text((_selectedImages.indexOf(imageData) + 1).toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                      )
                    : Container(),
              )),
        if (_selectedImages.contains(imageData))
          Positioned.fill(
            child: Container(
              color: Colors.white24,
            ),
          )
      ],
    );
  }
}
