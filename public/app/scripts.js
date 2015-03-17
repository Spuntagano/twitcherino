var _base;

if (!(typeof (_base = String.prototype).startsWith === "function" ? _base.startsWith() : void 0)) {
  String.prototype.startsWith = function(str) {
    return this.indexOf(str) === 0;
  };
}
