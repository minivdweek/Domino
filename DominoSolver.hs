import Input

--
--de hoofdmethode!
--
printSolutionsTo :: [Integer] -> IO ()
printSolutionsTo [] = return ()
printSolutionsTo a = do
   let input = map fromIntegral a
   putStrLn "The Original:"
   putStrLn " =========================="
   printLines input
   putStrLn " ==========================\n"
   let board = zip n input
            where n = iterate (+1) 0
   let sol = []
   let stack = zip n stones
             where n      = iterate (+1) 1
                   stones = [(p1,p2) | p1 <- [0..6], p2 <- [p1..6]]
   nextStep board sol stack
   putStrLn "\nThat's it!"
   printSolutionsTo [] 
  

--
--Hier gebeurt de magie!
--
nextStep :: [(Int,Int)] -> [(Int,Int)] -> [(Int,(Int,Int))] -> IO ()
nextStep [] tempSo _ = printBoard (getListFromBoard tempSo)
nextStep remBord tempSo remSt = do
   goRight remBord tempSo [] remSt
   goDown remBord tempSo [] remSt

goRight :: [(Int,Int)] -> [(Int,Int)] -> [(Int,(Int,Int))] -> [(Int,(Int,Int))] -> IO ()
goRight _ _ _ [] = return ()
goRight ((c1,v1):(c2,v2):board) sol tried ((ns,(p1,p2)):stack) | (0 == mod (c1 + 1) 8) || ((c1 + 1) /= c2)  = return ()
                                                               | fits (v1,v2) (p1,p2)                       = nextStep board ((c1,ns):(c2,ns):sol) (stack ++ tried)
                                                               | otherwise                                  = goRight ((c1,v1):(c2,v2):board) sol ((ns,(p1,p2)):tried) stack

goDown :: [(Int,Int)] -> [(Int,Int)] -> [(Int,(Int,Int))] -> [(Int,(Int,Int))] -> IO ()
goDown _ _ _ [] = return ()
goDown ((a,b):board) sol tried ((ns,(p1,p2)):stack) | (a > 47)                                        = return ()
                                                    | fits (p1,p2) (b,(getVal (getDown (a,b) board))) = nextStep (removeField (a+8,b) board) ((a,ns):(a+8,ns):sol) (stack ++ tried)
                                                    | otherwise                                       = goDown ((a,b):board) sol ((ns,(p1,p2)):tried) stack



--
--een paar hulpfuncties, wss kan het ook zonder
--
fits :: (Int,Int) -> (Int,Int) -> Bool
fits (v1,v2) (p1,p2) = ((v1,v2)==(p1,p2))||((v2,v1)==(p1,p2))

getDown :: (Int,Int) -> [(Int,Int)] -> (Int,Int)
getDown (a,b) bord  = head [(c,v) | (c,v) <- bord, (a+8)==c]

removeField :: (Int,Int) -> [(Int,Int)] -> [(Int,Int)]
removeField (a,_) board = [(c,v) | (c,v) <- board, c/=a]

getVal :: (Int,Int) -> Int
getVal (_,v) = v

--
--De methodes om de borden te printen
--
printBoard :: [Int] -> IO ()
printBoard [] = return ()
printBoard os = do 
   putStrLn "Possible Solution:"
   putStrLn "┌---------------------------┐"
   printLines os
   putStrLn "└---------------------------┘\n"
   putStrLn ""
   printBoard []

printLines :: [Int] -> IO ()
printLines [] = return ()
printLines os = do
   putStr "╎  "
   printLine (take 8 os)
   putStrLn " ╎"
   printLines (drop 8 os)

printLine :: [Int] -> IO ()
printLine [] = return ()
printLine (a:as) = do
   (putStr . show) a
   if (a > 9) then putStr " " else putStr "  "
   printLine as

getListFromBoard :: [(Int,Int)] -> [Int]
getListFromBoard []           = []
getListFromBoard ((ca,va):as) = getListFromBoard ss ++ [va] ++ getListFromBoard ls
                  where ss = [(c,v) | (c,v) <- as, c<ca]
                        ls = [(c2,v2) | (c2,v2) <- as, c2>=ca]
