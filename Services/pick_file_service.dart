import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class PickFileService{
  static Future<File?> chooseImage() async {
    try{
      XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      return File(picked!.path);
    }
    catch(e){
      return null;
    }
  }

  static Future<File?> chooseMedia() async {
    try{
      FilePickerResult? picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'txt'],
      );
      return File(picked!.files.first.path!);
    }
    catch(e){
      return null;
    }
  }

  static Future<File?> chooseVideo() async {
    try{
      XFile? picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
      return File(picked!.path);
    }
    catch(e){
      return null;
    }
  }

  static Future<List<File>?> chooseMultiMedia() async {
    try{
      FilePickerResult? picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'txt'],
      );
      return picked?.files.map((e)=> File(e.path!)).toList();
    }
    catch(e){
      return null;
    }
  }

  static Future<List<File>?> chooseImages() async {
    try{
      List<XFile> pickedImages = await ImagePicker().pickMultiImage();
      return pickedImages.map((e)=> File(e.path)).toList();
    }
    catch(e){
      return null;
    }
  }
}
