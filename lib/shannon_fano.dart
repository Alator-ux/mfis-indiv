import 'dart:io';

import 'code_unit.dart';

class ShanonFano {
  final List<CodeUnit> _units;
  ShanonFano(List<CodeUnit> units) : _units = List.from(units) {
    _units.sort(CodeUnit.revComparator);
    _setCodes(0, _units.length);
  }

  factory ShanonFano.fromList(List<List<dynamic>> rawUnits) {
    var units =
        rawUnits.map((e) => CodeUnit(e[0] as String, e[1] as double)).toList();
    return ShanonFano(units);
  }

  factory ShanonFano.fromFile(String filename) {
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
    return ShanonFano.fromList(rawUnits);
  }

  void _setCodes(int from, int to) {
    if (to - from < 2) {
      return;
    }
    var barrier = _splitEqualGroups(from, to);
    for (var i = from; i < from + barrier; i++) {
      _units[i].addToCodePostfix(0);
    }
    for (var i = from + barrier; i < to; i++) {
      _units[i].addToCodePostfix(1);
    }
    _setCodes(from, from + barrier);
    _setCodes(from + barrier, to);
  }

  int _splitEqualGroups(int from, int to) {
    if (to - from < 2) {
      throw Exception('There is no groups cause units length < 2');
    }
    var res = 0;
    var difference = double.maxFinite;
    var fgchance = 0.0; // first group chance
    for (var i = from; i < to - 1; i++) {
      var sgchance = 0.0; // second group chance
      fgchance += _units[i].chance;
      for (var j = i + 1; j < to; j++) {
        sgchance += _units[j].chance;
      }
      var t_dif = (fgchance - sgchance).abs();
      if (t_dif < difference) {
        difference = t_dif;
        res = i + 1 - from;
      } else if (t_dif == difference) {
        res = to - from - 1;
        break;
      } else {
        break;
      }
    }
    return res;
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

  void println() {
    for (var i = 0; i < _units.length; i++) {
      print(_units[i].asString());
    }
  }
}
