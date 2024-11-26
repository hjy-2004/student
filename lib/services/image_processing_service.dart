import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImageProcessingService {
  static Future<Uint8List?> convertToGrayscale(Uint8List image) async {
    if (image.isEmpty) {
      print('Input image is empty.');
      return null;
    }

    final receivePort = ReceivePort();
    // Spawn the isolate and wait for the SendPort
    await Isolate.spawn(_convertToGrayscaleIsolate, receivePort.sendPort);

    // Get the SendPort for communication with the isolate
    final sendPort = await receivePort.first as SendPort;
    final response = ReceivePort();

    // Send the image and response port to the isolate
    sendPort.send([image, response.sendPort]);
    // Wait for the result from the isolate
    return await response.first as Uint8List?;
  }

  static void _convertToGrayscaleIsolate(SendPort initialSendPort) {
    final receivePort = ReceivePort();
    initialSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final image = message[0] as Uint8List;
      final sendPort = message[1] as SendPort;

      // Process the grayscale image
      _processGrayscaleImage(image).then((result) {
        sendPort.send(result);
      });
    });
  }

  static Future<Uint8List?> _processGrayscaleImage(Uint8List image) async {
    try {
      // Decode the image
      final img.Image? originalImage = img.decodeImage(image);
      if (originalImage == null) {
        print('Failed to decode image.');
        return null;
      }

      // Convert to grayscale
      final img.Image grayscaleImage = img.grayscale(originalImage);

      // Encode back to PNG
      return Uint8List.fromList(img.encodePng(grayscaleImage));
    } catch (e) {
      print('Error in grayscale conversion: $e');
      return null;
    }
  }
}
