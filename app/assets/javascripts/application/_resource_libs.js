if (!requires_register.has('resource_libs')) { // Prevent multiple requires
  requires_register.add('resource_libs');

  var ResourceLibs = function() {
    this.libs = {};

    this.register = function(res_type, res_lib) {
      this.libs[res_type] = res_lib;
    };

    this.lookup = function(res_type) {
      return this.libs[res_type];
    };

  };

  window.resource_libs = new ResourceLibs();
}
