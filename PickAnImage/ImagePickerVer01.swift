//
//  ImagePickerVer01.swift
//  PickAnImage
//
//  Created by Jan Hovland on 09/10/2020.
//

import SwiftUI

public struct ImagePickerVer01: UIViewControllerRepresentable {
    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
        /// Hente bilde fra photoLibrary
        self.sourceType = .photoLibrary
        self.onImagePicked = onImagePicked
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        /// Hente bilde fra photoLibrary
        picker.sourceType = .photoLibrary
        /// Muliggjør utvalg på bildet
        picker.allowsEditing = true
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void
        
        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            /// Her hentes hele bildet:
            //            if let image = info[.originalImage] as? UIImage {
            //                self.onImagePicked(image)
            //            }
            /// Her hentes det editerte bildet_
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.onImagePicked(image)
            }
            self.onDismiss()
        }
        
        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }
        
    }
}

