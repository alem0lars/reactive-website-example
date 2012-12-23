if (!requires_register.has('progress_bar')) { // Prevent multiple requires
  requires_register.add('progress_bar');

  window.ProgressBar = function(replace) {
    // { Get the arguments and merge them with the defaults
    if (replace == null) {
      replace = true;
    }
    // }
    this.replace = replace;
    this.$container = null;
    this.$old_content = null;
    this.finished = null;

    // { Create the progress_bar
    this.$progress_bar_wrp_classes = '.progress, .progress-striped, .active';
    this.$progress_bar_wrp = $('<div />', {
      "class": 'progress progress-striped active'
    });
    this.$progress_bar = $('<div />', {
      "class": 'bar'
    }).css('width', '100%').appendTo(this.$progress_bar_wrp);
    // }

    // Start the progressbar animation
    this.start = function(container) {
      var animator,
          self = this;

      if ($(container).length > 1) {
        throw 'ProgressBar Error: A container for a progress bar must be unique';
      }

      // { Add the progress_bar into its container
      this.$container = $(container);
      this.$old_content = this.$container.html();
      this.finished = false;
      if (this.replace) { // Replace the container's contents with the progress_bar
        this.$container.html(this.$progress_bar_wrp);
      } else {            // Put the progress_bar on top of the container's contents
        this.$progress_bar_wrp.prependTo(this.$container);
      }
      // }

      // Function to animate the progress bar until this.finished == false
      animator = function() {
        if (!self.finished) {
          setTimeout(function() {
            self.$progress_bar.css('width', '0%');
            setTimeout(function() {
              self.$progress_bar.css('width', '100%');
              animator();
            }, 600);
          }, 600);
        }
      };

      // Trigger the first animation
      animator();
    };

    // Finish the progressbar animation
    this.finish = function() {
      this.$container.children(this.$progress_bar_wrp_classes).remove();
      this.finished = true;
    };

    // Finish and rollback to the old content
    this.rollback = function() {
      this.finish();
      this.$container.html(this.$old_content);
    };

  }
}
