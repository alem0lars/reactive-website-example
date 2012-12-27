function ProjectsShow() {

  this.init = function() {

    draw_yinyang('prj-yinyang', gon.yinyang);

    this.redraw();

  };

  this.redraw = function() {

    new TableHandler([
      '#prjs-listing-wrp', '#deps-listing-wrp',
      '#branches-listing-wrp', '.builds-listing-wrp'
    ]);

  };

};

window.projects_show = new ProjectsShow()

resource_libs.register('projects_show', projects_show);
