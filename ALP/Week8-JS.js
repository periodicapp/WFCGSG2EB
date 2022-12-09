
// ******** Easy Problem ********
/**
 * @param {string[]} event1
 * @param {string[]} event2
 * @return {boolean}
 */
var haveConflict = function (event1, event2) {
    return event1[0] <= event2[1] && event2[0] <= event1[1];
};

// ******** Medium Problem I ********

var MyCalendar = function() {
    this.apmts = [];
};

/**
 * @param {string[]} event1
 * @param {string[]} event2
 * @return {boolean}
 */
MyCalendar.prototype.haveConflict = function (event1, event2) {
  return event1[0] < event2[1] && event2[0] < event1[1];
};

/** 
 * @param {number} start 
 * @param {number} end
 * @return {boolean}
 */
MyCalendar.prototype.book = function(start, end) { 
    for(const x of this.apmts){
        if (this.haveConflict([start, end], x)){
            return false;
        }
    }
    this.apmts.push([start, end]);
    return true;
};

/*
 * Your MyCalendar object will be instantiated and called as such:
 */
//  var obj = new MyCalendar();
//  var times = [[10, 20], [15, 25], [20, 30]];
//  results = []
//  for (const x of times) {
//    var param_1 = obj.book(x[0], x[1]);
//    results.push(param_1);
//  }


// ******** Medium Problem II ********

var MyCalendarTwo = function (){
    this.apmts = [];
};


/**
 * @param {int[]} event1
 * @param {int[]} event2
 * @return {boolean}
 */
MyCalendarTwo.prototype.haveConflict = function (event1, event2) {
  return event1[0] < event2[1] && event2[0] < event1[1];
};

/**
 * @param {number} start
 * @param {number} end
 * @return {boolean}
 */
MyCalendarTwo.prototype.book = function(start, end) { 
    for(var x = 0; x < this.apmts.length; x++){
        if (this.haveConflict([start, end], this.apmts[x])) {
          var possTrip = this.apmts[x];
          var listCop = [...this.apmts];
          listCop.splice(x, 1);
          for(const y of listCop){
            if(this.haveConflict(possTrip, y) && this.haveConflict([start, end], y)){
                return false;
            }
          }
        }
    }
    this.apmts.push([start, end]);
    return true;
};

/*
 * Your MyCalendar object will be instantiated and called as such:
 */
//  var obj = new MyCalendarTwo();
//  var times = [
//    [10, 20],
//    [50, 60],
//    [10, 40],
//    [5, 15],
//    [5, 10],
//    [25, 55],
//  ];
//  results = []
//  for (const x of times) {
//    var param_1 = obj.book(x[0], x[1]);
//    results.push(param_1);
//  }
//  console.log(results)
// ******** Hard Problem ********

var MyCalendarThree = function() {
    this.apmts = [];
    this.calConflicts = 0;
};

/**
 * @param {int[]} event1
 * @param {int[]} event2
 * @return {boolean}
 */
MyCalendarThree.prototype.haveConflict = function (event1, event2) {
  return event1[0] < event2[1] && event2[0] < event1[1];
};

/** 
 * @param {number} startTime 
 * @param {number} endTime
 * @return {number}
 */
MyCalendarThree.prototype.book = function (startTime, endTime) {
    console.log(startTime, endTime);
    this.apmts.push([startTime,endTime])
    var conflicts = [];
    for (const x of this.apmts) {
        if (this.haveConflict([startTime, endTime], x)) {
            conflicts.push(x);
        }
    } 
    for (var x = 0; x < conflicts.length; x++){
        rest = [...conflicts]
        rest.splice(x, 1)
        console.log('-----------', rest)
        for (var y = 0; y < rest.length; y++) {
          if (this.haveConflict(y, conflicts[x]) == false) {
            conflicts.splice(x, 1);
            x = x - 1;
            break;
          }
        }
    } 
    if(conflicts.length > this.calConflicts){
        this.calConflicts = conflicts.length
    }
    return this.calConflicts;
};

 var obj = new MyCalendarThree();
 var times = [
   [28, 46],
   [9, 21],
   [21, 39],
   [37, 48],
   [38, 50],
   [22, 39],
   [45, 50],
   [1, 12],
   [40, 50],
   [31, 44],
 ];
 results = []
 for (const x of times) {
   var param_1 = obj.book(x[0], x[1]);
   results.push(param_1);
 }
 console.log(results)