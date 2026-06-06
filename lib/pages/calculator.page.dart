import 'package:flutter/material.dart';
import 'package:piloto/enum/operation.type.dart';
import 'package:piloto/pages/historic.page.dart';
import 'package:piloto/widgets/button.widget.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late String displayNumber;
  late List<String> historic;

  @override
  void initState() {
    displayNumber = "0";
    historic = [];
    super.initState();
  }

  void setOperationType(OperationTypeEnum newType) {
    setState(() {
      displayNumber += newType.symbol;
    });
  }

  void clear() {
    setState(() {
      displayNumber = "0";
    });
  }

  void backspace() {
    setState(() {
      if (displayNumber.length <= 1) {
        displayNumber = "0";
      } else {
        displayNumber = displayNumber.substring(0, displayNumber.length - 1);
      }
    });
  }

  void appendNumber(String stringNumber) {
    setState(() {
      if (displayNumber == "0") {
        displayNumber = stringNumber;
      } else {
        displayNumber += stringNumber;
      }
    });
  }

  List<double> parseNumbers(String expression) {
    RegExp regExp = RegExp(r'\d+\.?\d*');

    var matches = regExp.allMatches(expression);

    List<double> numbers = [];
    for (var match in matches) {
      String numberText = match.group(0)!;
      print(numberText);
      numbers.add(double.parse(numberText));
    }
    return numbers;
  }

  List<OperationTypeEnum> getOperators(String expression) {
    final expression1 = expression.characters.where(
      (x) => OperationTypeEnum.values.any((op) => op.symbol == x),
    );

    return expression1
        .map((x) => OperationTypeEnum.values.firstWhere((op) => op.symbol == x))
        .toList();
  }

  void resolvePriorityOperations(
    List<double> numbers,
    List<OperationTypeEnum> operations,
  ) {
    int index = 0;
    while (index < operations.length) {
      if (operations[index] == OperationTypeEnum.multiply) {
        numbers[index] = numbers[index] * numbers[index + 1];
        numbers.removeAt(index + 1);
        operations.removeAt(index);
      } else if (operations[index] == OperationTypeEnum.divide) {
        numbers[index] = numbers[index] / numbers[index + 1];
        numbers.removeAt(index + 1);
        operations.removeAt(index);
      } else {
        index++;
      }
    }
  }

  double resolveAdditionAndSubtraction(
    List<double> numbers,
    List<OperationTypeEnum> operations,
  ) {
    int index = 0;
    while (index < operations.length) {
      if (operations[index] == OperationTypeEnum.add) {
        numbers[0] = numbers[0] + numbers[index + 1];
        //  numbers.removeAt(index + 1);
      } else {
        numbers[0] = numbers[0] - numbers[index + 1];
        // numbers.removeAt(index + 1);
      }
      index++;
    }

    return numbers[0];
  }

  void calculate() {
    String expression = displayNumber.replaceAll(',', '.');
    List<double> numbers = parseNumbers(expression);
    List<OperationTypeEnum> operations = getOperators(expression);

    resolvePriorityOperations(numbers, operations);
    final result = resolveAdditionAndSubtraction(numbers, operations);

    setState(() {
      displayNumber = result.toString().replaceAll('.', ',');
      historic.add("$expression = $result");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoricPage(historic: historic),
                ),
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.maxFinite,
            color: Colors.black12,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                displayNumber,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ButtonWidget(
                    text: "C",
                    color: Colors.red,
                    onPressed: () {
                      clear();
                    },
                  ),
                  ButtonWidget(
                    color: Colors.orange,
                    text: "\u232B",
                    onPressed: () {
                      backspace();
                    },
                  ),
                  ButtonWidget(
                    text: "÷",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.divide);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "7",
                    onPressed: () {
                      appendNumber("7");
                    },
                  ),
                  ButtonWidget(
                    text: "8",
                    onPressed: () {
                      appendNumber("8");
                    },
                  ),
                  ButtonWidget(
                    text: "9",
                    onPressed: () {
                      appendNumber("9");
                    },
                  ),
                  ButtonWidget(
                    text: "x",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.multiply);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  ButtonWidget(
                    text: "4",
                    onPressed: () {
                      appendNumber("4");
                    },
                  ),
                  ButtonWidget(
                    text: "5",
                    onPressed: () {
                      appendNumber("5");
                    },
                  ),
                  ButtonWidget(
                    text: "6",
                    onPressed: () {
                      appendNumber("6");
                    },
                  ),
                  ButtonWidget(
                    text: "-",
                    onPressed: () {
                      setOperationType(OperationTypeEnum.subtract);
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              ButtonWidget(
                text: "1",
                onPressed: () {
                  appendNumber("1");
                },
              ),
              ButtonWidget(
                text: "2",
                onPressed: () {
                  appendNumber("2");
                },
              ),
              ButtonWidget(
                text: "3",
                onPressed: () {
                  appendNumber("3");
                },
              ),
              ButtonWidget(
                text: "+",
                onPressed: () {
                  setOperationType(OperationTypeEnum.add);
                },
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
          Row(
            children: [
              ButtonWidget(
                text: "0",
                onPressed: () {
                  appendNumber("0");
                },
              ),
              ButtonWidget(
                text: ",",
                onPressed: () {
                  appendNumber(",");
                },
              ),
              ButtonWidget(
                text: "=",
                onPressed: () {
                  calculate();
                },
                color: Colors.green,
                textColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
