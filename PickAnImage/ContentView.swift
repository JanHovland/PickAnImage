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

