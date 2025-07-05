// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Text_TimeFormatting: View {
    var body: some View {
        VStack(spacing: 10) {
            HeaderView("Text",
                       subtitle: "Time Format - Specific Parts",
                       desc: "Use the formatted modifier on dates to show just specific parts of a time.",
                       back: .green, textColor: .white)
            
            Text(Date().formatted())
            
            DescView(desc: "Parts", back: .green, textColor: .white)
            Group {
                Text("**Hour:** \(Date().formatted(.dateTime.hour()))")
                Text("**Minutes:** \(Date().formatted(.dateTime.minute()))")
                Text("**Seconds:**  \(Date().formatted(.dateTime.second()))")
                Text("**Timezone:**  \(Date().formatted(.dateTime.timeZone()))")
           }
            
            DescView(desc: "Other Formats", back: .green, textColor: .white)
            Group {
                Text(Date().formatted(.dateTime.minute().hour(.twoDigits(amPM: .omitted))))
                Text(Date().formatted(.dateTime.hour(.twoDigits(amPM: .narrow))))
                Text(Date().formatted(.dateTime))
//                Text(Date().formatted(.dateTime.hour()))
//                Text(Date().formatted(.dateTime.hour(.twoDigits(amPM: .omitted))))
//                Text(Date().formatted(.dateTime.minute().hour(.twoDigits(amPM: .abbreviated))))
            }
        }
        .font(.title)
    }
}

struct Text_TimeFormatting_Previews: PreviewProvider {
    static var previews: some View {
        Text_TimeFormatting()
    }
}
