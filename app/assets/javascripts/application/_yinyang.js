(function() {
  if (requires_register.has('yinyang')) {
    return;
  } else {
    requires_register.add('yinyang');
  }
  window.draw_yinyang = function(container_id, data) {
    return new Highcharts.Chart({
      chart: {
        renderTo: container_id,
        backgroundColor: null,
        plotShadow: false
      },
      title: 'Failures VS Successes',
      credits: {
        enabled: false
      },
      tooltip: {
        formatter: function() {
          return "<strong>" + (this.point.name.titleize()) + "</strong>: " + this.percentage + "%";
        }
      },
      plotOptions: {
        pie: {
          borderColor: '#000000',
          borderWidth: 1,
          dataLabels: {
            color: '#000000',
            connectorColor: '#000000',
            enabled: true,
            formatter: function() {
              return "<strong>" + (this.point.name.titleize()) + "</strong>: " + this.percentage + "%";
            }
          }
        }
      },
      series: [
        {
          type: 'pie',
          name: 'Quantity',
          data: [
            {
              name: 'Yang',
              y: data.yang,
              color: '#f4f4f4'
            }, {
              name: 'Yin',
              y: data.yin,
              color: '#2d2d2d'
            }
          ]
        }
      ]
    });
  };
}).call(this);
