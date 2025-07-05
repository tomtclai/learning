//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Text_DateFormat_Specific: View {
    var body: some View {
        VStack(spacing: 10) {
            HeaderView("Text",
                       subtitle: "Date Format - Specific Parts",
                       desc: "Use the formatted modifier on dates to show just specific parts of a date time.",
                       back: .green, textColor: .white)
            
            Text(Date().formatted())
            
            DescView(desc: "Parts", back: .green, textColor: .white)
            Group {
                Text("**Week of Year:** \(Date().formatted(.dateTime.week()))")
                Text("**Week of Month:** \(Date().formatted(.dateTime.week(.weekOfMonth)))")
                Text("**Weekday:**  \(Date().formatted(.dateTime.weekday()))")
                Text("**Weekday:**  \(Date().formatted(.dateTime.weekday(.wide)))")
                Text("**Day #:**  \(Date().formatted(.dateTime.day(.ordinalOfDayInMonth)))")
           }
            
            DescView(desc: "Ordering Doesn't Matter", back: .green, textColor: .white)
            Group {
                Text(Date().formatted(.dateTime.day().month(.wide).year()))
            }
        }
        .font(.title)
    }
}

struct Text_DateFormat_Specific_Previews: PreviewProvider {
    static var previews: some View {
        Text_DateFormat_Specific()
    }
}
