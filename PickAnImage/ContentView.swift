//
//  ContentView.swift
//  PickAnImage
//
//  Created by Jan Hovland on 07/10/2020.
//

import SwiftUI

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var sheet = SettingsSheet()
    
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(Circle())
            }
            Button(
                action: { ImgPicker() },
                label: {
                    HStack {
                        Text(NSLocalizedString("Pick image", comment: "test"))
                    }
                }
            )
        }
        .sheet(isPresented: $sheet.isShowing, content: sheetContent)
    }
    
    /// Her legges det inn knytning til aktuelle view
    @ViewBuilder
    private func sheetContent() -> some View {
        if sheet.state == .imagePicker {
            ImagePickerView(sourceType: .photoLibrary) { image in
                self.image = image
            }
        } else {
            EmptyView()
        }
    }
    
    /// Her legges det inn aktuelle sheet.state
    func ImgPicker() {
        sheet.state = .imagePicker
    }
    
}

public struct ImagePickerView: UIViewControllerRepresentable {
    
    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
        self.sourceType = .photoLibrary
        self.onImagePicked = onImagePicked
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
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
