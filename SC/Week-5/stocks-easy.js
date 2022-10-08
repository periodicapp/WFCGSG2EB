var maxProfit = function(prices) {
    var diff = 0
    var min = prices[0]

		//     for(let i=0;i<prices.length;i++){
		//         for(let j=i+1;j<prices.length;j++){
		//             const new_diff = prices[j]-prices[i]
		//             diff = new_diff>diff ? new_diff : diff
		//         }    
		//     }
    
    for(let i=0;i<prices.length;i++){
        if(prices[i]<min){
            min = prices[i]
        }
        if(prices[i]>min){
            const max = prices[i]            
            diff = max-min>diff ? max-min : diff
        }
    }
    
    return diff
};
