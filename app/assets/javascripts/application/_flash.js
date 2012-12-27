if (!requires_register.has('flash')) { // Prevent multiple requires
  requires_register.add('flash');

  window.Flash = function (type, msg, duration) {
    var classes = 'alert',
        flash_container,
        pre_msg = null;

    // { Handle default arguments
    if (Object.equal(duration, null)) {
      duration = Flash.Durations.SLOW;
    }
    // }

    // Create the pre-message and the classes
    if (Object.equal(type, 'error') || Object.equal(type, 'alert')) {
      classes = '{1} alert-error'.assign(classes);
      pre_msg = 'Error!';
    } else if (Object.equal(type, 'warning')) {
      pre_msg = 'Warning!';
    } else if (Object.equal(type, 'success')) {
      classes = '{1} alert-success'.assign(classes);
      pre_msg = 'Success!';
    } else if (Object.equal(type, 'info') || Object.equal(type, 'notice')) {
      classes = '{1} alert-info'.assign(classes);
    }

    // Container for a flash message
    flash_container = $('<div/>', {'class': classes}).appendTo($('#messages'));

    if (!Object.equal(pre_msg, null)) {
      pre_msg = $('<strong />', {text: pre_msg}).prop('outerHTML');
      flash_container.append('{1} {2}'.assign(pre_msg, msg));
    } else {
      flash_container.append(msg);
    }

    if (!Object.equal(duration, Flash.Durations.PERMANENT)) {
      flash_container.fadeOut(duration);
    }
  }

  window.Flash.Durations = {
    PERMANENT: null,
    SLOW: 6000,
    FAST: 3000
  };

  $(document).ready(function() {
    $('#messages div').fadeOut(Flash.Durations.SLOW);
  });
}
