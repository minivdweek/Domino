import Input

--
--de hoofdmethode!
--
printSolutionsTo :: [Integer] -> IO ()
printSolutionsTo [] = return ()
printSolutionsTo a = do
   let input = map fromIntegral a
   putStrLn "Het origineel:"
   putStrLn "------------------"
   printLines input
   putStrLn "------------------"
   putStrLn "" 
   let bord = zip n input
            where n = iterate (+1) 0
   let sol = []
   let stack = zip n steen
             where n     = iterate (+1) 1
                   steen = [(p1,p2) | p1 <- [0..6], p2 <- [0..p1]]
   nextStep bord sol stack
   putStrLn ""
   putStrLn "That's it!"
   printSolutionsTo [] 
  

--
--Hier gebeurt de magie!
--
nextStep :: [(Int,Int)] -> [(Int,Int)] -> [(Int,(Int,Int))] -> IO ()
nextStep [] tempSo _ = printBord (getListFromBoard tempSo)
nextStep remBord tempSo remSt = do
   goRight remBord tempSo [] remSt
   goDown remBord tempSo [] remSt
   return ()

goRight :: [(Int,Int)] -> [(Int,Int)] -> [(Int,(Int,Int))] -> [(Int,(Int,Int))] -> IO ()
goRight _ _ _ [] = return ()
goRight ((c1,v1):(c2,v2):bord) sol tried ((ns,(p1,p2)):stack) | (0 == mod (c1 + 1) 8) || ((c1 + 1) /= c2)      = return ()
                                                              | not (((p1,p2)==(v1,v2)) || ((p2,p1)==(v1,v2))) = goRight ((c1,v1):(c2,v2):bord) sol ((ns,(p1,p2)):tried) stack
                                                              | otherwise                                      = do
    nextStep bord ((c1,ns):(c2,ns):sol) (stack ++ tried)
    goRight ((c1,v1):(c2,v2):bord) sol ((ns,(p1,p2)):tried) stack

goDown :: [(Int,Int)] -> [(Int,Int)] -> [(Int,(Int,Int))] -> [(Int,(Int,Int))] -> IO ()
goDown _ _ _ [] = return ()
goDown ((a,b):bord) sol tried ((ns,(p1,p2)):stack) | (a > 47) || ((8 + a) /= getNum (getDown (a,b) bord))                                               = return ()
                                                   | not (((p1,p2)==(b,(getVal (getDown (a,b) bord)))) || ((p2,p1)==(b,(getVal (getDown (a,b) bord))))) = goDown ((a,b):bord) sol ((ns,(p1,p2)):tried) stack
                                                   | otherwise                                                                                          = do
   nextStep (removeField (a+8,b) bord) ((a,ns):(a+8,ns):sol) (stack ++ tried)
   goDown ((a,b):bord) sol ((ns,(p1,p2)):tried) stack


--
--een paar hulpfuncties, wss kan het ook zonder
--
getDown :: (Int,Int) -> [(Int,Int)] -> (Int,Int)
getDown (a,b) bord  = head [(c,v) | (c,v) <- bord, (a+8)==c]

removeField :: (Int,Int) -> [(Int,Int)] -> [(Int,Int)]
removeField (a,_) bord = [(c,v) | (c,v) <- bord, c/=a]

getNum :: (Int,Int) -> Int
getNum (a,_) = a

getVal :: (Int,Int) -> Int
getVal (_,v) = v

--
--De methodes om de borden te printen
--
printBord :: [Int] -> IO ()
printBord [] = return ()
printBord os = do 
   putStrLn "Possible Solution:"
   putStrLn "------------------"
   printLines os
   putStrLn "------------------"
   putStrLn ""
   printBord []

printLines :: [Int] -> IO ()
printLines [] = return ()
printLines os = do
   printLine (take 8 os)
   putStrLn " "
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
