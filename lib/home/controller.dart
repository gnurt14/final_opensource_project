import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart';

class HomeController extends GetxController {
  List<Uint8List> images = [];
  var isLoading = false.obs;
  var count = 0.obs;
  var resultImageEditor = ''.obs;
  var resImage = ''.obs;
  String basePath = 'assets/images';

  Future<void> generateImagePaths() async {
    images.clear();
    count.value = 0;
    setLoading(true);
    for (int i = 101; i <= 200; i++) {
      Uint8List imageData = await loadImageAsUint8List('$basePath/bg - Copy ($i) - Copy.png');
      images.add(imageData);
      print('$basePath/bg - Copy ($i) - Copy.png');
      count.value++;
    }
    setLoading(false);
    update();
  }

  Future<Uint8List> loadImageAsUint8List(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  void updateImage(List<Uint8List> imageList) {
    images = imageList;
    update();
  }

  Future<void> processWithImageEditor() async {
    if (images.isEmpty) return;
    setLoading(true);
    final stopwatch = Stopwatch()..start();

    List<Future<void>> tasks = images.map((image) async {
      final editorOption = ImageEditorOption();
      editorOption.addOption(const ClipOption(x: 0, y: 0, width: 300, height: 300));
      try {
        await ImageEditor.editImage(
          image: image,
          imageEditorOption: editorOption,
        );
      } catch (e) {
        print("Error processing with image_editor: $e");
      }
    }).toList();
    await Future.wait(tasks);
    stopwatch.stop();
    setLoading(false);
    resultImageEditor.value = 'Thời gian xử lý (image_editor): ${stopwatch.elapsedMilliseconds} ms';
    update();
  }

  Future<void> processWithImage() async {
    if (images.isEmpty) return;
    setLoading(true);
    final stopwatch = Stopwatch()..start();
    List<Future<void>> tasks = images.map((image) async {
      img.Image? decodedImage = img.decodeImage(image);
      img.Image resized = img.copyResize(decodedImage!, width: 300, height: 300);
      Uint8List result = Uint8List.fromList(img.encodeJpg(resized));
    }).toList();
    await Future.wait(tasks);
    stopwatch.stop();
    setLoading(false);
    resImage.value = 'Thời gian xử lý (image): ${stopwatch.elapsedMilliseconds} ms';
    update();
  }

  void setLoading(bool value) {
    isLoading.value = value;
    update();
  }
}
