import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('So sánh xử lý ảnh'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      controller.setLoading(true);
                      await controller.generateImagePaths();
                      controller.setLoading(false);
                    },
                    child: const Text('Load images'),
                  ),
                  Text(
                    'Total images: ${controller.count.value}',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      controller.setLoading(true);
                      await controller.processWithImageEditor();
                      controller.setLoading(false);
                    },
                    child: const Text('Xử lý với image_editor'),
                  ),
                  Text(controller.resultImageEditor.value),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      controller.setLoading(true);
                      await controller.processWithImage();
                      controller.setLoading(false);
                    },
                    child: const Text('Xử lý với image'),
                  ),
                  Text(controller.resImage.value),
                  Obx(() {
                    return controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : Container();
                  }),
                ],
              ),
            ),
          );
        });
  }
}
