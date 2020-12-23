import Data.List.Split
import Data.List

import Debug.Trace

strToInt s = read s :: Integer

fstToInt :: (String, Integer) -> (Integer, Integer)
fstToInt tup = (read (fst tup) :: Integer, snd tup)

-- scales an integer up until it is greater than or equal to the target
extendToCeiling :: Integer -> Integer -> Integer
extendToCeiling target num = num * (ceiling $ (fromIntegral target) / (fromIntegral num))

-- This function returns tuples containing the elements which satisfy cond folded right, adding 1 to the second value
-- in each pair. (snd pair starts at 1)
-- Condition takes a single value (similar to filter)
-- NOTE: list cannot end with token
foldrOn cond list = 
    if (length list) /= 0 then 
        if cond (head list) then 
            do
                let tmp = foldrOn cond (tail list)
                (fst (head tmp), snd (head tmp) + 1) : (tail tmp) -- fold token into char after it 
        else
            (head list, 1) : (foldrOn cond (tail list)) -- don't fold token
    else
        [] -- base case len list = 0

-- returns the timestep at which a*n == b*m + k for n,m in Z+ & period for the return value
-- runs in time O(b)
-- NOTE: period * b is the loop because 
--TRACE: findFirstTimestep a b k period | trace ("findFirstTimestep " ++ show a ++ " " ++ show b ++ " " ++ show k ++ " " ++ show period) False = undefined
findFirstTimestep a b k period = (head $ dropWhile (==0) $ map (\i -> if (a + period * i) `mod` b == b - (k `mod` b) then (a + period * i + k) else 0) [0..b], period*b)

main = do
    putStrLn "pt1: "
    contents <- readFile "day13.input" -- "day13.test.input" (mostly for pt2)
    let departTime = strToInt $ (lines contents) !! 0
    let busTimes = map strToInt $ filter (/="x") $ splitOn "," $ (lines contents) !! 1 -- take all non-"x" elements
    let nearBusTimes = map (extendToCeiling departTime) busTimes
    
    let soonestTime = foldl1 min nearBusTimes
    let waitTime = soonestTime - departTime
    
    let index = elemIndex soonestTime nearBusTimes
    
    case index of
        Just indexNum -> putStrLn $ show $ waitTime * (busTimes !! indexNum)
        Nothing -> putStrLn "Error: invalid index -> something is very wrong"

    putStrLn "pt2: "
    let busTimePairs = foldrOn (=="x") $ splitOn "," $ (lines contents) !! 1
    let busTimePairs2 = map fstToInt busTimePairs -- cast fst to int
    
    let totalSteps = foldl (\acc b -> acc + (snd b)) 0 busTimePairs2 -- take sum of second of b (step)

    -- acc and b are different pairs -> acc : (val, period), b : (val, step aka k)  
    let busTimePairs3 = (fst (head busTimePairs2), fst (head busTimePairs2)) : (tail busTimePairs2) -- setting the initial case
    --TRACE: putStrLn $ foldl1 (\acc x -> acc ++ "," ++ x) $ map show busTimePairs3
    putStrLn $ show $ (fst $ foldl1 (\acc b -> findFirstTimestep (fst acc) (fst b) (snd b) (snd acc)) busTimePairs3) - (totalSteps - 1)
