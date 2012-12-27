if (!requires_register.has('resource_selectors')) { // Prevent multiple requires
  requires_register.add('resource_selectors');

  ResourceOption = (function() {
    function ResourceOption(id, res_type, summary) {
      this.id = id;
      this.res_type = res_type;
      this.summary = ko.computed(function() {
        if (!(this.id != null) || !(summary != null) || Object.isEmpty(summary) || (Object.isArray(summary) && summary.isEmpty()) || (Object.isString(summary) && summary.isBlank())) {
          return this.summary = '';
        } else {
          return this.format(summary);
        }
      }, this);
    }
    ResourceOption.prototype.format = function(summary) {
      return summary;
    };
    ResourceOption.prototype.is_dummy = function() {
      return !(this.id != null) && this.summary() === '';
    };
    return ResourceOption;
  })();
  BranchesOption = (function() {
    __extends(BranchesOption, ResourceOption);
    function BranchesOption(id, summary) {
      BranchesOption.__super__.constructor.call(this, id, 'branches', summary);
    }
    return BranchesOption;
  })();
  BuildsOption = (function() {
    __extends(BuildsOption, ResourceOption);
    function BuildsOption(id, summary) {
      BuildsOption.__super__.constructor.call(this, id, 'builds', summary);
    }
    BuildsOption.prototype.format = function(summary) {
      return "" + summary[0] + " to " + summary[1] + " : " + summary[2];
    };
    return BuildsOption;
  })();
  StepsOption = (function() {
    __extends(StepsOption, ResourceOption);
    function StepsOption(id, summary) {
      StepsOption.__super__.constructor.call(this, id, 'steps', summary);
    }
    return StepsOption;
  })();
  ActionsOption = (function() {
    __extends(ActionsOption, ResourceOption);
    function ActionsOption(id, summary) {
      ActionsOption.__super__.constructor.call(this, id, 'actions', summary);
    }
    return ActionsOption;
  })();
  Resources = (function() {
    function Resources() {
      this.order = ['projects', 'branches', 'builds', 'steps', 'actions'];
      this.current_ids = {
        projects: null,
        branches: null,
        builds: null,
        steps: null,
        actions: null
      };
      this.first_times = {
        projects: null,
        branches: null,
        builds: null,
        steps: null,
        actions: null
      };
      this.current_ids[gon.current_resource.type] = gon.current_resource.id;
      this.first_times[gon.current_resource.type] = true;
    }
    Resources.prototype.previous = function(res_type) {
      var idx;
      idx = this.order.indexOf(res_type) - 1;
      if (idx < 0) {
        return;
      }
      if (idx >= this.order.length) {
        idx = this.order.length - 1;
      }
      return this.order[idx];
    };
    Resources.prototype.next = function(res_type) {
      var idx;
      idx = this.order.indexOf(res_type) + 1;
      if (idx < 0) {
        idx = 0;
      }
      if (idx >= this.order.length) {
        idx = this.order.length - 1;
      }
      return this.order[idx];
    };
    Resources.prototype.is_last = function(res_type) {
      return this.order.indexOf(res_type) === (this.order.length - 1);
    };
    Resources.prototype.create_option = function(id, res_type, summary) {
      switch (res_type) {
        case 'branches':
          return new BranchesOption(id, summary);
        case 'builds':
          return new BuildsOption(id, summary);
        case 'steps':
          return new StepsOption(id, summary);
        case 'actions':
          return new ActionsOption(id, summary);
      }
    };
    Resources.prototype.create_dummy_option = function(res_type) {
      return this.create_option(null, res_type, '');
    };
    Resources.prototype.check_after = function(res_type_1, res_type_2) {
      return this.order.indexOf(res_type_1) > this.order.indexOf(res_type_2);
    };
    return Resources;
  })();
  ResourceSelectorsViewModel = (function() {
    function ResourceSelectorsViewModel() {
      this.resources = new Resources();
      this.res_opts = {
        branches: ko.observableArray([this.resources.create_dummy_option('branches')]),
        builds: ko.observableArray([this.resources.create_dummy_option('builds')]),
        steps: ko.observableArray([this.resources.create_dummy_option('steps')]),
        actions: ko.observableArray([this.resources.create_dummy_option('actions')])
      };
      this.fetch(this.resources.next(gon.current_resource.type), gon.current_resource.id);
    }
    ResourceSelectorsViewModel.prototype.fetch = function(res_type, res_id) {
      var self;
      self = this;
      return $.ajax({
        url: "/" + res_type,
        dataType: 'json',
        data: {
          selector: 'summary',
          id: res_id
        },
        success: function(data) {
          var res_opts;
          if (!(Object.isArray(data) && data.isEmpty())) {
            res_opts = self.res_opts[res_type];
            res_opts.splice(1, res_opts().length);
            return data.each(function(summary) {
              return res_opts.push(self.resources.create_option(summary.id, res_type, summary.value));
            });
          }
        },
        error: function(xhr, txt_status, err_thrown) {
          var msg;
          msg = "" + txt_status + ": " + err_thrown;
          console.log("Error! " + msg);
          new Flash('error', msg);
        }
      });
    };
    return ResourceSelectorsViewModel;
  })();
  $(document).ready(function() {
    var $res_sel, $res_view, progress_bar;
    ko.applyBindings(new ResourceSelectorsViewModel());
    $res_view = $('.res-view');
    $res_sel = $('.res-sel');
    progress_bar = new ProgressBar();
    return $res_sel.live('change', function() {
      var $option, $select, res_id, res_opt, res_type, rsvm, url_controller, url_id;
      $select = $(this);
      $option = $(this, 'option:selected');
      rsvm = ko.contextFor(this).$root;
      res_type = $select.attr('data-restype');
      res_id = parseInt($option.attr('value')) || null;
      res_opt = rsvm.res_opts[res_type]().filter(function(e) {
        return e.id === res_id;
      })[0];
      rsvm.resources.current_ids[res_type] = res_id;
      if (!(rsvm.resources.first_times[res_type] != null)) {
        rsvm.resources.first_times[res_type] = true;
      } else {
        rsvm.resources.first_times[res_type] = false;
      }
      url_controller = res_opt.is_dummy() ? rsvm.resources.previous(res_type) : res_type;
      url_id = res_opt.is_dummy() ? rsvm.resources.current_ids[url_controller] : res_id;
      progress_bar.start($res_view);
      $.ajax({
        url: "/" + url_controller + "/" + url_id,
        dataType: 'html',
        method: 'get',
        success: function(data) {
          progress_bar.finish();
          $res_view.html(data);
          return $(document).trigger('resourceviewloaded', [url_controller, rsvm.resources.first_times[res_type]]);
        },
        error: function(xhr, txt_status, err_thrown) {
          var msg;
          progress_bar.finish();
          msg = "" + txt_status + ": " + err_thrown;
          console.log("Error! " + msg);
          new Flash('error', msg);
        }
      });
      Object.keys(rsvm.res_opts).each(function(key) {
        var res_opts;
        res_opts = rsvm.res_opts[key];
        if (rsvm.resources.check_after(key, res_type)) {
          return res_opts.splice(1, res_opts().length);
        }
      });
      if (!(res_opt.is_dummy() && rsvm.resources.is_last(res_type))) {
        return rsvm.fetch(rsvm.resources.next(res_type), res_id);
      }
    });
  });
}).call(this);
