if (!requires_register.has('table_handler')) { // Prevent multiple requires
  requires_register.add('table_handler');


  window.TableHandler = function(wrp_selectors, opts) {
    // { Get the arguments and merge them with the defaults
    var that = this,
        default_opts = {
          pagination: true
        }

    wrp_selectors = Array.create(wrp_selectors);

    if (Object.isObject(opts)) {
      this.opts = Object.merge(default_opts, opts);
    } else {
      this.opts = default_opts;
    }
    // }

    wrp_selectors.each(function(wrp_selector) {
      var $listing_pag_links = $('{1}>.pagination a'.assign(wrp_selector)),
          progress_bar = new ProgressBar(false);

      // { Handle ajax pagination if 'opts.pagination == true'
      if (that.opts.pagination) {
        $listing_pag_links.live('ajax:before', function($type, data) {    // Before AJAX Requests
          var $listing_wrp = $(this).parents(wrp_selector);
          progress_bar.start($listing_wrp);
        });

        $listing_pag_links.live('ajax:success', function($type, data) {   // On AJAX Success
          var $listing_wrp = $(this).parents(wrp_selector);
          progress_bar.finish();
          $listing_wrp.html(data);
        });

        $listing_pag_links.live('ajax:error', function($type, data) {     // On AJAx Error
          var $listing_wrp = $(this).parents(wrp_selector);
          progress_bar.finish();
        });
      }
      // }
    });

  };
}
