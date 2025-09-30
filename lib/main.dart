import 'package:flutter/material.dart';//библиотека с виджетами

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);
  //конструктор класса,кей стнд параметр вид
  @override //переопределяем 
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,//убираем красный баннер дебаг
      home: CalculatorHomePage(),//стартовая стр
    );
  }
}

class CalculatorHomePage extends StatefulWidget { //StatefulWidget хранит и изменяеть состояние
  const CalculatorHomePage({Key? key}) : super(key: key);

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}
  //класс сос всей логикой, приватный начинается _
class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '0';
  double? _firstOperand;//храним первый операнд,тип нулабл потому что может быть пустым
  String? _operator;//текущий операторы
  bool _shouldResetDisplay = false;//флаг коггда правда это заменить на другую 

  void _numClick(String text) {//функция обработки 
    setState(() { //обновляет состояние и перерисовывает юай
      if (_shouldResetDisplay || _display == '0') {
        // начинаем новый ввод (заменяем 0) или после оператора
        if (text == '.') {
          _display = '0.';
        } else {
          _display = text;
        }
        _shouldResetDisplay = false;
      } else {
        if (text == '.' && _display.contains('.')) {
          // не добавлять второй разделитель
          return;
        }
        _display += text;
      }
    });
  }

  void _operatorClick(String op) { //функция обработка нажатия оператора 
    setState(() {
      if (_operator != null && !_shouldResetDisplay) {
        // если уже есть оператор и пользователь ввёл второй операнд — посчитать предыдущую операцию
        _calculate();
      } else {
        _firstOperand = double.tryParse(_display) ?? 0.0;
      }
      _operator = op;
      _shouldResetDisplay = true;
    });
  }

  void _calculate() {
    if (_operator == null || _firstOperand == null) return;

    final second = double.tryParse(_display) ?? 0.0;
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = _firstOperand! + second;
        break;
      case '−':
        result = _firstOperand! - second;
        break;
      case '×':
        result = _firstOperand! * second;
        break;
      case '÷':
        if (second == 0.0) {
          _display = 'Error';
          _firstOperand = null;
          _operator = null;
          _shouldResetDisplay = true;
          setState(() {});
          return;
        }
        result = _firstOperand! / second;
        break;
      default:
        return;
    }

    _display = _formatResult(result);
    _firstOperand = result;
    _operator = null;
    _shouldResetDisplay = true;
    setState(() {});
  }

  void _clear() { //сбрасывает все
    setState(() {
      _display = '0';
      _firstOperand = null;
      _operator = null;
      _shouldResetDisplay = false;
    });
  }

  void _delete() { // удаление
    setState(() {
      if (_shouldResetDisplay || _display == 'Error') {
        _display = '0';
        _shouldResetDisplay = false;
        return;
      }
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _percent() { //процент
    setState(() { //перерисовать экран с новыми данными, то есть обновить 
      final val = double.tryParse(_display) ?? 0.0;
      final res = val / 100.0;
      _display = _formatResult(res);
    });
  }

  String _formatResult(double val) { //форматирует результат на нолей, убирает ,0
    // если целое — показываем без .0, иначе обрезаем лишние нули
    if (val == val.truncateToDouble()) {
      return val.toInt().toString();
    } else {
      String s = val.toStringAsFixed(8); // максимум 8 знаков после запятой
      s = s.replaceFirst(RegExp(r'0+$'), ''); // убрать хвостовые нули
      s = s.replaceFirst(RegExp(r'\.$'), ''); // убрать точку если вдруг
      return s;
    }
  }

  Widget _buildButton(String text,
      {Color? bgColor, Color? textColor, int flex = 1}) {
    final bool isOperator = text == '+' ||
        text == '−' ||
        text == '×' ||
        text == '÷' ||
        text == '=' ||
        text == '%';
    return Expanded(
      flex: flex, //ширина
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton( //кнопка с приподнятом стилем 
          onPressed: () { //что делать при нажатии
            if (text == 'C') {
              _clear();
            } else if (text == '⌫') {
              _delete();
            } else if (text == '=') {
              _calculate();
            } else if (text == '%') {
              _percent();
            } else if (isOperator) {
              _operatorClick(text);
            } else {
              _numClick(text);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            backgroundColor: bgColor ?? //фон
                (isOperator ? Colors.orangeAccent : Colors.grey[850]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            elevation: 4,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { //рисует экран
    return Scaffold( // базовый макет,фон колонки
       backgroundColor: const Color(0xFF0A0E21),
     //без сейфареа содержимое попадало под вырезы
      body: SafeArea( //боди основные содержимое экрана
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                alignment: Alignment.bottomRight, //алигмент выравнивание
                child: Text(
                  _display,
                  maxLines: 2,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded( //делит доступное место пропорционально
              flex: 5,
              child: Container( //как коробка для других виджетов
              //паддинг отступы и маржин
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
               //декарейшн цыет фон границы скругление
                decoration: const BoxDecoration(
                  color: Color(0xFF11131A),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24.0)),
                ),
                child: Column( //расположить виджетов вертикально
                  children: [
                    Row( //роу расположить горизонтально 
                      children: [
                        _buildButton('C', bgColor: Colors.redAccent),
                        _buildButton('⌫', bgColor: Colors.blueGrey),
                        _buildButton('%', bgColor: Colors.blueGrey),
                        _buildButton('÷', bgColor: Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('7'),
                        _buildButton('8'),
                        _buildButton('9'),
                        _buildButton('×', bgColor: Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('4'),
                        _buildButton('5'),
                        _buildButton('6'),
                        _buildButton('−', bgColor: Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('1'),
                        _buildButton('2'),
                        _buildButton('3'),
                        _buildButton('+', bgColor: Colors.orangeAccent),
                      ],
                    ),
                    Row(
                      children: [
                        _buildButton('0', flex: 2),
                        _buildButton('.'),
                        _buildButton('=', bgColor: Colors.greenAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
