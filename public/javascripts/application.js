var tl;
var eventSource;

function loadEventsForUser(user_id) {
  eventSource = new Timeline.DefaultEventSource(); 
  var oldFillInfoBubble = 
    Timeline.DefaultEventSource.Event.prototype.fillInfoBubble;

  Timeline.DefaultEventSource.Event.prototype.fillInfoBubble = customBubble;

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
  url = "http://localhost:3000/users/" + user_id + ".json";
  Timeline.loadJSON(url, function(data, url) {
   eventSource.clear();
   eventSource.loadJSON(data, url); 
  });
}

function loadEvent(data) {
  if (eventSource)
    eventSource.loadJSON(data, "");
}

var resizeTimerID = null;
function onResize() {
    if (resizeTimerID == null) {
        resizeTimerID = window.setTimeout(function() {
            resizeTimerID = null;
//            tl.layout();
        }, 500);
    }
}

function panToDate(panDate) {
    tl.getBand(0).setCenterVisibleDate(Timeline.DateTime.parseGregorianDateTime(panDate)); 
}

var customBubble =  function(elmt, theme, labeller) {
        var doc = elmt.ownerDocument;
        
        var title = this.getText();
        var link = this.getLink();
        var image = this.getImage();
        
        if (image != null) {
            var img = doc.createElement("img");
            img.src = image;
            
            theme.event.bubble.imageStyler(img);
            elmt.appendChild(img);
        }
        
        var divTitle = doc.createElement("div");
        var textTitle = doc.createTextNode(title);
        if (link != null) {
            var a = doc.createElement("a");
            a.href = link;
            a.appendChild(textTitle);
            divTitle.appendChild(a);
        } else {
            divTitle.appendChild(textTitle);
        }
        theme.event.bubble.titleStyler(divTitle);
        elmt.appendChild(divTitle);
        
        var divBody = doc.createElement("div");
        this.fillDescription(divBody);
        theme.event.bubble.bodyStyler(divBody);
        elmt.appendChild(divBody);
        
        var divTime = doc.createElement("div");
        this.fillTime(divTime, labeller);
        theme.event.bubble.timeStyler(divTime);
        elmt.appendChild(divTime);
        
        var divWiki = doc.createElement("div");
        this.fillWikiInfo(divWiki);
        theme.event.bubble.wikiStyler(divWiki);
        elmt.appendChild(divWiki);

      var div = document.createElement("div");
      var eventObject = this;
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
