//
//  ContentView.swift
//  PickAnImage
//
//  Created by Jan Hovland on 07/10/2020.
//

// Dokumentasjon:
// https://stackoverflow.com/questions/57110290/how-to-pick-image-from-gallery-in-swiftui

import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject var sheet = SettingsSheet()
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            if image != nil {
                /// Her vises enten hele eller deler av det valgte bildet fra .photoLibrary
                Image(uiImage: image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80, alignment: .center)
                    .clipShape(Circle())
            }
            Button(
                action: { Image_Picker_Ver_01() },
                label: {
                    HStack {
                        Text(NSLocalizedString("Pick an image", comment: "ContentView"))
                    }
                }
            )
        }
        /// Slik må .sheet implementers i Xcode Version 12 og macOS 11
        .sheet(isPresented: $sheet.isShowing, content: sheetContent)
    }
    /// Her legges det inn knytning til aktuelle view i i Xcode Version 12 og macOS 11
    @ViewBuilder
    private func sheetContent() -> some View {
        if sheet.state == .imagePickerVer01 {
            ImagePickerVer01(sourceType: .photoLibrary) { image in
                self.image = image
            }
        } else {
            EmptyView()
        }
    }
    /// Her legges det inn aktuelle sheet.state i i Xcode Version 12 og macOS 11
    func Image_Picker_Ver_01() {
        sheet.state = .imagePickerVer01
    }
}

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
