import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:makro_board_client/models/image.dart' as models;
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:provider/provider.dart';

class ImageWidget extends StatelessWidget {
  final String pluginName;
  final models.Image image;

  const ImageWidget({required this.pluginName, required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (image.type) {
      case "svg":
        return SvgPicture.network(
          Provider.of<ApiProvider>(context, listen: false).getImageUrl(pluginName, image.name).toString(),
          height: 32,
          width: 32,
          colorFilter: ColorFilter.mode(Theme.of(context).textTheme.titleMedium!.color!, BlendMode.srcIn),
        );
      case "png":
      case "jpg":
        return Image.network(
          Provider.of<ApiProvider>(context, listen: false).getImageUrl(pluginName, image.name).toString(),
          height: 32,
          width: 32,
        );
      default:
        return Text("ImageType not supported: ${image.type}");
    }
  }
}
