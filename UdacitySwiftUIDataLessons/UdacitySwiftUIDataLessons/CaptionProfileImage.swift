//
//  CaptionProfileImage.swift
//  UdacitySwiftUIDataLessons
//
//  Created by Tom Lai on 4/26/25.
//
import SwiftUI
struct CaptionProfileImage : View {
    let profile: Profile
    var body: some View {
        VStack {
            Image(profile.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 96, height: 96)
                .cornerRadius(35)
            Text("Instructor")
                .font(.caption)
        }.padding()
    }
}
