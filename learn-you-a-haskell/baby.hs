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
-- this function repleaces every element of a list with a and
-- sums that up
length' xs = sum [1 | _ <- xs]

removeNonUpperCase :: [Char] -> [Char]
removeNonUpperCase st = [ c | c <- st, c `elem` [ 'A'..'Z' ]]

