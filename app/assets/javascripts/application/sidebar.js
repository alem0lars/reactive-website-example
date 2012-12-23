// Draw the builds_history for the project with id 'prj_id'
var draw_prj_builds_history = function($builds_history, data, prj_id) {

  return new Highcharts.Chart({
    chart: {
      renderTo: $builds_history.attr('id'),
      type: 'column',
      height: 260
    },
    title: {
      text: 'Builds History'
    },
    xAxis: {
      type: 'datetime',
      categories: Object.keys(data).map(function(date) {
        date = date.split('-');
        return Date.UTC(date[0], date[1], date[2]);
      }),
      labels: {
        formatter: function() {
          return Highcharts.dateFormat('%e %b %Y', new Date(this.value));
        }
      }
    },
    yAxis: {
      title: {
        text: 'N.Builds'
      }
    },
    plotOptions: {
      column: {
        stacking: 'normal'
      }
    },
    credits: { enabled: false },
    series: [
      {                                               // Fatal series
        data: Object.keys(data).map(function(date) {  //   <- Counts for each date
          return data[date].fatal;
        }),
        stack: 0,
        name: 'Fatal',
        color: '#aa4643'
      }, {                                            // Non-Fatal series
        data: Object.keys(data).map(function(date) {  //   <- Counts for each date
          return data[date].non_fatal;
        }),
        stack: 0,
        name: 'Non Fatal',
        color: '#aa9b42'
      }, {                                            // Succeeded series
        data: Object.keys(data).map(function(date) {  //   <- Counts for each date
          return data[date].succeeded;
        }),
        stack: 1,
        name: 'Succeeded',
        color: '#89a54e'
      }
    ]
  });

};

// Draw the builds_history for each project
var draw_prjs_builds_history = function() {
  var $sidebar_tile_builds_history = $('.sidebar-tile-builds-history'),
      $sidebar_tiles = $('#sidebar-tiles'),
      progress_bar = new ProgressBar(false),
      loaded_counter = 0;

  if ($sidebar_tile_builds_history.length > 0) {
    progress_bar.start($sidebar_tiles);
  }

  // Fetch the builds_history for each sidebar tile
  $sidebar_tile_builds_history.each(function(idx, builds_history) {
    var $builds_history = $(builds_history),
        prj_id = parseInt($builds_history.attr('data-id'), 10);
    $.ajax({
      url: '/projects/{1}'.assign(prj_id),
      dataType: 'json',
      data: { selector: 'builds_history' },
      success: function(data) {                                     // On Success
        draw_prj_builds_history($builds_history, data, prj_id);
      },
      error: function(xhr, txt_status, err_thrown) {                // On Error
        var msg = '{1}: {2}'.assign(txt_status, err_thrown);
        console.log('Error! {1}'.assign(msg));
        new Flash('error', err_thrown);
      },
      complete: function() {                                        // On Complete
        loaded_counter += 1;
        if (Object.equal(loaded_counter, $sidebar_tile_builds_history.length)) {
          progress_bar.finish();
        }
      }
    });
  });

};

$(document).ready(function() {
  var $sidebar_search_input = $('#sidebar-search-input'),
      $sidebar_search_reset = $('#sidebar-search-reset'),
      $sidebar_tiles = $('#sidebar-tiles');

  // Draw the builds history for the initial sidebar tiles
  draw_prjs_builds_history();

  // Handle search response
  $sidebar_search_input.typeWatch({
    callback: function() {
      return $.get('/sidebar_tiles',
      { // Data
        query: $sidebar_search_input.val()
      }, function(data) { // On Success
        $sidebar_tiles.html(data);
        // # Draw the builds history for the fetched sidebar tiles
        return draw_prjs_builds_history();
      });
    },
    wait: 750,
    highlight: true,
    captureLength: 0
  });

  // Handle the reset button
  $sidebar_search_reset.click(function(e) {
    e.preventDefault();
    $sidebar_search_input.val('');
    $sidebar_search_input.keydown();
  });

  // Handle pagination response
  return $('#sidebar-tiles .pagination a').live('ajax:success', function(type, data) {
    $sidebar_tiles.html(data);
    draw_prjs_builds_history();
  });

});
