//
//  CameraView.swift
//  CameraApp
//
//  Created by Jesus Guerra on 6/25/24.
//

import Photos
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        // 1. Create a UIImagePickerController with sourceType camera and set the picker delegate as the context.coordinator
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        // 2. Return a Coordinator with isPresented and image bindings
        let coordinator = Coordinator(isPresented: $isPresented, image: $image)
        return coordinator
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var image: UIImage?

        init(isPresented: Binding<Bool>, image: Binding<UIImage?>) {
            _isPresented = isPresented
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                image = uiImage
            }
            isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 3. Set isPresented to false when the user cancels the image picker
            isPresented = false 
        }
    }
}
