var _base;

if (!(typeof (_base = String.prototype).startsWith === "function" ? _base.startsWith() : void 0)) {
  String.prototype.startsWith = function(str) {
    return this.indexOf(str) === 0;
  };
}

$(document).ready(function() {
  return $('.dropdown-login').on('click', function(event) {
    return event.stopPropagation();
  });
});
