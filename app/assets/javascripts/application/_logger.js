if (!requires_register.has('logger')) { // Prevent multiple requires
  requires_register.add('logger');

  window.Logger = function(global_opts) {
    // { Get the arguments and merge them with the defaults
    var default_opts = {
      alert: false
    }
    if (Object.isObject(global_opts)) {
      this.global_opts = Object.merge(default_opts, global_opts);
    } else {
      this.global_opts = default_opts;
    }
    // }

    this.log = function(msg, opts) {
      // { Get the arguments override the global options
      if (Object.isObject(opts)) {
        opts = Object.merge(global_opts, opts);
      } else {
        opts = global_opts;
      }
      // }

      if (!opts.suppress) {
        console.log(msg);   // Log the message into the console

        if (opts.alert) {
          alert(msg);       // Log the message with an alert
        }
      }
    }
  }

  window.default_logger = new Logger();
}
