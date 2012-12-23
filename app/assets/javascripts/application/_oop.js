if (!requires_register.has('oop')) { // Prevent multiple requires
  requires_register.add('oop');

  // Function to perform inheritance. The 'child' object inherits from the 'parent' object.
  window.extends = function(child, parent) {
    for (var key in parent) { if (Object.prototype.hasOwnProperty.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };

}
