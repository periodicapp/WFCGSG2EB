const num = 1234321

const palindrome = (x) => {
	let i=0
	let j=String(x).length-1
	let initReversed = ''
	while(i<j){
			if(String(x).charAt(i)!==String(x).charAt(j)){
					return false
			}else {
					i++
					j--
			}
	}
	return true
};

const palindromeNoStringify = (num) => { 
	const last = Math.floor(Math.log10(num))
	let pt1 = 0
	let pt2 = last
	const findDigit = (i) =>{
    return(Math.floor(num/Math.pow(10,last-i))%10)
	}	

	while(pt2>pt1){
		if(findDigit(pt1)!==findDigit(pt2)){
			return false
		}
		else{
			pt1++
			pt2--
		}
	}
	return (num>=0)
}

console.log(palindromeNoStringify(num),palindrome(num))
