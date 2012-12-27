function BranchesShow() {

  this.init = function() {
    draw_yinyang('branch-yinyang', gon.yinyang);
    return this.redraw();
  };

  this.redraw = function() {
    new TableHandler('#builds-listing-wrp');
  };

};

window.branches_show = new BranchesShow();

resource_libs.register('branches_show', branches_show);
