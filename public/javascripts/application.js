var tl;
function onLoad(events) {
  /*var events = {
        'dateTimeFormat': 'iso8601',
        'events': [
          {
             'start': 'Sat Aug 22 05:44:47 UTC 2009',
             'end'  : 'Sat Aug 24 05:44:47 UTC 2009',
             'title': 'Manual event',
             'description': 'Some words'
          }
        ]
      };*/
  
  alert(events);
  var eventSource = new Timeline.DefaultEventSource(); 
  var theme = Timeline.ClassicTheme.create();
  theme.event.label.width = 250;
  theme.event.bubble.width=320;
  theme.event.bubble.height=220;

  var bandInfos = [
    Timeline.createBandInfo({
        width:          "80%", 
        intervalUnit:   Timeline.DateTime.MONTH, 
        intervalPixels: 100,
        eventSource: eventSource,
        theme:theme
    }),
    Timeline.createBandInfo({
        width:          "20%", 
        intervalUnit:   Timeline.DateTime.YEAR, 
        intervalPixels: 200
    })
  ];
  bandInfos[1].syncWith = 0;
  bandInfos[1].highlight = true;
  tl = Timeline.create(document.getElementById("lifeline"), bandInfos);
  eventSource.loadJSON(events, "");
}

var resizeTimerID = null;
function onResize() {
    if (resizeTimerID == null) {
        resizeTimerID = window.setTimeout(function() {
            resizeTimerID = null;
            tl.layout();
        }, 500);
    }
}
