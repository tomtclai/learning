//
//  ProfileCard.swift
//  UdacitySwiftUIDataLessons
//
//  Created by Tom Lai on 4/26/25.
//

import SwiftUI
struct ProfileCard: View {
    let profile: Profile
      var body: some View {
          HStack {
              CaptionProfileImage(profile: profile)
              VStack {
                  Text(profile.name)
                      .font(.largeTitle)
                      .fontWeight(.bold)
                  Text(profile.location)
                      .font(.title)
              }
          }
          .padding()
          .border(.black)
      }
}
#Preview {
    let profile = Profile(name: "David Harris", jobTitle: "Instructor", location: "Seattle, WA", image: "profileImage")

    ProfileCard(profile: profile)
}
