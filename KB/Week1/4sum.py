from itertools import combinations
nums = [1,0,-1,0,-2,2]
combolist = [list(comb) for comb in combinations(nums, 4)]
finallist = []
for x in combolist:
   result = x[0] +x[1] + x[2] + x[3]
   if result == 0:
    finallist.append(x)
    
unique_data = [list(x) for x in set(tuple(x) for x in finallist)]
print(unique_data)
