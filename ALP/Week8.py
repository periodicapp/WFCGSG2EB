from typing import List
import time
class Solution:
    def haveConflict(self, event1: List[str], event2: List[str]) -> bool:
        return event1[0] <= event2[1] and event2[0] <= event1[1]
    
class MyCalendar:
    def __init__(self):
        self.apmts = []

    def haveConflict(self, event1: List[int], event2: List[int]) -> bool:
        return event1[0] < event2[1] and event2[0] < event1[1]
    
    def book(self, start: int, end: int) -> bool:
        for x in self.apmts:
            if self.haveConflict([start,end], x):
                return False
        else:
            self.apmts.append([start,end])
            return True

class MyCalendarTwo:

    def __init__(self):
        self.apmts = []

    def haveConflict(self, event1: List[int], event2: List[int]) -> bool:
        return event1[0] < event2[1] and event2[0] < event1[1]
    
    def book(self, start: int, end: int) -> bool:
        apmts = self.apmts.copy()
        apmts.append([start,end])
        apmts.sort()
        print(apmts)
        if len(apmts) >= 3:
            for x in range(1,len(apmts)-1):
                print([apmts[x-1], apmts[x], apmts[x+1]])
                if self.haveConflict(apmts[x-1], apmts[x]) and self.haveConflict(apmts[x], apmts[x+1]) and self.haveConflict(apmts[x-1], apmts[x+1]):
                    return False
        self.apmts = apmts
        return True

# Your MyCalendar object will be instantiated and called as such:
obj = MyCalendar()
# param_1 = obj.book(start,end)


a = Solution()
event1 = ["01:15","02:00"]
event2 = ["02:00","03:00"]
event1 = ["10:00","11:00"]
event2 = ["14:00","15:00"]
event1 = ["16:53","19:00"]
event2 = ["10:33","18:15"]

# print(a.haveConflict(event1, event2))
myCalendar = MyCalendar()
# print(myCalendar.book(10, 20))
# print(myCalendar.book(15, 25))
# print(myCalendar.book(20, 30))
# print(myCalendar.book(5, 10))

myCalendarTwo = MyCalendarTwo();
print(myCalendarTwo.book(10, 20))
print(myCalendarTwo.book(50, 60))
print(myCalendarTwo.book(10, 40))
print(myCalendarTwo.book(5, 15))
print(myCalendarTwo.book(5, 10))
print(myCalendarTwo.book(25, 55))
myCalendarTwo = MyCalendarTwo()
list = [[33,44],[85,95],[20,37],[91,100],[89,100],[77,87],
        [80,95],[42,61],[40,50],[85,99],[74,91],[70,82],[5,17],
        [77,89],[16,26],[21,31],[30,43],[96,100],[27,39],[44,55],
        [15,34],[85,99],[74,93],[84,94],[82,94],[46,65],[31,49],
        [58,73],[86,99],[73,84],[68,80],[5,18],[75,87],[88,100],
        [25,41],[66,79],[28,41],[60,70],[62,73],[16,33]]
for x in list:
    print(myCalendarTwo.book(x[0],x[1]))