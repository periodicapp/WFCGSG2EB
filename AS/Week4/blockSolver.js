/**
 * @param {number[][]} matrix
 * @return {boolean}
 */
 var checkValid = function(matrix) {
    /**
       1) Figure out what n is and store it somewhere
       2) make sure that every row contains 1, 2, ..., 1 - n, n
       3) make sure that every col contains 1, 2, ..., 1 - n, n
     */

     let n = matrix.length;

     for (let row = 0; row < matrix.length; row++) {
         let verificationSet = new Set()
         for (let col = 0; col < matrix[row].length; col++) {
           //   do you have this?
             if (!verificationSet.has(matrix[row][col])) { // No? Add it
                 verificationSet.add(matrix[row][col]);
             } else { //Yes? It's a dup so return
                 return false;
             }
         }
     }
   
       for (let row = 0; row < matrix.length; row++) {
         let verificationSet = new Set()
         for (let col = 0; col < matrix[row].length; col++) {
           //   do you have this?
             if (!verificationSet.has(matrix[col][row])) { // No? Add it
                 verificationSet.add(matrix[col][row]);
             } else { //Yes? It's a dup so return
                 return false;
             }
         }
     }
   return true
};

export {
  checkValid,
}
