//  Copyright © 2021 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Text_DateFormatting: View {
    var body: some View {
        VStack(spacing: 10) {
            HeaderView("Text",
                       subtitle: "Date Formatting",
                       desc: "Use the formatted modifier on dates to format them the way you want.",
                       back: .green, textColor: .white)
            
            Text(Date().formatted())
            
            Group {
                DescView(desc: "Date", back: .green, textColor: .white)
                
                Group {
                    Text(Date().formatted(date: .abbreviated, time: .omitted))
                    Text(Date().formatted(date: .complete, time: .omitted))
                    Text(Date().formatted(date: .omitted, time: .omitted))
                    Text(Date().formatted(date: .long, time: .omitted))
                    Text(Date().formatted(date: .numeric, time: .omitted))
                }
                DescView(desc: "Time", back: .green, textColor: .white)
                Group {
                    Text(Date().formatted(date: .omitted, time: .complete))
                    Text(Date().formatted(date: .omitted, time: .shortened))
                    Text(Date().formatted(date: .omitted, time: .standard))
                }
            }
            .font(.title2)
        }
        .font(.title)
    }
}

struct Text_DateFormatting_Previews: PreviewProvider {
    static var previews: some View {
        Text_DateFormatting()
    }
}
