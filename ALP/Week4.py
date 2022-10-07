from typing import Dict, List, Tuple
class Solution:
    def solveSudoku(self, board: List[List[str]]) -> None:
        # Finds every number that cannot be used at each specific square in the graph
        # Returns a dictionary of every empty space in each row (Vertexes), and a tuple of the numbers that cannot be used at that point (Colors), 
        # and indexes of other empty spaces that will be affected by this point (Edges)
        # Finds every number that cannot be used at each specific square in the graph
        # Returns a dictionary of every empty space in each row (Vertexes), and a tuple of the numbers that cannot be used at that point (Colors), 
        # and indexes of other empty spaces that will be affected by this point (Edges)
        def buildInterferenceDict(board: List[List[str]]):
            interference = {}
            for x in range(0, 9):
                for y in range(0, 9):
                    if board[x][y] == '.':
                        interference[(x,y)] = (set(), [])
                        # Row from y - end
                        for r in range(y+1, 9):
                            if board[x][r] != '.':
                                interference[(x,y)][0].add(board[x][r])
                            else:
                                interference[(x,y)][1].append((x, r))
                        # Row from beginning to y
                        for r in range(0, y):
                            if board[x][r] != '.':
                                interference[(x,y)][0].add(board[x][r])
                            else:
                                interference[(x,y)][1].append((x, r))
                        # Column from x to 9
                        for r in range(x+1, 9):
                            if board[r][y] != '.':
                                interference[(x,y)][0].add(board[r][y])
                            else:
                                interference[(x,y)][1].append((r, y))
                        # Column from beginning to x
                        for r in range(0, x):
                            if board[r][y] != '.':
                                interference[(x,y)][0].add(board[r][y])
                            else:
                                interference[(x,y)][1].append((r, y))
            # Interference in each square
            startRow = 0
            while startRow < 9:
                currRow = [*range(startRow, startRow + 3)]
                startCol = 0
                while startCol < 9:
                    currCol = [*range(startCol, startCol + 3)]
                    sq = []
                    emptSp = []
                    for x in currRow:
                        for y in currCol:
                            if board[x][y] != '.':
                                sq.append(board[x][y])
                            else:
                                emptSp.append((x, y))
                    for x in currRow:
                        for y in currCol:
                            if board[x][y] == '.':
                                for z in sq:
                                    interference[(x,y)][0].add(z)
                                for z in emptSp:
                                    if z not in interference[(x,y)][1]:
                                        interference[(x,y)][1].append(z)
                    startCol += 3
                startRow += 3
            return interference
        def fillBoard(board: List[List[str]], interferance):
            if len(interferance.keys()) > 0:
                mostSat = 0
                mostSatVert = ()
                for x in interferance:
                        if len(interferance[x][0]) >= mostSat:
                            mostSat = len(interferance[x][0])
                            mostSatVert = x
                poss = [*range(1, 10)]
                for x in interferance[mostSatVert][0]:
                    if int(x) in poss:
                        poss.remove(int(x))
                mostInstances = 0
                count = -1
                for x in poss:
                    currCount = 0
                    for y in interferance:
                        if str(x) in interferance[y][0]:
                            currCount += 1
                    if currCount > count:
                        mostInstances = x
                        count = currCount
                board[mostSatVert[0]][mostSatVert[1]] = str(mostInstances)
                for x in interferance[mostSatVert][1]:
                    if x in interferance.keys():
                        interferance[x][0].add(str(mostInstances))
                del interferance[mostSatVert]
                fillBoard(board, interferance)
        interferance = buildInterferenceDict(board)
        # for x in interferance:
        #     print(f"{x}: {interferance[x]}")
        fillBoard(board, interferance)
        for x in range(0, 9):
            print()
            for y in range(0,9):
                print(board[x][y], end=', ')
 
 
    # Medium LeetCode Problem
    def isValidSudoku(self, board: List[List[str]]) -> bool:
        for x in range(0, 9):
            validR = [*range(1, 10)]
            validC = [*range(1, 10)]
            for y in range(0, 9):
                if board[x][y] != '.':
                    if int(board[x][y]) in validR:
                        validR.remove(int(board[x][y]))
                    elif int(board[x][y]) not in validR:
                        return False
                if board[y][x] != '.':
                    if int(board[y][x]) in validC:
                        validC.remove(int(board[y][x]))
                    elif int(board[y][x]) not in validC:
                        return False
        startRow = 0
        while startRow < 9:
            currRow = [*range(startRow, startRow + 3)]
            startCol = 0
            while startCol < 9:
                currCol = [*range(startCol, startCol + 3)]
                validSquare = [*range(1, 10)] 
                for x in currRow:
                    for y in currCol:
                        if board[x][y] != '.':
                            if int(board[x][y]) in validSquare:
                                validSquare.remove(int(board[x][y]))
                            else:
                                return False
                startCol += 3
            startRow += 3
        return True
              
    # Easy LeetCode Problem
    # This solution was before I saw the constraint: 1 <= matrix[i][j] <= n
    def checkValid(self, matrix: List[List[int]]) -> bool:
        # Building valid range
        n = len(matrix[0])
        for x in range(len(matrix)):
            # Valid Rows and Columns must contain each element from the following arrays and nothing more
            validRow = [*range(1, n+1)]
            validCol = [*range(1, n+1)]
            for y in range(len(matrix[x])): 
                # Row Traversal
                if matrix[x][y] in validRow:
                    validRow.remove(matrix[x][y])
                else:
                    return False
                # Column Traversal
                if matrix[y][x] in validCol:
                    validCol.remove(matrix[y][x])
                else:
                    return False
        return True
    
    # Constraint: 1 <= matrix[i][j] <= n
    def checkValidZip(self, matrix: List[List[int]]) -> bool:
        # Sets are arrays of unique elements only
        # Check if the rows as sets are the same length
        for item in matrix:
            # If they are not the same, an element was duplicated, so we know that row was incorrect
            if(len(item) != len(set(item))):
                return False
        # Zip creates arrays from columns in a 2-D Array
        for i in zip(*matrix):
            # Check if the rows(ex-columns) as sets are the same length
            # If they are not the same, an element was duplicated, so we know that row was incorrect
            if(len(i)!= len(set(i))):
                return False
        return True
            
