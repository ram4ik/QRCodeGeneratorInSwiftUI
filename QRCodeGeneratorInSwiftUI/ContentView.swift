//
//  ContentView.swift
//  QRCodeGeneratorInSwiftUI
//
//  Created by Ramill Ibragimov on 21.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var urlInput: String = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        TextField("Enter url:", text: $urlInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.URL)
                            .keyboardType(.URL)
                        
                        Button("Generate") {
                            
                        }
                        .disabled(urlInput.isEmpty)
                        .padding(.leading)
                    }
                    Spacer()
                    
                    EmptyStateView(width: geometry.size.width)
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("QR Code")
            }
        }
    }
}

struct EmptyStateView: View {
    let width: CGFloat
    
    private var imageLenght: CGFloat {
        width / 2.5
    }
    
    var body: some View {
        VStack {
            Image(systemName: "qrcode")
                .resizable()
                .frame(width: imageLenght, height: imageLenght)
            
            Text("Create your own QR code")
                .padding(.top)
        }.foregroundColor(Color(UIColor.systemGray))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
