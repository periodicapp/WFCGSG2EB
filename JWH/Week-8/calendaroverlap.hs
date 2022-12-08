--spanOverlaps takes two tuples of Int representing boundaries and returns True
--if they overlap, False otherwise.  
spanOverlaps :: (Int,Int) -> (Int,Int) -> Bool
spanOverlaps (a,b) (x,y)
  | a >= x && a < y = True
  | b > x && b <= y = True
  | a < x && b > y = True
  | x < a && y > b = True
  | otherwise = False

--getOverlap takes two tuples of Int - and one Int representing how many
--intersections the first tuple represents - that are known to overlap (in the
--sense of spanOverlaps - see above) and returns a triple of Int that
--represents the overlap.  The first and second items of the returned triple
--are the new boundaries, and the third item represents the number of spans
--that have previously overlapped this span (i.e. we always just increment this
--to record that we have a new overlap)
getOverlap :: (Int,Int) -> (Int,Int) -> Int -> (Int,Int,Int)
getOverlap (a,b) (x,y) i =
  let
    aa = if a >= x then a else x
    bb = if b <= y then b else y
  in
    (aa, bb, i+1)
    
--catMaybes takes a list of Maybe types and returns a list of the values of
--only the "Just" results - i.e. it skips all "Nothing" types
catMaybes :: [Maybe a] -> [a]
catMaybes ls = [x | Just x <- ls]

--allOverlaps takes a list of triples representing a timeslot paired with the
--number of slots it intersects/overlaps with, then another timeslot, and it
--returns the result of (a) adding the new timeslot to the list (with a 1
--indicating that it definitely "overlaps" with itself, (b) concatenating that
--with the result of (the successes of) trying to combine the new slot with
--each existing slot in turn and (c) concatenating all that with the list built
--up to that point (to preserve precombined slots for potential combination
--with new slots in the future)
allOverlaps :: [(Int,Int,Int)] -> (Int,Int) -> [(Int,Int,Int)]
allOverlaps xs (x,y) = [(x,y,1::Int)] ++ (catMaybes $ map (incOverlap (x,y,1)) xs) ++ xs

--bookAll is the engine function.  It takes a list of start and end time pairs
--and iterates over them, building up a list of all overlap times with the
--number of overlapping spans to that point.  The solution is then just a
--matter of finding the slot in the returned list that has the maximum number
--of overlaps.
bookAll :: [(Int,Int)] -> [(Int,Int,Int)]
bookAll = foldl allOverlaps []

--max3 takes an Int and a triple of Int and returns the max value between the
--Int and the third member of the triple
max3 :: Int -> (Int,Int,Int) -> Int
max3 x (_,_,y) = max x y

--maxOverlap takes a list of triples of Int and returns the maximum third value
--of any triple in the list it finds
maxOverlap :: [(Int,Int,Int)] -> Int
maxOverlap = foldl max3 0
    
--incOverlap takes two triples, each representing an overlap (i.e. a start and
--end bound and a number of spans known to intersect with this one) and returns
--a new triple representing the overlap if they overlap, otherwise it just
--returns the second triple
incOverlap :: (Int,Int,Int) -> (Int,Int,Int) -> Maybe (Int,Int,Int)
incOverlap (a,b,i) (x,y,j)
  | spanOverlaps (a,b) (x,y) = Just $ getOverlap (a,b) (x,y) j
  | otherwise = Nothing

--test runner function for spanOverlaps
runSpanOverlaps :: ((Int,Int),(Int,Int),Bool) -> Bool
runSpanOverlaps ((a,b),(x,y),t) = 
  let
    result = spanOverlaps (a,b) (x,y)
  in
    result == t

--test runner function for incOverlap
runIncOverlap :: ((Int,Int,Int),(Int,Int,Int),Maybe (Int,Int,Int)) -> Bool
runIncOverlap ((a,b,i),(x,y,j),r) = 
  let
    result = incOverlap (a,b,i) (x,y,j)
  in
    result == r

--myCalendarThree is the main function.  It takes a list of tuples of Int
--representing a span and returns the maximum number of overlapping spans found
--in the list
myCalendarThree :: [(Int,Int)] -> Int
myCalendarThree = maxOverlap . bookAll

--main = print $ all runSpanOverlaps [((10,20),(15,20),True)
--                            ,((10,20),(50,60),False)
--                            ,((10,20),(10,40),True)
--                            ,((10,20),(5,15),True)
--                            ,((10,20),(5,10),False)
--                            ,((10,20),(25,55),False)
--                            ,((50,60),(25,55),True)
--                           ]

--main = print $ all runIncOverlap [((10,20,0),(15,20,0), Just (15,20,1))
--                              ,((10,20,0),(50,60,0), Nothing)
--                              ,((10,20,0),(10,40,0), Just (10,20,1))
--                              ,((10,20,0),(5,15,0), Just (10,15,1))
--                              ,((10,20,0),(5,10,0), Nothing)
--                              ,((10,20,0),(25,55,0),Nothing)
--                              ,((50,60,0),(25,55,0),Just (50,55,1))
--                              ]

main = print $ myCalendarThree [(10, 20), (50, 60), (10, 40), (5, 15), (5, 10), (25, 55)]
