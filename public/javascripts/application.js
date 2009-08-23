var tl;
var eventSource;

function onLoad(events) {
  eventSource = new Timeline.DefaultEventSource(); 
  var oldFillInfoBubble = 
    Timeline.DefaultEventSource.Event.prototype.fillInfoBubble;

  Timeline.DefaultEventSource.Event.prototype.fillInfoBubble = 
    function(elmt, theme, labeller) {
      oldFillInfoBubble.call(this, elmt, theme, labeller);

      var eventObject = this;
      var div = document.createElement("div");
      
      if (eventObject._obj.editable)
      {
        var editLink = '<a href="#" onclick="new Ajax.Request(\'/events/' + 
          eventObject.getID() + '/edit\', {asynchronous:true, ' +
          'evalScripts:true, method: \'get\'}); return false;">Edit</a>';
        var deleteLink = '<a href="#" onclick="if (' +
          'confirm(\'Are you sure?\')) {' +
          'new Ajax.Request(\'/events/' + eventObject.getID() + '\', ' +
          '{asynchronous:true, evalScripts:true, method: \'delete\'}); }; ' +
          'return false;">Delete</a>';
        div.innerHTML = editLink + " | " +deleteLink;
      }
      elmt.appendChild(div);
    }

  var bandInfos = [
    Timeline.createBandInfo({
        width:          "80%", 
        intervalUnit:   Timeline.DateTime.MONTH, 
        intervalPixels: 100,
        eventSource: eventSource,
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

function loadEvent(events) {
  if (eventSource)
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