a = Solution()
matrix = [[1, 1, 1],[1, 2, 3], [1, 2, 3]]
matrix = [[1, 2, 3],[3, 1, 2], [2, 3, 1]]
# print(a.checkValidZip(matrix))
board = [["8","3",".",".","7",".",".",".","."]
        ,["6",".",".","1","9","5",".",".","."]
        ,[".","9","8",".",".",".",".","6","."]
        ,["8",".",".",".","6",".",".",".","3"]
        ,["4",".",".","8",".","3",".",".","1"]
        ,["7",".",".",".","2",".",".",".","6"]
        ,[".","6",".",".",".",".","2","8","."]
        ,[".",".",".","4","1","9",".",".","5"]
        ,[".",".",".",".","8",".",".","7","9"]]
# print(a.isValidSudoku(board))
board = [["5","3",".",".","7",".",".",".","."],
         ["6",".",".","1","9","5",".",".","."],
         [".","9","8",".",".",".",".","6","."],
         ["8",".",".",".","6",".",".",".","3"],
         ["4",".",".","8",".","3",".",".","1"],
         ["7",".",".",".","2",".",".",".","6"],
         [".","6",".",".",".",".","2","8","."],
         [".",".",".","4","1","9",".",".","5"],
         [".",".",".",".","8",".",".","7","9"]]

board = [[".",".",".","2",".",".",".","6","3"],
        ["3",".",".",".",".","5","4",".","1"],
        [".",".","1",".",".","3","9","8","."],
        [".",".",".",".",".",".",".","9","."],
        [".",".",".","5","3","8",".",".","."],
        [".","3",".",".",".",".",".",".","."],
        [".","2","6","3",".",".","5",".","."],
        ["5",".","3","7",".",".",".",".","8"],
        ["4","7",".",".",".","1",".",".","."]]

board = [[".",".","9","7","4","8",".",".","."],
         ["7",".",".",".",".",".",".",".","."],
         [".","2",".","1",".","9",".",".","."],
         [".",".","7",".",".",".","2","4","."],
         [".","6","4",".","1",".","5","9","."],
         [".","9","8",".",".",".","3",".","."],
         [".",".",".","8",".","3",".","2","."],
         [".",".",".",".",".",".",".",".","6"],
         [".",".",".","2","7","5","9",".","."]]

a.solveSudoku(board)

#  ["8","5","4","2","1","9","7","6","3"],
#  ["3","9","7","8","6","5","4","2","1"],
#  ["2","6","1","4","7","3","9","8","5"],
#  ["7","8","5","1","4","6","3","9","2"],
#  ["1","4","9","5","3","8","0","7","6"],
#  ["6","3","2","9","0","7","1","5","4"],
#  ["9","2","6","3","8","4","5","1","7"],
#  ["5","1","3","7","9","2","6","4","8"],
#  ["4","7","8","6","5","1","2","3","9"]

# [["8","5","4","2","1","9","7","6","3"],
#  ["3","9","7","8","6","5","4","2","1"],
#  ["2","6","1","4","7","3","9","8","5"],
#  ["7","8","5","1","2","6","3","9","4"],
#  ["6","4","9","5","3","8","1","7","2"],
#  ["1","3","2","9","4","7","8","5","6"],
#  ["9","2","6","3","8","4","5","1","7"],
#  ["5","1","3","7","9","2","6","4","8"],
#  ["4","7","8","6","5","1","2","3","9"]]
