const matrix = [[1,2,1],[3,1,2],[2,3,1]]
const matrix_1 = [[1,2,3],[3,1,2],[2,3,1]]

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


var checkValid_1 = function(matrix) {
    var bool= true
    for(let i=1;i<=matrix.length;i++){
        var row = []
				var col = []
        for(let j=1;j<=matrix.length;j++){
            if(row.includes(matrix[i-1][j-1]) || col.includes(matrix[j-1][i-1])){
                bool = false
                break
            }else{
                row.push(matrix[i-1][j-1])
								col.push(matrix[j-1][i-1])
            }
        }
    }
    
    return bool
}


console.log(checkValid_1(matrix))
console.log(checkValid_1(matrix_1))
