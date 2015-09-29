function(){
  var div = d3.select(this);
  div.selectAll('path').style({'stroke-opacity': 0, 'stroke': '#f00', 'stroke-width': 0});
  
  var _this = this;
  s(_this).find('g path').popover({
    trigger: 'hover focus',
    content: 'Loading',
    html: true,
    container: 'body',
    placement: 'bottom',
    animation: false
  });
  
}