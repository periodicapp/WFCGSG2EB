// Brute Foce
// let isPalindrome = function(x) {
//     if (x < 0) return false
//     let finalNum = 0;
//     let copyOfX = x
//     while (x > 0) {
//         let lastNumber = x % 10;
//         finalNum *= 10;
//         finalNum += lastNumber
//         x = Math.floor(x / 10)
//     }
//     return copyOfX === finalNum
// //     12312 21321
// };
// Optimized
let isPalindrome = function(x) {
    if (x < 0) return false
    let finalNum = 0;
    let copyOfX = x
    while (x > finalNum) {
        let lastNumber = x % 10;
        finalNum = finalNum * 10;
        finalNum += lastNumber
        x = Math.floor(x / 10)
    }
    return x === finalNum
//     12312 21321
};
console.log(isPalindrome(123456787654321));
console.log(isPalindrome(10))
