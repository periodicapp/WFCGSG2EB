
var maxProfit = function(prices) {
  var profit = 0
  var direction = 0
  var holding = false
  for(let i=0;i<prices.length-1;i++){
    const new_direction = (prices[i+1]-prices[i])/Math.abs(prices[i+1]-prices[i])
    console.log(i==prices.length-1 && holding)
    if(new_direction !== direction){
      console.log("new direction")
      direction = new_direction            
      if(direction < 0 && holding){
        //sell
        profit += prices[i]
        holding = false
        console.log("Sold on day " + String(i+1)+" profit: " + String(profit))
      }
      else if(direction > 0 && !holding){
        //buy               
        profit -= prices[i]
        holding = true
        console.log("Bought on day " + String(i+1)+" profit: " + String(profit))
      }
    }
  }
  if(holding){
    console.log("henlo")
    profit += prices[prices.length-1]
    console.log("Sold on day " + String(prices.length)+" profit: " + String(profit))
  }
  
  return profit
}   

console.log(maxProfit([1,2,3,4,5]))