var twoSum = function(nums, target) {
    
    let answer;
    let map = {}
    for(let i=0;i<nums.length;i++){
        if((target-nums[i]) in map){
            answer = [i,map[(target-nums[i])]]
        }else{
            map[nums[i]]=i
        }
    }
    return answer
};
