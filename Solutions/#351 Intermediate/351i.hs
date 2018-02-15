import Data.Char (isDigit, digitToInt)
import Data.List (elemIndex)
import Data.Maybe (fromJust)
import System.Environment (getArgs)

main = do
    args  <- getArgs
    input <- readFile (args!!0)

    let programs = concat (take 1 (lines input))
    let dance    = concat (drop 1 (lines input))

    print $ eval programs programs dance

eval :: String -- ^ The manipulated text so far
     -> String -- ^ The original text (for 'partner')
     -> String -- ^ The list of moves left to make (the remaining "dance")
     -> String -- ^ The resulting string
eval s _ [] = s
eval s o d
    | t == "s" = eval (spin     s   (n!!0))        o r
    | t == "x" = eval (exchange s   (n!!0) (n!!1)) o r
    | t == "p" = eval (partner  s o (n!!0) (n!!1)) o r
        where
            t = take 1 d                     -- Type of move
            m = takeWhile (\c -> c /= ',') d -- The full move
            n = numbers m                    -- Numbers in move
            r = drop ((length m) + 1) d      -- Remaining dance

spin :: String -> Int -> String
spin s n = drop ((length s) - n) s ++ take ((length s) - n) s

exchange :: String -> Int -> Int -> String
exchange s p1 p2 = take p1' s ++ [s!!p2'] ++ drop (p1'+1) (take p2' s) ++ [s!!p1'] ++ drop (p2'+1) s
    where (p1', p2') = if p1 > p2 then (p2, p1) else (p1, p2)

partner :: String -> String -> Int -> Int -> String
partner s o p1 p2 = exchange s (fromJust $ elemIndex (o!!p1) s) (fromJust $ elemIndex (o!!p2) s)

-- Extracts the (full) numbers from a given string
numbers :: String -> [Int]
numbers s = numbers' s []

numbers' :: String -> String -> [Int]
numbers' [] c = if length c > 0 then [read c::Int] else []
numbers' (x:xs) c
    | isDigit x = numbers' xs (c ++ [x])
    | otherwise = if length c > 0 then (read c::Int):(numbers' xs []) else numbers' xs []
