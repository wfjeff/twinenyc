function UserShowTempChartXAxisGroup(svgObj, optionsObj) {
  this.data = svgObj.data;
  this.svg = svgObj.svg;
  this.margin = optionsObj.margin;
  this.x = svgObj.x;
  this.startDate = svgObj.startDate;
  this.endDate = svgObj.endDate;
  this.height = optionsObj.height;
  this.xAxis = this.setXAxis();
  this.strokeWidth = svgObj.width / 168;
}

UserShowTempChartXAxisGroup.prototype.setXAxis = function(){
  return d3.svg.axis().scale(this.x)
    .tickSize(this.height - this.margin * 2)
    .tickPadding(0)
    .ticks(moment.duration(1, 'week').asHours());
};

UserShowTempChartXAxisGroup.prototype.addLineStylingToXTicks = function(){
  var $lines = $(".xTick .tick line"),
      date,
      $textEl;
  $($lines[0]).attr({ 'stroke-width': this.strokeWidth * 1.9 });

  for(var i = 1; i <= 168; i++){
    date = moment(this.startDate).add(i, 'hours');
    if(date.hours() < 7 || date.hours() > 21){
      $($lines[i]).attr(
        { 'stroke-width': this.strokeWidth, 'stroke': '#90ABB0' }
      );
    }
    else {
      // add dates to bottom of graph
      if (date.hours() === 16) {
        $textEl = $($(".xTick .tick text")[i]);
        $textEl.text(date.format("MMM D, YYYY"));
        $textEl.show();
        $textEl.attr({"x": -15, "y": 380});
      }
    }
  }
};

UserShowTempChartXAxisGroup.prototype.drawXAxisGroup = function(){
  this.svg.append('svg:g').attr('class', 'xTick').call(this.xAxis);
};

UserShowTempChartXAxisGroup.prototype.addToChart = function() {
  this.drawXAxisGroup();
  this.addLineStylingToXTicks();
};
