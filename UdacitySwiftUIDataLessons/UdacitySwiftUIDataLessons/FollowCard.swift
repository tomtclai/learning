//
//  FollowCard.swift
//  UdacitySwiftUIDataLessons
//
//  Created by Tom Lai on 4/26/25.
//

import SwiftUI

struct FollowCard: View {
    let profile: Profile
    var body: some View {
        Button("Follow Me") {}
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        
    }
}

#Preview {
    let profile = Profile(name: "David Harris", jobTitle: "Instructor", location: "Seattle", image: "profileImage")
    FollowCard(profile: profile)
}
