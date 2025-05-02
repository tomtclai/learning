//
//  UserPhotoView.swift
//  PhotoSaver
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct UserPhotoView: View {
    let imageResource: ImageResource

    init(_ imageResource: ImageResource) {
        self.imageResource = imageResource
    }

    var body: some View {
        GeometryReader { proxy in
            Image(imageResource)
                .resizable()
                .scaledToFill()
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.width
                )
                .clipped()
        }
        .scaledToFit()
    }
}

#Preview {
    UserPhotoView(.beach)
        .padding()
}
