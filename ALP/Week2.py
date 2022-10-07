import time


class Solution:
    # Brute Force
    def longestPalindromeBrute(self, s: str) -> str:
        strList = list(s)
        longestPalindrome = []
        # Finds every possible Palindrome and compares to the current longest palindrome
        for x in range(len(strList)):
            currPal = []
            revPal = []
            next = x
            # Here is the downside of the method: It checks the rest of the string starting at every index, and everytime, 
            # it checks if the current possible palindrome is indeed a palindrome and if it is longer than the current longest
            # aba: [a], [ab], [aba];  [b], [ba];  [a]; [aba] > [ba] > [a]
            while next < len(strList):
                currPal.append(strList[next])
                revPal.insert(0, strList[next])
                if revPal == currPal:
                    if len(longestPalindrome) < len(currPal):
                        longestPalindrome = currPal.copy()
                next += 1
        return ''.join(longestPalindrome)
    
    # Modifed Solution from LeetCode's Solution #4: Java -> Python
    def longestPalindrome(self, s: str) -> str:
        # Finds the center of the first palindrome
        def expandCenter(s: str, left: int, right: int) -> int:
            while(left >= 0 and right < len(s) and s[left] == s[right]):
                left -= 1
                right += 1
            # Length of palindrome
            return right - left - 1
        
        # Indexes of longest Palindrome
        start, end = 0,0
        for i in range(len(s)):
            # For every index, look for a palindrome of odd length: Base case is 1
            len1 = expandCenter(s, i, i)
            # Palindrome of even length: Base Case is 2
            len2 = expandCenter(s, i, i+1)
            # Is the odd length palindrome longer than the even length palindrome 
            if len1 > len2:
                leng = len1
            else:
                leng = len2
            # Is the current palindrome longer than the previous longest
            if leng > end - start:
                # aba at b: 1 - (1 - 1) // 2 = 0 
                start = i - (leng - 1) // 2
                # aba at b: 1 + 1 // 2 = 1
                end = i + leng // 2
        # aba: start = 0, end = 1, s[0, 1 + 1 (2)] = 2 = "aba"
        return s[start:end+1]
    
    
        
    
a = Solution()
print(a.longestPalindromeBrute("a"))
print(a.longestPalindromeBrute("ab"))
print(a.longestPalindromeBrute("aa"))
print(a.longestPalindromeBrute("aab"))
print(a.longestPalindromeBrute("aba"))
print(a.longestPalindromeBrute("baa"))
print(a.longestPalindromeBrute("abc"))
print(a.longestPalindromeBrute("aacadkbacaa"))
print(a.longestPalindromeBrute("aabdhudehewopdk"))
print(a.longestPalindromeBrute("dhwpkwqjaahuwehiewklwq"))
test = ''.join(['o' for x in range(1700)])
#print(a.longestPalindromeBrute(test))
print(a.longestPalindrome(test))
start_time = time.time()
print(a.longestPalindrome("fmitmmdqnpqqjjljpdplsemrvswqkaibctnvwcznilnfxaabwqdcuocuqespfmvkpalxfffozbjgfooeotuwxyutfetcixrqjswbfmadsrxpgpgwslspujoxaaoqfhdopgbtceaqysgwafsgrktsdimbbetnficmsvbmbcdisrajkzduyakjeehaeqsnjgzwfekezulzzluzekefwzgjnsqeaheejkayudzkjarsidcbmbvsmcifntebbmidstkrgsfawgsyqaectbgpodhfqoaaxojupslswgpgpxrsdamfbwsjqrxicteftuyxwutoeoofgjbzofffxlapkvmfpsequcoucdqwbaaxfnlinzcwvntcbiakqwsvrmeslpdpjljjqqpnqdmmtimffmitmmdqnpqqjjljpdplsemrvswqkaibctnvwcznilnfxaabwqdcuocuqespfmvkpalxfffozbjgfooeotuwxyutfetcixrqjswbfmadsrxpgpgwslspujoxaaoqfhdopgbtceaqysgwafsgrktsdimbbetnficmsvbmbcdisrajkzduyakjeehaeqsnjgzwfekezulzzluzekefwzgjnsqeaheejkayudzkjarsidcbmbvsmcifntebbmidstkrgsfawgsyqaectbgpodhfqoaaxojupslswgpgpxrsdamfbwsjqrxicteftuyxwutoeoofgjbzofffxlapkvmfpsequcoucdqwbaaxfnlinzcwvntcbiakqwsvrmeslpdpjljjqqpnqdmmtimfpadding"))
print("--- %s seconds ---" % (time.time() - start_time))