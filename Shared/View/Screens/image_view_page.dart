import 'package:flutter/material.dart';

class ImageViewPage extends StatelessWidget {
  final String url;
  const ImageViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image"),),
      body: Center(
        child: Image.network(url,height: double.infinity,width: double.infinity,),
      ),
    );
  }
}
