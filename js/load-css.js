(function(window) {
  "use strict";
  var loadCSS = function(href) {
    var doc = window.document,
        link = doc.createElement("link"),
        headNodes = doc.getElementsByTagName("head")[0].childNodes,
        lastHeadNode = headNodes[headNodes.length - 1],
        raf = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
          window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;

    raf(function() {
      link.rel = "stylesheet";
      link.href = href;
      link.media = "all";
      lastHeadNode.parentNode.insertBefore(link, lastHeadNode);
    });
  };

  loadCSS("/css/theinternate.css");
  loadCSS("/css/hack.css");
})(window);
