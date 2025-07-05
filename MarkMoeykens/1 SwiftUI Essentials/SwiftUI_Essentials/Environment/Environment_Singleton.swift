// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import Foundation

class LoggedInUserData {
    static var shared = LoggedInUserData()
    
    var userId = ""
    var userName = ""
    var userToken = ""
}



@Observable
class CustomerFriendsOO {
    var friends: [String] = []
    
    func fetch() {
        friends = Service().getFriends(userId: LoggedInUserData.shared.userId)
    }
}






class Service {
    func getFriends(userId: String) -> [String] {
        return ["Bob", "Mary"]
    }
}
