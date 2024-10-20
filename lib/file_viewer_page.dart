import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';
import 'package:xml/xml.dart';

class FileViewerPage extends StatefulWidget {
  final String filePath;

  FileViewerPage({required this.filePath});

  @override
  _FileViewerPageState createState() => _FileViewerPageState();
}

class _FileViewerPageState extends State<FileViewerPage> {
  late Future<Widget> _fileWidget;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _fileWidget = _handleFileType(widget.filePath);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("文件查看器")),
      body: FutureBuilder<Widget>(
        future: _fileWidget,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("错误: ${snapshot.error}"));
          } else {
            return snapshot.data ?? Center(child: Text('不支持的文件类型'));
          }
        },
      ),
    );
  }

  Future<Widget> _handleFileType(String path) async {
    if (path.endsWith('.pdf')) {
      return PDFView(
        filePath: path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageSnap: true,
        onError: (e) {
          print('PDF加载错误: $e');
        },
        onPageChanged: (int? page, int? total) {
          print('当前页: $page, 总页数: $total');
        },
      );
    } else if (path.endsWith('.jpg') || path.endsWith('.png')) {
      return Image.file(File(path));
    } else if (path.endsWith('.docx')) {
      return _readDocxFile(path);
    } else if (path.endsWith('.mp4') || path.endsWith('.mov')) {
      return _videoPlayerWidget(path);
    } else {
      return Center(child: Text('不支持的文件类型'));
    }
  }

  Future<Widget> _readDocxFile(String path) async {
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      String documentContent = '';

      for (final file in archive) {
        if (file.name == 'word/document.xml') {
          final xmlString = utf8.decode(file.content);
          documentContent = _extractTextFromXml(xmlString);
          break;
        }
      }

      return SelectableText(
          documentContent.isNotEmpty ? documentContent : '文档内容未找到');
    } catch (e) {
      return Text('读取 DOCX 文件时出错: $e');
    }
  }

  Future<Widget> _videoPlayerWidget(String path) async {
    _videoController = VideoPlayerController.file(File(path));
    await _videoController!.initialize();
    _videoController!.setLooping(true); // 可选：循环播放

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
          VideoControls(controller: _videoController!),
          ElevatedButton(
            onPressed: () {
              _enterFullScreen();
            },
            child: Text('全屏播放'),
          ),
        ],
      ),
    );
  }

  void _enterFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenVideoPlayer(controller: _videoController!),
      ),
    );
  }

  String _extractTextFromXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final textBuffer = StringBuffer();

    for (final element in document.findAllElements('w:t')) {
      String text = element.text.trim();
      if (text.isNotEmpty) {
        textBuffer.write(text + ' ');
      }
    }

    return textBuffer.toString();
  }
}

class VideoControls extends StatefulWidget {
  final VideoPlayerController controller;

  VideoControls({required this.controller});

  @override
  _VideoControlsState createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  double _volume = 1.0; // 默认音量为最大

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                widget.controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              onPressed: () {
                widget.controller.value.isPlaying
                    ? widget.controller.pause()
                    : widget.controller.play();
              },
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () {
                widget.controller.pause();
                widget.controller.seekTo(Duration.zero);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(widget.controller.value.position),
            ),
            SizedBox(
              width: 200,
              child: VideoProgressIndicator(widget.controller,
                  allowScrubbing: true),
            ),
            Text(
              _formatDuration(widget.controller.value.duration),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _volume == 0 ? Icons.volume_off : Icons.volume_up,
              ),
              onPressed: () {
                setState(() {
                  _volume = _volume == 0 ? 1.0 : 0.0; // 切换音量
                  widget.controller.setVolume(_volume);
                });
              },
            ),
            // 音量控制滑块
            Slider(
              value: _volume,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                  widget.controller.setVolume(_volume);
                });
              },
              min: 0,
              max: 1,
              divisions: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  FullScreenVideoPlayer({required this.controller});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: VideoControls(controller: widget.controller),
          ),
        ],
      ),
    );
  }
}
