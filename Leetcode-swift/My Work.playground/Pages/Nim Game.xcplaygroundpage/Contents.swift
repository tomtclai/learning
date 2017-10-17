//https://leetcode.com/problems/nim-game/description/
    func canWinNim(_ n: Int) -> Bool {
        return n % 4 != 0
        // if there are 8 ... i lose
        // if there are 7 ... remove 3 and then i win
        // if there are 6 ... remove 2 and then i win
        // if there are 5 stones... remove 1 and then i win
        // i remove 1... i win
        // if there are 4 stones...
        // i remove 1 . they remove 3. they win
        // i remove 2 . they remove 2. they win
        // i remove 3 . they remove 1. they win
        // if there are 3 stones... i win
        // if there are 2 stones  i win
        // if there is  1 stone   i win
    }
