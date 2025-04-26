//
//  ContentView.swift
//  UdacitySwiftUIDataLessons
//
//  Created by Tom Lai on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    let profile = Profile(name: "David Harris", jobTitle: "Instructor", location: "Seattle, WA", image: "profileImage")
    var body: some View {
        ProfileCard(profile: profile)
        FollowCard(profile: profile)
    }
}

#Preview {
  ContentView()
}
