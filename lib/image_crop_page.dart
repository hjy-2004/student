import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CustomImageCropPage extends StatefulWidget {
  final Uint8List imageData;

  CustomImageCropPage({required this.imageData});

  @override
  _CustomImageCropPageState createState() => _CustomImageCropPageState();
}

class _CustomImageCropPageState extends State<CustomImageCropPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  double? _cropAspectRatio = CropAspectRatios.custom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Stack(
              children: [
                Container(
                  color: Colors.grey[600], // 这里设置与按钮区域一致的颜色
                  child: ExtendedImage.memory(
                    widget.imageData,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    extendedImageEditorKey: editorKey,
                    initEditorConfigHandler: (ExtendedImageState? state) {
                      return EditorConfig(
                        maxScale: 4.0,
                        cropRectPadding: const EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        initCropRectType: InitCropRectType.imageRect,
                        cropAspectRatio: _cropAspectRatio,
                        cornerColor: Colors.white,
                        cornerSize: const Size(30.0, 5.0),
                        cropLayerPainter: CustomCropLayerPainter(
                          maskColor: Colors.grey.shade900,
                        ),
                        editActionDetailsIsChanged:
                            (EditActionDetails? details) {
                          // print(details?.totalScale);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              color: Colors.grey[600],
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildStyledButton(CropAspectRatios.custom, '自由'),
                  buildStyledButton(CropAspectRatios.ratio1_1, '1:1'),
                  buildStyledButton(CropAspectRatios.ratio9_16, '9:16'),
                  buildStyledButton(2.0 / 3.0, '2:3'),
                  buildStyledButton(CropAspectRatios.ratio3_4, '3:4'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Positioned(
                  left: 70, // 设置左侧距离
                  bottom: 30, // 设置底部距离
                  child: IconButton(
                    icon: Image.asset(
                      "assets/photo_printing/Group_6856.png",
                      width: 30, // 设置图标宽度
                      height: 30, // 设置图标高度
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  right: 45, // 设置右侧距离
                  bottom: 22, // 设置底部距离
                  child: IconButton(
                    icon: Image.asset(
                      "assets/photo_printing/Vector_6.png",
                      width: 40, // 设置图标宽度
                      height: 40, // 设置图标高度
                    ),
                    onPressed: () async {
                      final editorState = editorKey.currentState;
                      if (editorState != null) {
                        final cropRect = editorState.getCropRect();
                        if (cropRect != null) {
                          final croppedImageData = await cropImage(
                            editorState.rawImageData,
                            cropRect,
                          );
                          Navigator.pop(context, croppedImageData);
                        } else {
                          // 处理未获取到裁剪矩形的情况
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("未能获取裁剪矩形")),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStyledButton(double? aspectRatio, String label) {
    bool isSelected = _cropAspectRatio == aspectRatio;

    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(35, 30), // 最小尺寸为100x40

        backgroundColor: isSelected ? Colors.white : Colors.transparent, // 背景色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 圆角矩形
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 内边距
        side: BorderSide.none, // 去掉边框
      ),
      onPressed: () {
        setState(() {
          _cropAspectRatio = aspectRatio;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white, // 文字颜色
        ),
      ),
    );
  }

  Future<Uint8List> cropImage(Uint8List imageData, Rect cropRect) async {
    final ui.Codec codec = await ui.instantiateImageCodec(imageData);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    canvas.drawImageRect(image, cropRect,
        Rect.fromLTWH(0, 0, cropRect.width, cropRect.height), Paint());

    final ui.Image croppedImage = await recorder
        .endRecording()
        .toImage(cropRect.width.toInt(), cropRect.height.toInt());

    final ByteData? byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class CustomCropLayerPainter extends EditorCropLayerPainter {
  final Color maskColor;

  CustomCropLayerPainter({required this.maskColor});

  @override
  void paint(Canvas canvas, Size size, ExtendedImageCropLayerPainter layer) {
    // 这里不再绘制裁剪框外部的颜色
    final cropRect = layer.cropRect;

    // 打印裁剪框外部颜色
    // print('裁剪框外部颜色: $maskColor');

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    if (!cropRect.isEmpty) {
      final invertedCropRect = Rect.fromLTWH(
          cropRect.left, cropRect.top, cropRect.width, cropRect.height);
      path.addRect(invertedCropRect);
      path.fillType = PathFillType.evenOdd;
    }

    final paint = Paint()..color = maskColor.withOpacity(1.0); // 可调节透明度
    canvas.drawPath(path, paint);

    final clearPaint = Paint()..color = Colors.transparent;
    canvas.drawRect(cropRect, clearPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(cropRect, borderPaint);

    super.paint(canvas, size, layer);
  }
}

class CropAspectRatios {
  static const double? custom = null;
  static const double original = 0.0;
  static const double ratio1_1 = 1.0;
  static const double ratio3_4 = 3.0 / 4.0;
  static const double ratio4_3 = 4.0 / 3.0;
  static const double ratio9_16 = 9.0 / 16.0;
  static const double ratio16_9 = 16.0 / 9.0;
}
