import Data.List.Split
import Data.List

strToInt s = read s :: Integer

-- scales an integer up until it is greater than or equal to the target
extendToCeiling :: Integer -> Integer -> Integer
extendToCeiling target num = num * (ceiling $ (fromIntegral target) / (fromIntegral num))

main = do
    contents <- readFile "day13.input"
    let departTime = strToInt $ (lines contents) !! 0
    let busTimes = map strToInt $ filter (/="x") $ splitOn "," $ (lines contents) !! 1 -- take all non-"x" elements
    let nearBusTimes = map (extendToCeiling departTime) busTimes
    
    let soonestTime = foldl1 min nearBusTimes
    let waitTime = soonestTime - departTime
    
    let index = elemIndex soonestTime nearBusTimes
    
    case index of
        Just indexNum -> putStrLn $ show $ waitTime * (busTimes !! indexNum)
        Nothing -> putStrLn "Error: invalid index -> something is very wrong"
    --putStrLn $ foldl1 (\acc x -> acc ++ "," ++ x) $ map show nearBusTimes -- output (always at end of do expression?)