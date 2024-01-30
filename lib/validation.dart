class Logic {
  bool sameInContainer(List<List<int>> sudoku) {
    for (List<int> l in sudoku) {
      for (int i in l) {
        int c = l.where((element) => element == i).length;
        if (c > 1 && i != 0) {
          return true;
        }
      }
    }

    return false;
  }

  bool sameInLineHorizontal(List<List<int>> sudoku) {
    List<int> top = [0, 1, 2];
    List<int> middle = [3, 4, 5];
    List<int> bottom = [6, 7, 8];

    for (int i = 0; i < sudoku.length; i++) {
      for (int j = 0; j < sudoku[i].length; j++) {
        int e = sudoku[i][j];

        if (e != 0) {
          List<String> h = [
            top.contains(i)
                ? 'top'
                : middle.contains(i)
                    ? 'middle'
                    : 'bottom',
            top.contains(j)
                ? 'top'
                : middle.contains(j)
                    ? 'middle'
                    : 'bottom'
          ];

          if (h[0] == 'top') {
            if (h[1] == 'top') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (top.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (top.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'middle') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (top.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (middle.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'bottom') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (top.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (bottom.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          } else if (h[0] == 'middle') {
            if (h[1] == 'top') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (middle.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (top.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'middle') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (middle.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (middle.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'bottom') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (middle.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (bottom.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          } else if (h[0] == 'bottom') {
            if (h[1] == 'top') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (bottom.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (top.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'middle') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (bottom.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (middle.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'bottom') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (bottom.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (bottom.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    return false;
  }

  bool sameInLineVertical(List<List<int>> sudoku) {
    List<int> left = [0, 3, 6];
    List<int> middle = [1, 4, 7];
    List<int> right = [2, 5, 8];

    for (int i = 0; i < sudoku.length; i++) {
      for (int j = 0; j < sudoku[i].length; j++) {
        int e = sudoku[i][j];

        if (e != 0) {
          List<String> h = [
            left.contains(i)
                ? 'left'
                : middle.contains(i)
                    ? 'middle'
                    : 'right',
            left.contains(j)
                ? 'left'
                : middle.contains(j)
                    ? 'middle'
                    : 'right'
          ];

          if (h[0] == 'left') {
            if (h[1] == 'left') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (left.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (left.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'middle') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (left.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (middle.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'right') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (left.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (right.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          } else if (h[0] == 'middle') {
            if (h[1] == 'left') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (middle.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (left.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'middle') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (middle.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (middle.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'right') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (middle.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (right.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          } else if (h[0] == 'right') {
            if (h[1] == 'left') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (right.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (left.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'middle') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (right.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (middle.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            } else if (h[1] == 'right') {
              for (List<int> l in sudoku) {
                int il = sudoku.indexOf(l);
                if (right.contains(il) && il != i) {
                  for (int sl in l) {
                    int isl = l.indexOf(sl);
                    if (right.contains(isl)) {
                      if (sl == e) {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    return false;
  }
}
