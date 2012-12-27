if (!Object.has(window, 'requires_register')) { // Prevent multiple requires

  window.RequiresRegister = function() {
    this.requires = [];

    this.add = function(require_name) {
      this.requires.push(require_name);
    };

    this.has = function(require_name) {
      !Object.equal(this.requires.findIndex(require_name), -1);
    };

  };

  window.requires_register = new RequiresRegister();
}
