//
//  ProfilePicture.swift
//  ComposingViews
//
//  Created by Tom Lai on 4/19/25.
//
import SwiftUI

struct ProfilePicture: View {
    let imageName: String?
    var image: Image {
        if let imageName = imageName {
            Image(imageName)
        } else {
            Image(systemName: "person.circle.fill")
                .renderingMode(.template)
        }
    }

    var body: some View {
        image
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
    }
}

#Preview {
    ProfilePicture(imageName: nil)
}
