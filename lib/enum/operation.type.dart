enum OperationTypeEnum {
  add(symbol: '+'),
  subtract(symbol: '-'),
  multiply(symbol: '×'),
  divide(symbol: '÷');

  final String symbol;
  const OperationTypeEnum({required this.symbol});
}
