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
    
--incOverlap takes two triples, each representing an overlap (i.e. a start and
--end bound and a number of spans known to intersect with this one) and returns
--a new triple representing the overlap if they overlap, otherwise it just
--returns the second triple
incOverlap :: (Int,Int,Int) -> (Int,Int,Int) -> Maybe (Int,Int,Int)
incOverlap (a,b,i) (x,y,j)
  | spanOverlaps (a,b) (x,y) = Just $ getOverlap (a,b) (x,y) i
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

--main = print $ all runSpanOverlaps [((10,20),(15,20),True)
--                            ,((10,20),(50,60),False)
--                            ,((10,20),(10,40),True)
--                            ,((10,20),(5,15),True)
--                            ,((10,20),(5,10),False)
--                            ,((10,20),(25,55),False)
--                            ,((50,60),(25,55),True)
--                           ]

main = print $ all runIncOverlap [((10,20,0),(15,20,0), Just (15,20,1))
                              ,((10,20,0),(50,60,0), Nothing)
                              ,((10,20,0),(10,40,0), Just (10,20,1))
                              ,((10,20,0),(5,15,0), Just (10,15,1))
                              ,((10,20,0),(5,10,0), Nothing)
                              ,((10,20,0),(25,55,0),Nothing)
                              ,((50,60,0),(25,55,0),Just (50,55,1))
                              ]
