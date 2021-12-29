import 'dart:io';

import 'package:mozi_2/huffman.dart';
import 'package:mozi_2/shannon_fano.dart';


void main(List<String> arguments) {
  print('Кодирование Шеннона-Фано');
  var args = [
    ['a', 0.4],
    ['b', 0.15],
    ['c', 0.15],
    ['d', 0.15],
    ['e', 0.15],
  ];
  print('Входные данные:\n' + args.toString());
  var sf = ShanonFano.fromList(args);
  print('Символы и их коды:');
  sf.println();
  var toEncode = 'aac';
  stdout.write('Закодируем строку ' + toEncode + ': ');
  var toDecode = sf.encode(toEncode);
  print(toDecode);
  stdout.write('Раскодируем строку ' + toDecode + ': ');
  print(sf.decode(toDecode));
  print('--------------------------------');

  print('Кодирование Хаффмана');
  print('Входные данные:\n' + args.toString());
  var h = Huffman.fromList(args);
  print('Символы и их коды:');
  h.println();
  stdout.write('Закодируем строку ' + toEncode + ': ');
  toDecode = h.encode(toEncode);
  print(toDecode);
  stdout.write('Раскодируем строку ' + toDecode + ': ');
  print(h.decode(toDecode));

  stdin.readLineSync();
}
