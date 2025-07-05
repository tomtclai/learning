//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct Link_Intro: View {
    var body: some View {
        VStack(spacing: 40) {
            HeaderView("Link",
                       subtitle: "Introduction",
                       desc: "Use a Link to open the default web browser and navigate to a URL, call a phone number, email and many other things that Apple provides schemes for.")
            
            Link("Go to Apple", destination: URL(string: "https://www.apple.com")!)
            
            Link("Call Now", destination: URL(string: "tel:8005551234")!)
            
            Link("Email Me", destination: URL(string: "mailto:myemail@swiftui.com")!)
            
            Link("Message Me", destination: URL(string: "sms:+18885551212&body=Hello")!)


            Spacer()
        }
        .font(.title)
    }
}

struct Link_Intro_Previews: PreviewProvider {
    static var previews: some View {
        Link_Intro()
    }
}
