import 'package:flutter/foundation.dart';
import 'package:sudoku_solver/validation.dart';

class Solve {
  List<List<int>>? solver(List<List<int>>? s) {
    final List<List<int>> o = s!.map((e) => e.toList()).toList();
    List<List<int>> zeroList = findZeros(s);
    List<List<int>> pr = possibleSolutions(s, [], zeroList);
    if (kDebugMode) {
      print(zeroList);
      print(pr);
    }

    s = checkBox(0, o, s, zeroList, pr);

    return s;
  }

  List<List<int>>? checkBox(int i, List<List<int>> o, List<List<int>> s,
      List<List<int>> zeroList, List<List<int>> pr) {
    if (kDebugMode) {
      print(i);
    }
    final List<List<int>> temp = s.map((e) => e.toList()).toList();

    if (i == 9) {
      return s;
    } else {
      for (int j = 0; j < pr[i].length; j++) {
        int k = 0;

        for (var element in zeroList[i]) {
          temp[i][element] = int.parse(pr[i][j].toString()[k]);
          k++;
        }

        if (!validator(temp)) {
          List<List<int>>? result = checkBox(i + 1, o, temp, zeroList, pr);
          if (result != null) {
            return result;
          }
        }
      }
      return null;
    }
  }

  List<List<int>> possibleSolutions(
      List<List<int>> s, List<List<int>> pr, List<List<int>> zeroList) {
    List<List<int>> temp = s.map((e) => e.toList()).toList();

    for (int i = 0; i < temp.length; i++) {
      pr.add([]);
      int r = int.parse('1' * countZeros(temp[i]));
      int max = int.parse('1${'0' * r.toString().length}');
      for (var element in temp[i]) {
        if (element == 0) {
          temp[i][temp[i].indexOf(element)] = int.parse(r.toString()[0]);
        }
      }

      while (r < max) {
        r++;

        while (r.toString().contains('0')) {
          r++;
        }

        int j = 0;
        for (var element in zeroList[i]) {
          temp[i][element] = int.parse(r.toString()[j]);
          j++;
        }

        if (!validator(temp)) {
          pr[i].add(r);
        }
      }

      temp = s.map((e) => e.toList()).toList();
    }

    return pr;
  }

  List<List<int>> findZeros(List<List<int>> s) {
    List<List<int>> zeroIndices = [];

    for (int i = 0; i < s.length; i++) {
      zeroIndices.add([]);
      for (int j = 0; j < s[i].length; j++) {
        if (s[i][j] == 0) {
          zeroIndices[i].add(j);
        }
      }
    }
    return zeroIndices;
  }

  int countZeros(List<int> numbers) {
    int count = 0;
    for (int number in numbers) {
      if (number == 0) {
        count++;
      }
    }
    return count;
  }

  bool validator(List<List<int>> s) {
    return (Logic().sameInContainer(s) ||
        Logic().sameInLineHorizontal(s) ||
        Logic().sameInLineVertical(s));
  }

  bool checkFullList(List<List<int>> s) {
    int a = 0;

    for (var element in s) {
      for (var e in element) {
        if (e != 0) {
          a++;
        }
      }
    }

    return a == 81 ? true : false;
  }
}
