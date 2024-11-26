import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 需要导入
import 'package:image_picker/image_picker.dart';

import 'image_crop_page.dart';
import 'sticker_selection_page.dart'; // 导入裁剪页面

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 248),
      ),
      home: PhotoPrintPage(), // 设置照片打印页面为主页
    );
  }
}

// 照片打印功能页面
class PhotoPrintPage extends StatefulWidget {
  @override
  _PhotoPrintPageState createState() => _PhotoPrintPageState();
}

class _PhotoPrintPageState extends State<PhotoPrintPage> {
  // 使用一个 Map 来缓存转换后的灰度图像
  // final Map<String, Uint8List> _grayscaleCache = {};
  XFile? _image; // 存储选择的图片
  Uint8List? _croppedImage; // 存储裁剪后的图片数据
  Uint8List? _originalImage; // 存储上传的原始图像
  Uint8List? _originalCroppedImage; // 存储裁剪后的原始图像

  double _rotationAngle = 0; // 当前旋转的角度，初始为 0
  List<Widget> _textBoxes = []; // 存储添加的文本框
  String _pageTitle = '照片打印'; // 页面标题
  String? _selectedImageMode; // 声明变量
  double _exposure = 0.0;
  double _contrast = 0.0;
  double _saturation = 0.0;

  List<double> _calculateColorMatrix() {
    double invSat = 1 - (_saturation / 40 + 1);
    double R = 0.213 * invSat;
    double G = 0.715 * invSat;
    double B = 0.072 * invSat;

    double contrast = _contrast / 40 + 1;
    double exposure = _exposure / 40 + 1;

    return <double>[
      contrast * (R + (_saturation / 40 + 1)) * exposure,
      contrast * G * exposure,
      contrast * B * exposure, 0, 0, // Red
      contrast * R * exposure,
      contrast * (G + (_saturation / 40 + 1)) * exposure,
      contrast * B * exposure, 0, 0, // Green
      contrast * R * exposure, contrast * G * exposure,
      contrast * (B + (_saturation / 40 + 1)) * exposure, 0, 0, // Blue
      0, 0, 0, 1, 0, // Alpha
    ];
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final imageData = await pickedFile.readAsBytes();
        if (imageData.isEmpty) {
          print('Picked image data is empty!');
        } else {
          print('Picked image data size: ${imageData.length}');
        }

        setState(() {
          _croppedImage = imageData;
          _image = XFile(pickedFile.path);
        });
      } catch (e) {
        print('Error loading image: $e');
      }
    } else {
      print('No image selected.');
    }
  }

  void _addTextBox() {
    setState(() {
      _textBoxes.add(EditableTextBox(
        key: GlobalKey<_EditableTextBoxState>(),
        index: _textBoxes.length, // 传递当前文本框的索引
        onDelete: (index) {
          setState(() {
            if (index >= 0 && index < _textBoxes.length) {
              _textBoxes.removeAt(index); // 删除指定索引的文本框
              // 更新剩余文本框的索引
              for (int i = 0; i < _textBoxes.length; i++) {
                final textBox = _textBoxes[i] as EditableTextBox; // 确保类型转换
                _textBoxes[i] = EditableTextBox(
                  key: GlobalKey<_EditableTextBoxState>(),
                  index: i,
                  onDelete: textBox.onDelete,
                  initialOffset: textBox.getCurrentOffset(), // 使用方法偏移量
                );
              }
            }
          });
        },
        initialOffset: Offset(50, 100),
      ));
    });
  }

  // 添加一个状态变量来跟踪当前选择的调整类
  String _currentAdjustment = '曝光度'; // 默认选择曝光度

  void _showAdjustmentModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Stack(
              children: [
                _buildModalContent(setModalState), // 传递图像
                _buildCloseButton(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildModalContent(StateSetter setModalState) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        constraints: BoxConstraints(maxHeight: 500),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSingleSlider(setModalState),
              _buildAdjustmentIcons(setModalState) // 传递图像
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentIcons(StateSetter setModalState) {
    final adjustments = [
      {
        'name': '曝光度',
        'selectedIcon': 'assets/photo_printing/Group_6859.png',
        'unselectedIcon': 'assets/photo_printing/Group_6862.png',
      },
      {
        'name': '对比度',
        'selectedIcon': 'assets/photo_printing/Vector_5.png',
        'unselectedIcon': 'assets/photo_printing/Vector_4.png',
      },
      {
        'name': '饱和度',
        'selectedIcon': 'assets/photo_printing/Group_6861.png',
        'unselectedIcon': 'assets/photo_printing/Group_6860.png',
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: adjustments.map((adjustment) {
        return _buildAdjustmentIcon(
            adjustment['name']!,
            adjustment['selectedIcon']!,
            adjustment['unselectedIcon']!,
            setModalState);
      }).toList(),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      right: 16,
      bottom: 140,
      child: IconButton(
        icon: Image.asset("assets/photo_printing/Group_6865.png"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildAdjustmentIcon(
    String adjustmentType,
    String selectedIconPath,
    String unselectedIconPath,
    StateSetter setModalState,
  ) {
    final isSelected = _currentAdjustment == adjustmentType;

    return Column(
      children: [
        IconButton(
          icon: Image.asset(
            isSelected ? selectedIconPath : unselectedIconPath,
            width: 20,
            height: 20,
          ),
          onPressed: () {
            setModalState(() {
              _currentAdjustment = adjustmentType; // 更新当前调整类型
            });
            setState(() {});
          },
        ),
        Text(
          adjustmentType,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

// 使用 CustomSlider 的方法
  Widget _buildSingleSlider(StateSetter setModalState) {
    double currentValue;
    switch (_currentAdjustment) {
      case '曝光度':
        currentValue = _exposure;
        break;
      case '对比度':
        currentValue = _contrast;
        break;
      case '饱和度':
        currentValue = _saturation;
        break;
      default:
        currentValue = 0; // 默认值
    }

    return Column(
      children: [
        Text(
          _formatCurrentValue(currentValue),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        CustomSlider(
          value: currentValue,
          onChanged: (value) {
            setModalState(() {
              _updateAdjustment(value);
            });
            setState(() {});
          },
          thumbImage: AssetImage('assets/photo_printing/Ellipse_26.png'),
        ),
      ],
    );
  }

  void _updateAdjustment(double value) {
    switch (_currentAdjustment) {
      case '曝光度':
        _exposure = value;
        break;
      case '对比度':
        _contrast = value;
        break;
      case '饱和度':
        _saturation = value;
        break;
    }
  }

  String _formatCurrentValue(double value) {
    return value.toStringAsFixed(1);
  }

  Widget _buildImageDisplay() {
    final isCroppedImageAvailable =
        _croppedImage != null && _croppedImage!.isNotEmpty;
    final isOriginalImageAvailable = _image != null && _image!.path.isNotEmpty;

    if (!isCroppedImageAvailable && !isOriginalImageAvailable) {
      return ElevatedButton(
        onPressed: _pickImage,
        child: Text('上传打印图片'),
      );
    }

    final imageWidget = isCroppedImageAvailable
        ? Image.memory(_croppedImage!, fit: BoxFit.contain)
        : Image.file(File(_image!.path), fit: BoxFit.contain);

    return ColorFiltered(
      colorFilter: ColorFilter.matrix(_calculateColorMatrix()),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationZ(_rotationAngle),
        child: ClipRect(
          child: Align(
            alignment: Alignment.center,
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: _selectedImageMode == 'grayscale' && isCroppedImageAvailable
                ? ColorFiltered(
                    colorFilter: ColorFilter.matrix([
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]),
                    child: imageWidget,
                  )
                : imageWidget,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _stickers = []; // 存储贴纸信息，包括位置、URL和缩放比例
  double _initialScale = 1.0; // 用于记录初始缩放比例

  void _selectSticker() async {
    final selectedSticker = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许根据内容调整高度
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, // 设置初始高度为屏幕高度的一半
          child: StickerSelectionPage(),
        );
      },
    );

    if (selectedSticker != null) {
      setState(() {
        _stickers.add({
          'url': selectedSticker,
          'offset': Offset(100, 100), // 初始位置
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_pageTitle)),
        actions: [
          IconButton(
            icon:
                Image.asset("assets/photo_printing/print_yellow.png"), // 打印机图标
            onPressed: () {
              // 打印机功能的点击事件
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onDoubleTap: _addTextBox, // 双击添加文本框
        child: Stack(
          children: [
            Center(child: _buildImageDisplay()),
            ..._textBoxes, // 显示添加的文本框
            for (var sticker in _stickers)
              Positioned(
                left: sticker['offset'].dx,
                top: sticker['offset'].dy,
                child: GestureDetector(
                  onScaleStart: (details) {
                    // 在缩放开始时记录当前的缩放比例
                    _initialScale = sticker['scale'] ?? 1.0;
                  },
                  onScaleUpdate: (details) {
                    setState(() {
                      // 更新位置
                      sticker['offset'] += details.focalPointDelta;
                      // 基于初始缩放比例更新缩放比例
                      double newScale = _initialScale * details.scale;
                      // 打印调试信息
                      print(
                          'Old Scale: ${sticker['scale']}, New Scale: $newScale');
                      sticker['scale'] =
                          newScale.clamp(0.5, 3.0); // 限制缩放比例在0.5到3.0之间
                    });
                  },
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(sticker['scale'] ?? 1.0),
                    child: Image.network(
                      sticker['url'],
                      width: 100, // 初始宽度
                      height: 100, // 初始高度
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // 设置底部导航栏背景色
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/photo_printing/Vector.png",
                width: 24, height: 24), // 裁剪图标
            label: '裁剪',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/photo_printing/Vector_1.png",
                width: 24, height: 24), // 调节图标
            label: '调节',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/photo_printing/Group_6906.png",
                width: 24, height: 24), // 旋转图标
            label: '旋转',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/photo_printing/Vector_2.png",
                width: 24, height: 24), // 文字图标
            label: '文字',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/photo_printing/Vector_3.png",
                width: 24, height: 24), // 贴纸图标
            label: '贴纸',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/photo_printing/Group_6855.png",
                width: 24, height: 24), // 模式图标
            label: '模式',
          ),
        ],
        currentIndex: 0, // 当前选中的索引
        selectedItemColor: Colors.grey, // 选中时的颜色
        unselectedItemColor: Colors.grey, // 非选中的颜色
        iconSize: 30, // 图标大小
        showSelectedLabels: true, // 显示选中的标签
        showUnselectedLabels: true, // 显示未选中的标签
        onTap: (index) async {
          try {
            if (index == 0) {
              // 使用裁剪后的图像进行二次裁剪
              final imageToCrop = _croppedImage != null
                  ? _croppedImage
                  : await File(_image!.path).readAsBytes();

              final croppedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomImageCropPage(
                    imageData:
                        imageToCrop ?? Uint8List(0), // 使用空的 Uint8List 作为默认值
                  ),
                ),
              );

              if (croppedImage != null && croppedImage is Uint8List) {
                setState(() {
                  _croppedImage = croppedImage;
                  _pageTitle = '照片打印';
                });
              }
            } else if (index == 1) {
              // 检查使用裁剪后的图像还是原图像
              final imageToAdjust =
                  _croppedImage ?? await File(_image!.path).readAsBytes();

              // ignore: unnecessary_null_comparison
              if (imageToAdjust != null) {
                // 继续调节逻辑
                _showAdjustmentModal();
              } else {
                // 提示用户上传图片
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('请先上传图片')),
                );
              }
            } else if (index == 2) {
              if (_croppedImage != null) {
                // 旋转裁剪后的图片，而不是原始图片
                setState(() {
                  _rotationAngle += pi / 2;
                  if (_rotationAngle >= 2 * pi) {
                    _rotationAngle = 0;
                  }
                  _pageTitle = '旋转';
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('请上传并裁剪图片')),
                );
              }
            } else if (index == 3) {
              // 添加文本框逻辑
              setState(() {
                _addTextBox();
                _pageTitle = '文字';
              });
            } else if (index == 4) {
              // 点击贴纸按钮
              _selectSticker();
            } else if (index == 5) {
              // 这里是“模式”对应的索引
              _showModeSelection(); // 调用选择框
            }
          } catch (e) {
            // 处理异常
            print('发生错误: $e');
            // 你可以在这里显示一个错误提示
          }
        },
      ),
    );
  }

  // 显示模式选择
  Future<void> _showModeSelection() async {
    Uint8List? imageData = _croppedImage ?? _originalImage;

    if (imageData == null) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImageMode = 'normal';
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: _selectedImageMode == 'normal'
                                ? Border.all(color: Colors.yellow, width: 3)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                                _originalCroppedImage ?? imageData,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('普通'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImageMode = 'grayscale';
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: _selectedImageMode == 'grayscale'
                                ? Border.all(color: Colors.yellow, width: 3)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix([
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                              ]),
                              child: Image.memory(imageData,
                                  width: 50, height: 50, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('灰度'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// 可编辑文本框的组件
class EditableTextBox extends StatefulWidget {
  final int index;
  final Function(int) onDelete;
  final Offset initialOffset;
  final GlobalKey<_EditableTextBoxState> key; // 使用 GlobalKey

  Offset getCurrentOffset() {
    final state = key.currentState; // 直接使用 currentState
    return state?._offset ?? initialOffset;
  }

  EditableTextBox({
    required this.key, // 确保传递 GlobalKey
    required this.index,
    required this.onDelete,
    required this.initialOffset,
  }) : super(key: key);

  @override
  _EditableTextBoxState createState() => _EditableTextBoxState();
}

class _EditableTextBoxState extends State<EditableTextBox> {
  String _text = '双击编辑';
  late Offset _offset; // 追踪文本框的位置
  Size _size = Size(100, 50); // 文本框的默认大小
  bool _showLines = false; // 控制线条是否显示的变量

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset; // 初始化位置
  }

  // 显示输入框的模态底部弹窗
  void _showTextInputModal(BuildContext context) {
    TextEditingController _controller = TextEditingController(text: _text);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许底部弹窗控制滚动
      isDismissible: true, // 允许点击外部关闭
      backgroundColor: Colors.transparent, // 设置背景色为透明
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // 适配输入框弹出时的键盘
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white, // 输入框背景色
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)), // 圆角
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 使弹窗根据内容自适应高度
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: '请输入内容',
                          hintStyle: TextStyle(color: Colors.grey), // 提示文本颜色为灰色
                          filled: true,
                          fillColor: Color(0xFFE0E0E0), // 背景色
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none, // 移除默认边框
                            borderRadius: BorderRadius.circular(8), // 设置圆角
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _text = _controller.text.isNotEmpty
                              ? _controller.text
                              : '双击编辑';
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: Colors.yellow, // 文本颜色为黄色
                          fontWeight: FontWeight.bold, // 加粗
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 实时显示的线条
        if (_showLines) ...[
          // 左上角向上延伸
          Positioned(
            left: _offset.dx,
            top: 0,
            child: Container(
              width: 1,
              height: _offset.dy,
              color: Colors.yellow,
            ),
          ),
          // 左上角向左延伸
          Positioned(
            left: 0,
            top: _offset.dy,
            child: Container(
              width: _offset.dx,
              height: 1,
              color: Colors.yellow,
            ),
          ),
          // 右上角向上延伸
          Positioned(
            left: _offset.dx + _size.width,
            top: 0,
            child: Container(
              width: 1,
              height: _offset.dy,
              color: Colors.yellow,
            ),
          ),
          // 右上角向右延伸
          Positioned(
            left: _offset.dx + _size.width,
            top: _offset.dy,
            child: Container(
              width: MediaQuery.of(context).size.width -
                  (_offset.dx + _size.width),
              height: 1,
              color: Colors.yellow,
            ),
          ),
          // 左下角向下延伸
          Positioned(
            left: _offset.dx,
            top: _offset.dy + _size.height,
            child: Container(
              width: 1,
              height: MediaQuery.of(context).size.height -
                  (_offset.dy + _size.height),
              color: Colors.yellow,
            ),
          ),
          // 左下角向左延伸
          Positioned(
            left: 0,
            top: _offset.dy + _size.height,
            child: Container(
              width: _offset.dx,
              height: 1,
              color: Colors.yellow,
            ),
          ),
          // 右下角向下延伸
          Positioned(
            left: _offset.dx + _size.width,
            top: _offset.dy + _size.height,
            child: Container(
              width: 1,
              height: MediaQuery.of(context).size.height -
                  (_offset.dy + _size.height),
              color: Colors.yellow,
            ),
          ),
          // 右下角向右延伸
          Positioned(
            left: _offset.dx + _size.width,
            top: _offset.dy + _size.height,
            child: Container(
              width: MediaQuery.of(context).size.width -
                  (_offset.dx + _size.width),
              height: 1,
              color: Colors.yellow,
            ),
          ),
        ],
        // 辑框
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onDoubleTap: () {
              _showTextInputModal(context);
            },
            onPanUpdate: (details) {
              setState(() {
                _offset += details.delta; // 更新拖动位置
                _showLines = true; // 移动时显示线条
              });
            },
            onPanStart: (details) {
              setState(() {
                _showLines = true; // 开始拖动时显示线条
              });
            },
            onPanEnd: (details) {
              setState(() {
                _showLines = false; // 移动结束后隐藏线条
              });
            },
            child: Container(
              width: _size.width,
              height: _size.height,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent, // 设置背景色为透明
                border: Border.all(color: Colors.yellow), // 保留边框
              ),
              child: FittedBox(
                fit: BoxFit.contain, // 让文本占满整个文本框
                child: Text(
                  _text,
                  textAlign: TextAlign.center, // 将文本居中
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        // 调整大小的图标
        Positioned(
          left: _offset.dx + _size.width - 20, // 在右下角
          top: _offset.dy + _size.height - 20,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _size = Size(
                  (_size.width + details.delta.dx).clamp(50.0, double.infinity),
                  (_size.height + details.delta.dy)
                      .clamp(50.0, double.infinity),
                );
              });
            },
            child: Image.asset(
              "assets/photo_printing/Group_6867.png",
              width: 38,
              height: 38,
            ),
          ),
        ),
        // 删除图标
        Positioned(
          left: _offset.dx - 10,
          top: _offset.dy - 10,
          child: GestureDetector(
            onTap: () => widget.onDelete(widget.index), // 使用索引删除
            child: Image.asset(
              "assets/photo_printing/Group_6866.png",
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double value; // 当前值，范围应在-50到50
  final ValueChanged<double> onChanged; // 值变化时的回调
  final ImageProvider thumbImage; // 自定义图标
  final double sliderHeight; // 滑动条高度
  final double sliderWidth; // 滑动条宽度

  const CustomSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.thumbImage,
    this.sliderHeight = 10.0, // 默认高度为10.0
    this.sliderWidth = 300.0, // 默认宽度为300.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 计算每个单位对应的宽度
    double unitWidth = sliderWidth / 100;

    // 计算活动轨道的宽度
    double activeTrackWidth = (value.abs()) * unitWidth;
    // 假设滑动按钮的半径为15

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: sliderHeight,
        thumbShape: CustomSliderThumbShape(thumbImage: thumbImage),
        overlayShape: SliderComponentShape.noOverlay, // 去掉默认的阴影
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 背景条
          Container(
            width: sliderWidth,
            height: sliderHeight,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10), // 圆角
            ),
          ),
          // 活动部分
          Positioned(
            left: sliderWidth / 2 - (value < 0 ? activeTrackWidth : 0),
            child: Container(
              width: activeTrackWidth,
              height: sliderHeight,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10), // 圆角
              ),
            ),
          ),
          // 添加 Slider
          Container(
            width: sliderWidth,
            child: Slider(
              value: value,
              min: -50,
              max: 50,
              divisions: 100,
              onChanged: onChanged,
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              semanticFormatterCallback: (value) => value.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

// 自定义滑动按钮的形状
class CustomSliderThumbShape extends SliderComponentShape {
  final ImageProvider thumbImage;
  ImageInfo? imageInfo;

  CustomSliderThumbShape({required this.thumbImage}) {
    // 加载图像
    final imageStream = thumbImage.resolve(ImageConfiguration());
    imageStream.addListener(
      ImageStreamListener((ImageInfo info, bool sync) {
        imageInfo = info; // 存储加载后的图像信息
      }),
    );
  }

  @override
  Size getPreferredSize(bool isDiscrete, bool isEnabled) {
    return Size(30, 30); // 根据需要调整图标的大小
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final canvas = context.canvas;

    // 检查图像是否已经准备好
    if (imageInfo != null) {
      // 绘制图像，不添加阴影
      canvas.drawImage(
        imageInfo!.image,
        Offset(center.dx - imageInfo!.image.width / 2,
            center.dy - imageInfo!.image.height / 2),
        Paint(),
      );
    } else {
      // 如果图像准备好，可以绘制一个占位符（例如透明圆圈）
      final paint = Paint()..color = Colors.grey.withOpacity(0.5); // 默认颜色
      canvas.drawCircle(center, 15, paint); // 占位符
    }
  }
}
