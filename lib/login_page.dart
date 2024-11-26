import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true; // 控制密码显示/隐藏
  bool _isChecked = false; // 控制复选框状态

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 229, 208),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Image.asset(
                'assets/mipmap-xxxhdpi/ziyuan3_1_1.png',
                height: 150,
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // 设置容器背景颜色
                    borderRadius: BorderRadius.circular(18), // 圆角
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 231, 204, 164), // 阴影颜色
                        offset: Offset(0, 2), // 阴影偏移
                        blurRadius: 10, // 模糊半径
                        spreadRadius: -1, // 扩散半径
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20), // 内边距
                  child: Column(
                    children: [
                      _buildTextField("assets/mipmap-xxxhdpi/login_user.png",
                          '请输入账号', false),
                      Divider(
                          color:
                              const Color.fromARGB(255, 209, 205, 205)), // 分割线
                      SizedBox(height: 10), // 间距
                      _buildPasswordField(),
                      Divider(
                          color:
                              const Color.fromARGB(255, 223, 218, 218)), // 分割线
                      SizedBox(height: 30),
                      _buildActionLinks(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildCustomCheckbox(),
              SizedBox(height: 20),
              _buildLoginButton(),
              SizedBox(height: 30),
              _buildThirdPartyLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(bottom: 15), // 设置顶部边距，向上移动
            child: Text(
              '现在注册',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(bottom: 15), // 设置顶部边距，向上移动
            child: Text(
              '忘记密码',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThirdPartyLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20), // 设置上下边距
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 20), // 左侧间距
              Expanded(
                child: Container(
                  height: 1, // 分割线高度
                  color: Colors.orange, // 分割线颜色
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10), // 设置文本左右边距
                child: Text(
                  '第三方快捷登录',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1, // 分割线高度
                  color: Colors.orange, // 分割线颜色
                ),
              ),
              SizedBox(width: 20), // 右侧间距
            ],
          ),
          SizedBox(height: 20), // 保持与 IconButton 的间距
          IconButton(
            icon: Image.asset('assets/mipmap-xxxhdpi/wechat_1.png'),
            iconSize: 40,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: 220, // 设置适当的宽度（可以根据需要调整）
      height: 45,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.zero, // 设置内边距为零，以便更好地控制布局
        ),
        child: Center(
          // 使用 Center 小部件居中
          child: Text(
            '登 录',
            style: TextStyle(color: Colors.white), // 设置文本颜色为白色
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: _obscureText,
      style: TextStyle(color: Colors.black), // 设置字体颜色
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0), // 添加一些内边距
          child: Image.asset(
            'assets/mipmap-xxxhdpi/login_pwd.png', // 替换为您的图标路径
            height: 24, // 根据需要调整高度
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Container(
            width: 24, // 设置固定宽度
            height: 24, // 设置固定高度
            child: Image.asset(
              _obscureText
                  ? 'assets/mipmap-xxxhdpi/vector_1.png' // 密码不可见的图标
                  : 'assets/mipmap-xxxhdpi/vector.png', // 密码可见的图标
            ),
          ),
        ),
        hintText: '请输入密码',
        hintStyle: TextStyle(color: Colors.grey), // 设置提示文本颜色
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // 圆角
          borderSide: BorderSide.none, // 移除边框
        ),
        filled: false, // 不填充背景颜色
      ),
    );
  }

  Widget _buildCustomCheckbox() {
    return Container(
      alignment: Alignment.center, // 容器内内容居中
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 行内容居中
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isChecked = !_isChecked;
              });
            },
            child: Image.asset(
              _isChecked
                  ? 'assets/mipmap-xxxhdpi/ellipse_12.png' // 选中状态的自定义图标
                  : 'assets/mipmap-xxxhdpi/ellipse_12.png', // 未选中状态的自定义图标
              width: 24, // 图标宽度
              height: 24, // 图标高度
            ),
          ),
          SizedBox(width: 10),
          RichText(
            text: TextSpan(
              text: '我已阅读并同意',
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: '《用户协议》',
                  style: TextStyle(color: Colors.orange),
                ),
                TextSpan(text: '和'),
                TextSpan(
                  text: '《隐私协议》',
                  style: TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String imagePath, String hintText, bool obscureText) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // 设置字体颜色
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            imagePath,
            height: 24,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey), // 设置提示文本颜色
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: false,
      ),
    );
  }
}
