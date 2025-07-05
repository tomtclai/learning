// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI
import PhotosUI /* Got to import */

struct PhotosPicker_Intro: View {
    @State private var photo: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $photo, /* Bound to single item restricts selection to just one */
                         /* Just images but also every type you can capture with an iOS camera like videos, slo motion videos, burst, etc. */
                         matching: .images) {
                Text("Select a photo")
            }
            Spacer()
            if let selectedImage {
                Text("Selected Photo")
                selectedImage
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
        }
        .font(.title)
        .onChange(of: photo) { _, newPhoto in
            if let newPhoto {
                Task {
                    selectedImage = await newPhoto.convert()
                }
            }
        }
    }
}

struct PhotosPicker_Intro_Previews: PreviewProvider {
    static var previews: some View {
        PhotosPicker_Intro()
    }
}

extension PhotosPickerItem {
    /// Load and return an image from a PhotosPickerItem
    @MainActor
    func convert() async -> Image {
        do {
            if let data = try await self.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    return Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return Image(systemName: "xmark.octagon")
    }
}
