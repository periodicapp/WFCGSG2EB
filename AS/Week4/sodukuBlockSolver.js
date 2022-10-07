// 9 x 9 Grid
// Each 3 x 3 grid must contain the numbers 1 - 9 not repeating
// Each row of the grid must contain 1 - 9 not repeating
// Each col of the grid must contain 1 - 9 not repeating


// This could be done dynamically by storing the places you have been so far, making it a lot faster for solving parts of it
// need to know what numbers are in the other column

// could make grids into map of sets

// could convert a row/col into a set and check the length of the set to verify that it contains every digit


let myMatrix = [
    ["5","3",".",".","7",".",".",".","."],
    ["6",".",".","1","9","5",".",".","."],
    [".","9","8",".",".",".",".","6","."],
    ["8",".",".",".","6",".",".",".","3"],
    ["4",".",".","8",".","3",".",".","1"],
    ["7",".",".",".","2",".",".",".","6"],
    [".","6",".",".",".",".","2","8","."],
    [".",".",".","4","1","9",".",".","5"],
    [".",".",".",".","8",".",".","7","9"]
]

let myMatrix2 = [
    ["8","3",".",".","7",".",".",".","."],
    ["6",".",".","1","9","5",".",".","."],
    [".","9","8",".",".",".",".","6","."],
    ["8",".",".",".","6",".",".",".","3"],
    ["4",".",".","8",".","3",".",".","1"],
    ["7",".",".",".","2",".",".",".","6"],
    [".","6",".",".",".",".","2","8","."],
    [".",".",".","4","1","9",".",".","5"],
    [".",".",".",".","8",".",".","7","9"]
]

let myMatrix3 = [
    [".",".","4",".",".",".","6","3","."],
    [".",".",".",".",".",".",".",".","."],
    ["5",".",".",".",".",".",".","9","."],
    
    [".",".",".","5","6",".",".",".","."],
    ["4",".","3",".",".",".",".",".","1"],
    [".",".",".","7",".",".",".",".","."],
    
    [".",".",".","5",".",".",".",".","."],
    [".",".",".",".",".",".",".",".","."],
    [".",".",".",".",".",".",".",".","."]
]

let myMatrix4 = [
    ["7",".",".",".","4",".",".",".","."],
    [".",".",".","8","6","5",".",".","."],
    [".","1",".","2",".",".",".",".","."],

    [".",".",".",".",".","9",".",".","."],
    [".",".",".",".","5",".","5",".","."],
    [".",".",".",".",".",".",".",".","."],

    [".",".",".",".",".",".","2",".","."],
    [".",".",".",".",".",".",".",".","."],
    [".",".",".",".",".",".",".",".","."]]

// search a grid
// let isValidSudoku = (matrix) => {
//     // one loop to iterate xtl 
//     //   one loop to iterate over ytl
//     //     one loop to figure out rows
//     //     one loop to figure out cols

//     for (let y = 0; y < matrix.length; y += 3) {
//         for (let x = 0; x < matrix[y].length; x += 3) {;
//             let subMatrix = [];
//             subMatrix.push(matrix[y + 0].slice(x, x + 3))
//             subMatrix.push(matrix[y + 1].slice(x, x + 3))
//             subMatrix.push(matrix[y + 2].slice(x, x + 3))
//             for (let iter = 0; iter < subMatrix.length; iter++) {
//                 let rowRetVal = searchRow(subMatrix[iter])
//                 let colRetVal = searchCol(subMatrix, iter)
//                 let diagRetVal = searchDiag(subMatrix)
//                 if (!rowRetVal || !colRetVal || !diagRetVal) {
//                     return false
//                 }
//             }
//             let colRetVal = searchCol(matrix, x)
//             if (!colRetVal) {
//                 return false
//             }
//             // console.log(subMatrix)
//         }
//         let rowRetVal = searchRow(matrix[y])
//         if (!rowRetVal) return false
//     }
//     return true
// }



// //search a column
// let searchRow = (row) => {
//     let found = new Set()
//     for (let piece of row) {
//         // If I haven't found the piece yet and it isn't a .
//         if (piece !== "." && !found.has(piece)) {
//             found.add(piece)
//         } else if (found.has(piece)) {
//             return false
//         }
//     }
//     return true
// }

// // search a row
// let searchCol = (matrix, x) => {
//     let found = new Set();
//     for (let y = 0; y < matrix[x].length; y++) {
//         let piece = matrix[y][x];
//         if (piece !== "." && !found.has(piece)) {
//             found.add(piece)
//         } else if (found.has(piece)) {
//             return false
//         }
//     }
//     return true
// }

// let searchDiag = (matrix) => {
//     let found = new Set()
//     for (let y = 0, x = 0; y < matrix.length && x < matrix[y].length; x++, y++) {
//         let piece = matrix[y][x];
//         if (piece !== "." && !found.has(piece)) {
//             found.add(piece)
//         } else if (found.has(piece)) {
//             return false
//         }
//     }

//     found.clear()
//     for (let y = 0, x = matrix[y].length - 1; y < matrix.length && x >= 0; y++, x--){
//         let piece = matrix[y][x];
//         if (piece !== "." && !found.has(piece)) {
//             found.add(piece)
//         } else if (found.has(piece)) {
//             return false
//         }
//     }
//     return true
// }

const getBox = (row, col) => {
    if (row >= 0 && row <= 2) {
        if (col >= 0 && col <= 2) {
            return 0;
        } else if (col >= 3 && col <= 5) {
            return 1;
        } 
        return 2;
    } else if (row >= 3 && row <= 5) {
        if (col >= 0 && col <= 2) {
            return 3;
        } else if (col >= 3 && col <= 5) {
            return 4;
        } 
        return 5;
    }
    
    if (col >= 0 && col <= 2) {
        return 6;
    } else if (col >= 3 && col <= 5) {
        return 7;
    } 
    return 8;
}

var isValidSudoku = function(board) {
    const rows = [{},{},{},{},{},{},{},{},{}];
    const cols = [{},{},{},{},{},{},{},{},{}];
    const boxes =  [{},{},{},{},{},{},{},{},{}];
    
    for (let r = 0; r <= 8; r ++) {
        for (let c = 0; c <= 8; c ++) {
            let val = board[r][c];
            
            if (val === ".") continue;
			
			let box = getBox(r, c);

			if (rows[r][val] || cols[c][val] || boxes[box][val]) return false;

			rows[r][val] = cols[c][val] = boxes[box][val] = true;
        }
    }
}
// console.log(isValidSudoku(myMatrix)); // Should be true
// console.log(isValidSudoku(myMatrix2)); // Should be false
// console.log(isValidSudoku(myMatrix3)) //should be false
console.log(isValidSudoku(myMatrix4)) //should be false
// console.log(searchRow(myMatrix));
// console.log(searchCol(myMatrix));
