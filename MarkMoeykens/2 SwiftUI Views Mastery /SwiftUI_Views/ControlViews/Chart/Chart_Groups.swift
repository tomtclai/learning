// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import Charts
/* This is another way to show multiple series of data*/
struct GroupInfo: Identifiable {
    let id = UUID()
    var x = ""
    var y = 0
    var group = ""
    
    static func fetchData() -> [GroupInfo] {
        [
            GroupInfo(x: "Quarter 1", y: 75, group: "Rod"),
            GroupInfo(x: "Quarter 2", y: 25, group: "Rod"),
            GroupInfo(x: "Quarter 1", y: 50, group: "Lem"),
            GroupInfo(x: "Quarter 3", y: 100, group: "Rod"),
            GroupInfo(x: "Quarter 2", y: 75, group: "Lem"),
            GroupInfo(x: "Quarter 4", y: 50, group: "Rod"),
            GroupInfo(x: "Quarter 3", y: 65, group: "Lem"),
            GroupInfo(x: "Quarter 4", y: 70, group: "Lem")
        ]
    }
}

struct Chart_Groups: View {
    @State private var data = GroupInfo.fetchData()
    
    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Category", $0.x),
                y: .value("Quantity", $0.y)
            )
            .foregroundStyle(by: .value("Group", $0.group))
            /* BOOK
             Let's look at some ways to better customize line marks.
             */
        }
        .padding()
        .dynamicTypeSize(.xxLarge)
    }
}

struct Chart_Groups_Previews: PreviewProvider {
    static var previews: some View {
        Chart_Groups()
    }
}
