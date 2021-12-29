class CodeUnit {
  final String _symbol;
  final double _chance;
  String _code;
  CodeUnit(String symbol, double chance)
      : _symbol = symbol,
        _chance = chance,
        _code = '';

  String get symbol => _symbol;
  double get chance => _chance;
  String get code => _code;

  void addToCodePostfix(int i) {
    _code += i.toString();
  }

  void addToCodePrefix(int i) {
    _code = i.toString() + _code;
  }

  String asString() {
    return 'Symbol - $_symbol, chance - $chance, code - $_code';
  }

  static int revComparator(CodeUnit f, CodeUnit s) {
    return f.chance.compareTo(s.chance) * -1;
  }
}
