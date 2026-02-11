import 'dart:math' as math;

class ExprParser {
  ExprParser(this._src);
  final String _src;
  int _pos = 0;

  double parse() {
    final result = _expr();
    if (_pos < _src.length) throw FormatException('Unexpected at $_pos: ${_src[_pos]}');
    return result;
  }

  double _expr() {
    double r = _term();
    while (_pos < _src.length) {
      if (_m('+')) { r += _term(); }
      else if (_m('-')) { r -= _term(); }
      else break;
    }
    return r;
  }

  double _term() {
    double r = _power();
    while (_pos < _src.length) {
      if (_m('*')) { r *= _power(); }
      else if (_m('/')) { r /= _power(); }
      else break;
    }
    return r;
  }

  double _power() {
    double b = _unary();
    if (_m('^')) return math.pow(b, _power()).toDouble();
    return b;
  }

  double _unary() {
    if (_m('-')) return -_unary();
    if (_m('+')) return _unary();
    return _atom();
  }

  double _atom() {
    if (_m('(')) { final r = _expr(); _e(')'); return r; }
    if (_mw('sin')) return _fn(math.sin);
    if (_mw('cos')) return _fn(math.cos);
    if (_mw('sqrt')) return _fn(math.sqrt);
    if (_mw('pi')) return math.pi;
    return _number();
  }

  double _fn(double Function(double) f) { _e('('); final a = _expr(); _e(')'); return f(a); }

  double _number() {
    final s = _pos;
    while (_pos < _src.length && '0123456789.'.contains(_src[_pos])) _pos++;
    if (_pos == s) throw FormatException('Expected number at $_pos');
    return double.parse(_src.substring(s, _pos));
  }

  bool _m(String c) { if (_pos < _src.length && _src[_pos] == c) { _pos++; return true; } return false; }
  bool _mw(String w) {
    if (_pos + w.length <= _src.length && _src.substring(_pos, _pos + w.length) == w) {
      _pos += w.length; return true;
    }
    return false;
  }
  void _e(String c) { if (!_m(c)) throw FormatException('Expected $c'); }
}

double eval(String expr, double x) {
  String p = expr.replaceAll(' ', '');
  p = p.replaceAll('exp', '\u0001');
  p = p.replaceAll('x', '($x)');
  p = p.replaceAll('\u0001', 'exp');
  return ExprParser(p).parse();
}

void main() {
  print('x^2 at x=-10: ${eval("x^2", -10)}  (expect 100)');
  print('x^2 at x=5:   ${eval("x^2", 5)}    (expect 25)');
  print('2*x+3 at x=4: ${eval("2*x+3", 4)}  (expect 11)');
  print('sin(x) at x=0: ${eval("sin(x)", 0)} (expect 0)');
  print('sin(x) at x=pi/2: ${eval("sin(x)", math.pi/2)} (expect ~1)');
  print('x^3 at x=-2:  ${eval("x^3", -2)}   (expect -8)');
  print('sqrt(x) at x=9: ${eval("sqrt(x)", 9)} (expect 3)');
  print('(x+1)*(x-1) at x=5: ${eval("(x+1)*(x-1)", 5)} (expect 24)');
}
