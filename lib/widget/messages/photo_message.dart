import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meet_ceylon/provider/size_configurations.dart';

class PhotoMessage extends StatelessWidget {
  const PhotoMessage({
    Key key,
    this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width * 10,
                      height: MediaQuery.of(context).size.height * 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                onTap: () async {
                  await showDialog(
                      context: context, builder: (_) => ImageDialog(image));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String image;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        child: Container(
          width: SizeConfig.safeBlockVertical * 100,
          height: SizeConfig.safeBlockHorizontal * 100,
          child: CachedNetworkImage(
            imageUrl: image,
            imageBuilder: (context, imageProvider) => Container(
              width: MediaQuery.of(context).size.width * 10,
              height: MediaQuery.of(context).size.height * 10,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
              ),
            ),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  ImageDialog(this.image);
}
