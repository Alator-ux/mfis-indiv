import 'dart:io';

import 'code_unit.dart';

class Huffman {
  final List<CodeUnit> _units;
  Huffman(List<CodeUnit> units) : _units = List.from(units) {
    _units.sort(CodeUnit.revComparator);
    _setCodes(_units);
  }

  factory Huffman.fromList(List<List<dynamic>> rawUnits) {
    var units =
        rawUnits.map((e) => CodeUnit(e[0] as String, e[1] as double)).toList();
    return Huffman(units);
  }

  factory Huffman.fromFile(String filename) {
    var file = File(filename);
    var lines = file.readAsLinesSync();
    var rawUnits = <List<dynamic>>[];
    for (var line in lines) {
      if (line.isEmpty) {
        continue;
      }
      var args = line.trim().split(RegExp('\\s+'));
      rawUnits.add([args[0], double.tryParse(args[1]) ?? 0.0]);
    }
    return Huffman.fromList(rawUnits);
  }

  String _getCode(String symbol) {
    return _units.firstWhere((element) => element.symbol == symbol).code;
  }

  String _getSymbol(String code) {
    return _units
        .firstWhere((element) => element.code == code,
            orElse: () => CodeUnit('', 0.0))
        .symbol;
  }

  CodeUnit _getUnit(String symbol) {
    return _units.firstWhere((element) => element.symbol == symbol,
        orElse: () => CodeUnit('', 0.0));
  }

  void _untwistAndAdd(CodeUnit unit, int partCode) {
    for (var j = 0; j < unit.symbol.length; j++) {
      var c = unit.symbol.substring(j, j + 1);
      var u = _getUnit(c);
      u.addToCodePrefix(partCode);
    }
  }

  void _setCodes(List<CodeUnit> tUnits) {
    if (tUnits.length < 2) {
      return;
    }
    var f = tUnits[tUnits.length - 2];
    var s = tUnits[tUnits.length - 1];
    _untwistAndAdd(f, 0);
    _untwistAndAdd(s, 1);
    var newTUnits = tUnits.sublist(0, tUnits.length - 2);
    newTUnits.add(CodeUnit(f.symbol + s.symbol, f.chance + s.chance));
    newTUnits.sort(CodeUnit.revComparator);
    _setCodes(newTUnits);
  }

  void println() {
    for (var i = 0; i < _units.length; i++) {
      print(_units[i].asString());
    }
  }

  String encode(String source) {
    var res = '';
    for (var i = 0; i < source.length; i++) {
      res += _getCode(source.substring(i, i + 1));
    }
    return res;
  }

  String decode(String source) {
    var res = '';
    var t = 0;
    for (var i = 0; i < source.length; i++) {
      var symbol = _getSymbol(source.substring(t, i + 1));
      if (symbol != '') {
        res += symbol;
        t = i + 1;
      }
    }
    return res;
  }
}
