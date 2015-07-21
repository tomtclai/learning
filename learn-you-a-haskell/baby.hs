doubleMe x = x + x
doubleUs x y = x*2 + y*2

doubleSmallNumber x = if x > 100
                        then x
                        else x*2

conanO'Brien = "It's a-me, Conan O'Brien!"
boomBangs xs = [if x < 10
                    then "BOOM!"
                    else "BANG!" | x <- xs, odd x]

-- _ means that we don't care what we will draw from the list
-- this function repleaces every element of a list with 1 and
-- sums that up

removeNonUpperCase :: [Char] -> [Char]
removeNonUpperCase st = [ c | c <- st, c `elem` [ 'A'..'Z' ]]

-- Factorial recursively
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n - 1) 

circumference :: Float -> Float
circumference r = 2 * pi * r

circumference' :: Double -> Double
circumference' r = 2 * pi * r

lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "sorry, you're out of luck!"

-- Note that if we moved the last pattern to the top, it would catch all the numbers and they wouldn't have a change to fall through and be checked for any other patterns
sayMe :: (Integral a) => a -> String
sayMe 1 = "One"
sayMe 2 = "Two"
sayMe 3 = "Three"
sayMe 4 = "Four"
sayMe 5 = "Five"
sayMe x = "Not between 1 and 5"

charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph" 
charName 'c' = "Cecil" 

addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (x1, y1) (x2, y2) = ( x1 + x2, y1 + y2)

first :: (a, b, c) -> a
first (x, _, _) = x

second :: (a, b, c) -> b
second (_, y, _) = y

third :: (a, b, c) -> c
third (_, _, z) = z

head' :: [a]->a
head' [] = error "empty list"
head' (x:_) = x

tell :: (Show a) => [a] -> String
tell [] = "Empty"
tell (x:[]) = "one element, " ++ show x
tell (x:y:[]) = "two elements, " ++ show x ++ show y
tell (x:y:_) = "many elements, " ++ show x ++ show y ++ ".."

-- recursive length
length' :: (Num b) => [a] -> b
length' [] = 0
length' (_:xs) = 1 + length' xs

sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

-- patterns
capital :: String -> String
capital "" = "Empty string, whoops"
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]

