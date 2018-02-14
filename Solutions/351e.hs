import Data.Char (isDigit, digitToInt)

-- Given a string of plays, returns the resulting team scores
cricket :: [Char] -- ^ A string of plays
        -> [Int]  -- ^ The resulting team scores
cricket plays = parse plays (take 12 (repeat 0)) (1, 2) 0
    -- The team scores list holds the team score followed by each individual player's score.
    -- The starting players are player 1 and player 2.
    -- The game starts with 0 balls thrown.

-- Parses a single play
parse :: [Char]     -- ^ The string of plays remaining
      -> [Int]      -- ^ The team scores so far
      -> (Int, Int) -- ^ The current players (striker, non-striker)
      -> Int        -- ^ Legal balls thrown; after 6, it's an Over
      -> [Int]      -- ^ The resulting team scores
parse [] scores _     _ = scores -- There are no more plays recorded
parse _  scores (0,0) _ = scores -- There are no players left
parse (p:ps) scores players balls
    | isDigit p = parse ps (inc (fst players) scores pInt) (nextPlayers players pInt balls') balls'
    | p == '.'  = parse ps scores                          (nextPlayers players 0    balls') balls'
    | p == 'b'  = parse ps (inc 0 scores 1)                (nextPlayers players 1    balls') balls'
    | p == 'w'  = parse ps (inc 0 scores 1)                players                           balls
    | p == 'W'  = parse ps scores                          (nextPlayers players (-1) balls') balls'
        where pInt   = digitToInt p
              balls' = if balls == 6 then 1 else balls + 1

-- Determines which two players will be in after the given number of runs by the striker
nextPlayers :: (Int, Int) -- ^ The current players (striker, non-striker)
            -> Int        -- ^ The number of runs taken (-1 if out)
            -> Int        -- ^ Legal balls thrown; after 6, the bowler switches sides
            -> (Int, Int) -- ^ The next players
nextPlayers ps runs balls =
    if max p1 p2 > 11 then (0, 0) -- Inning over
    else (p1, p2)
        where (p1, p2) = if balls == 6 then (snd ps', fst ps') else ps' -- Essentially, the resulting players switch
                            where ps' = if      runs == -1 then ((max (fst ps) (snd ps)) + 1, snd ps) -- Striker out
                                        else if odd runs   then (snd ps, fst ps)
                                        else ps

-- Increases the specified element of a list by the specified amount.
-- Used to increase a striker's (or the team's) score
inc :: Int   -- ^ The index of the element to increase
    -> [Int] -- ^ A list
    -> Int   -- ^ The amount to increase by
    -> [Int] -- ^ The modified list
inc n l x = take n l ++ [(l !! n) + x] ++ drop (n+1) l
