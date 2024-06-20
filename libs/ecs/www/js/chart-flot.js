"use strict";
$(document).ready(function() {

    //real-time update
    $(function() {
        // We use an inline data source in the example, usually data would
        // be fetched from a server
        var data = [];

        function getRealtimeData() {

            updateData( "/data/defold/metrics",function(metrics) {

                data = metrics.metrics.deltas;
            });

            // Zip the generated y values with the x values
            var res = [];
            for (var i = 0; i < data.length; ++i) {
                res.push([i, data[i]])
            }
            return res;
        }

        // Set up the control widget
        var updateInterval =  500;
        var plot = $.plot("#realtimeupdate", [getRealtimeData()], {
            lines: {
                show: true,
                fill: 0.5,
                lineWidth:1
            },
            grid: { 
                borderColor: "#aaa"
            },
            series: {
                shadowSize: 0 // Drawing is faster without shadows
            },
            yaxis: {
                min: 0,
                max: 0.1,
            },
            xaxis: {
                show: false,
            }
        });

        function update() {
            plot.setData([getRealtimeData()]);
            // Since the axes don't change, we don't need to call plot.setupGrid()
            plot.draw();
            setTimeout(update, updateInterval);
        }

        update();
        // Add the Flot version string to the footer
        $("#footer").prepend("Flot " + $.plot.version + " &ndash; ");
    });


    //real-time memory use
    $(function() {
        // We use an inline data source in the example, usually data would
        // be fetched from a server
        var memdata = new Array(60);

        function getRealtimeData() {

            updateData( "/data/defold/metrics",function(metrics) {

                memdata.push(metrics.metrics.mem);
                if(memdata.length > 60) memdata.shift();
            });

            // Zip the generated y values with the x values
            var res = [];
            for (var i = 0; i < memdata.length; ++i) {
                res.push([i, memdata[i]])
            }
            return res;
        }

        // Set up the control widget
        var updateInterval =  3000;
        var plot = $.plot("#memoryuse", [getRealtimeData()], {
            lines: {
                show: true,
                fill: 0.5,
                lineWidth:1
            },
            grid: { 
                borderColor: "#aaa"
            },
            series: {
                shadowSize: 0, // Drawing is faster without shadows
                color: "#272"
            },
            yaxis: {
                min: 0,
                max: 1200,
            },
            xaxis: {
                show: false,
            }
        });

        function update() {
            plot.setData([getRealtimeData()]);
            // Since the axes don't change, we don't need to call plot.setupGrid()
            plot.draw();
            setTimeout(update, updateInterval);
        }

        update();
        // Add the Flot version string to the footer
        $("#footer").prepend("Flot " + $.plot.version + " &ndash; ");
    });
});