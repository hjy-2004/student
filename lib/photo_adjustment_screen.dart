import 'dart:typed_data';

import 'package:flutter/material.dart';

class PhotoAdjustmentPage extends StatefulWidget {
  final Uint8List image;

  PhotoAdjustmentPage({required this.image});

  @override
  _PhotoAdjustmentPageState createState() => _PhotoAdjustmentPageState();
}

class _PhotoAdjustmentPageState extends State<PhotoAdjustmentPage>
    with SingleTickerProviderStateMixin {
  double _brightness = 20;
  double _contrast = 0;
  double _saturation = 0;
  bool _showAdjustments = false; // 控制调节按钮的显示状态

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('照片调节'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              // 打印逻辑
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.memory(widget.image),
          ),
          SizedBox(height: 10),
          AnimatedSize(
            duration: const Duration(milliseconds: 300), // 动画持续时间
            child: Column(
              children: [
                if (_showAdjustments) ...[
                  Text('曝光度: ${_brightness.toInt()}'),
                  Slider(
                    value: _brightness,
                    min: -50,
                    max: 50,
                    divisions: 100,
                    label: _brightness.toString(),
                    onChanged: (value) {
                      setState(() {
                        _brightness = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 曝光度图标
                      Column(
                        children: [
                          Icon(Icons.wb_sunny,
                              color: _brightness > 0
                                  ? Colors.orange
                                  : Colors.grey),
                          SizedBox(height: 8),
                          Text('曝光度'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: _brightness == 0
                                      ? Colors.grey
                                      : Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _brightness =
                                        (_brightness - 1).clamp(-50, 50);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: _brightness == 50
                                      ? Colors.grey
                                      : Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _brightness =
                                        (_brightness + 1).clamp(-50, 50);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      // 对比度图标
                      Column(
                        children: [
                          Icon(Icons.compare_arrows,
                              color:
                                  _contrast > 0 ? Colors.orange : Colors.grey),
                          SizedBox(height: 8),
                          Text('对比度'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: _contrast == 0
                                      ? Colors.grey
                                      : Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _contrast = 0;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: _contrast == 50
                                      ? Colors.grey
                                      : Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _contrast = (_contrast + 1).clamp(-50, 50);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      // 饱和度图标
                      Column(
                        children: [
                          Icon(Icons.color_lens,
                              color: _saturation > 0
                                  ? Colors.orange
                                  : Colors.grey),
                          SizedBox(height: 8),
                          Text('饱和度'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: _saturation == 0
                                      ? Colors.grey
                                      : Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _saturation = 0;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: _saturation == 50
                                      ? Colors.grey
                                      : Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _saturation =
                                        (_saturation + 1).clamp(-50, 50);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
                Align(
                  alignment: Alignment.topRight, // 设置对齐方式为右上角
                  child: IconButton(
                    icon: Icon(
                      _showAdjustments
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _showAdjustments = !_showAdjustments; // 切换显示状态
                      });
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
}
