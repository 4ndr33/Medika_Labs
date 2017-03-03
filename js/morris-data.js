$(function() {

    /*
    Morris.Donut({
        element: 'morris-donut-chart',
        data: [{
            label: "Off-Peak Service",
            value: 12
        }, {
            label: "Priority Service",
            value: 20
        }],
		colors: ['#3399ff','#00cc99'],
        resize: true
    });
    
    
    Morris.Donut({
        element: 'morris-donut-chart2',
        data: [{
            label: "Venue 1",
            value: 12
        }, {
            label: "Venue 2",
            value: 30
        },{
            label: "Venue 3",
            value: 30
        },{
            label: "Venue 4",
            value: 30
        }, {
            label: "Venue 5",
            value: 20
        }],
		colors: ['#3399ff','#00cc99','#ac00e6','#d9d9d9','#ff6666'],
        resize: true
    });
    */
    Morris.Bar({
        element: 'morris-bar-chart',
        data: [{
            y: '2006',
            a: 100,
            b: 90
        }],
        xkey: 'y',
        ykeys: ['a', 'b'],
        labels: ['Series A', 'Series B'],
        barColors: ['#00cc99', '#00cc99'],
        horizontal: true,
        stacked: true
        /*
        hideHover: 'auto',
        resize: true
        */
    });

});
