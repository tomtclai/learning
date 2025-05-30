//
//  ContentView.swift
//  CameraApp
//
//  Created by Jesus Guerra on 6/25/24.
//

import Photos
import SwiftUI

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var image: UIImage?
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                Button("Save Photo") {
                    // 1. Call savePhotoToLibrary passing the image
                    savePhotoToLibrary(image)
                }
                .padding()
            } else {
                Text("No Image Selected")
                    .foregroundColor(.gray)
                    .frame(width: 150, height: 150)
                    .background(Color.black.opacity(0.1))
            }
            Button("Capture Photo") {
                // 2. Check if the camera is available before showing the camera
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    // If available, set isShowingCamera to true
                    isShowingCamera = true
                    // Else, set alertMessage with an error message and showAlert to true
                } else {
                    alertMessage = "Camera not available"
                    showAlert = true
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            // 3. Present the CameraView when isShowingCamera is true
            CameraView(isPresented: $isShowingCamera, image: $image)
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(alertMessage), message: Text(alertMessage))
        })
    
    }

    func savePhotoToLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }

            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success {
                        // 5. On success, set image to nil, pass a success message to alertMessage, and set showAlert to true
                    } else if let error = error {
                        self.alertMessage = "Error saving photo: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
