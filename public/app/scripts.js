var _base;

Array.prototype.unique = function() {
    var a = this.concat();
    for(var i=0; i<a.length; ++i) {
        for(var j=i+1; j<a.length; ++j) {
            if(a[i] === a[j])
                a.splice(j--, 1);
        }
    }

    return a;
};

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
