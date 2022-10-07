const matrix = [[1,2,3],[3,1,2],[2,3,1]]

var checkValid = function(matrix) {
    var bool= true
    for(let i=1;i<=matrix.length;i++){
        var arr = []
        for(let j=1;j<=matrix.length;j++){
            if(arr.includes(matrix[i-1][j-1])){
                bool = false
                break
            }else{
                arr.push(matrix[i-1][j-1])
            }
        }
    }
    
    for(let i=1;i<=matrix.length;i++){
        var arr = []
        for(let j=1;j<=matrix.length;j++){
            if(arr.includes(matrix[j-1][i-1])){
                bool = false
                break
            }else{
                arr.push(matrix[j-1][i-1])
            }
        }
    }
    return bool
};

console.log(checkValid(matrix))
