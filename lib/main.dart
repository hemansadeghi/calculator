import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // برای محاسبات دقیق

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDarkMode = false; // متغیر برای ذخیره وضعیت تم

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ماشین حساب',
      debugShowCheckedModeBanner: false,
      theme:
          _isDarkMode
              ? ThemeData(
                brightness: Brightness.dark, // تم شب
                primarySwatch: Colors.blueGrey,
                scaffoldBackgroundColor:
                    Colors.black, // رنگ پس‌زمینه در حالت شب
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
              : ThemeData(
                brightness: Brightness.light, // تم روز
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor:
                    Colors.white, // رنگ پس‌زمینه در حالت روز
                textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
      home: CalculatorScreen(
        isDarkMode: _isDarkMode, // ارسال وضعیت تم به صفحه ماشین حساب
        toggleTheme: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> toggleTheme;

  const CalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '';

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = _calculate(_input);
        } catch (_) {
          _result = 'خطا';
        }
      } else if (value == '⌫') {
        // دکمه پاک کردن باید آخرین کاراکتر را از ورودی پاک کند
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else {
        _input += value;
      }
    });
  }

  String _calculate(String input) {
    try {
      final expression = input.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p =
          Parser(); // استفاده از Parser برای تبدیل ورودی به یک شیء Expression
      Expression exp = p.parse(expression); // استفاده از متد parse
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (_) {
      return 'خطا';
    }
  }

  Widget _buildButton(String text, {Color color = Colors.blueGrey}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(22),
        shape: const CircleBorder(), // دکمه‌های معمولی گرد خواهند بود
      ),
      onPressed: () => _onPressed(text),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(
            context,
          ).scaffoldBackgroundColor, // تغییر رنگ پس‌زمینه با توجه به تم
      appBar: AppBar(
        title: const Text('ماشین حساب'),
        actions: [
          Switch(value: widget.isDarkMode, onChanged: widget.toggleTheme),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _input,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // دکمه پاک کردن
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          22,
                        ), // گوشه‌های دکمه کمی گرد می‌شود
                      ),
                    ),
                    onPressed: () => _onPressed('⌫'), // عملکرد حذف کردن
                    child: const Text(
                      '⌫',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(206, 253, 253, 253),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('÷', color: Colors.orange),
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('×', color: Colors.orange),
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('-', color: Colors.orange),
                  _buildButton('C', color: Colors.red),
                  _buildButton('0'),
                  _buildButton('+', color: Colors.orange),
                  _buildButton('=', color: Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
