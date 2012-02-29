(function() {var __contracts, Undefined, Null, Num, Bool, Str, Odd, Even, Pos, Nat, Neg, Self, Any, None, __old_exports, __old_require;
if (typeof(window) !== 'undefined' && window !== null) {
  __contracts = window.Contracts;
} else {
  __contracts = require('contracts.js');
}
Undefined =  __contracts.Undefined;
Null      =  __contracts.Null;
Num       =  __contracts.Num;
Bool      =  __contracts.Bool;
Str       =  __contracts.Str;
Odd       =  __contracts.Odd;
Even      =  __contracts.Even;
Pos       =  __contracts.Pos;
Nat       =  __contracts.Nat;
Neg       =  __contracts.Neg;
Self      =  __contracts.Self;
Any       =  __contracts.Any;
None      =  __contracts.None;

if (typeof(exports) !== 'undefined' && exports !== null) {
  __old_exports = exports;
  exports = __contracts.exports("foo.coffee", __old_exports)
}
if (typeof(require) !== 'undefined' && require !== null) {
  __old_require = require;
  require = function(module) {
    module = __old_require.apply(this, arguments);
    return __contracts.use(module, "foo.coffee");
  };
}
(function() {
  var Callback, Func1, Func2, Node, NodeAddr, def_addr, foo;

  NodeAddr = __contracts.object({
    port: Num,
    host: Str
  }, {});

  Callback = __contracts.fun([], Any, {});

  Node = __contracts.guard(__contracts.fun([NodeAddr, __contracts.arr([__contracts.___(Any)]), Callback], __contracts.object({
    exposeSignals: __contracts.fun([__contracts.arr([__contracts.___(Str)])], Any, {})
  }, {}), {
    newOnly: true
  }),(function() {

    function _Class(address, services, next) {}

    _Class.prototype.addr = null;

    _Class.prototype.address = function(addr) {
      if (!addr) {
        return this.addr;
      } else {
        return this.addr = addr;
      }
    };

    _Class.prototype.exposeSignals = function() {};

    return _Class;

  })());

  def_addr = {
    port: 1,
    host: 'foo'
  };

  Func1 = __contracts.fun([Num], Str, {});

  Func2 = __contracts.fun([], Any, {});

  foo = __contracts.guard(__contracts.or(Func1, Func2),function(a) {
    return a;
  });

  foo('a');

}).call(this);
}).call(this);
