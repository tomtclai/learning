//
//  PhotoPostView.swift
//  PhotoSaver
//
//  Created by Mark DiFranco on 2024-05-08.
//

import SwiftUI

struct PhotoPostView: View {
    let imageResource: ImageResource

    @State private var isSaved = false

    var body: some View {
        UserPhotoView(imageResource)
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        SaveButton(isSaved: $isSaved)
                    }
                    Spacer()
                }
                .padding()
            }
    }
}

#Preview {
    PhotoPostView(imageResource: .cliffs)
}
