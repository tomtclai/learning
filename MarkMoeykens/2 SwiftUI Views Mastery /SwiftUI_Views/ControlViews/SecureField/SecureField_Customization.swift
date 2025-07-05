//
//  SecureField_Customization.swift
//  100Views
//
//  Created by Mark Moeykens on 6/23/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct SecureField_Customization : View {
    @State private var userName = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("SecureField")
                .font(.largeTitle)
            Text("Customization")
                .font(.title)
                .foregroundStyle(.gray)
            Text("Use a ZStack to put a RoundedRectangle behind a SecureField with a plain textfieldStyle.")
                .frame(maxWidth: .infinity)
                .padding().font(.title)
                .background(Color.purple)
                .foregroundStyle(Color.white)
            
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.purple)
                TextField("user name", text: $userName)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal)
            }
            .frame(height: 40)
            .padding(.horizontal)
            
            Text("Or overlay the SecureField on top of another view or shape.")
                .frame(maxWidth: .infinity)
                .padding().font(.title)
                .background(Color.purple)
                .foregroundStyle(Color.white)
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.purple)
                .overlay(
                    SecureField("password", text: $password)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal)
            )
                .frame(height: 40)
                .padding(.horizontal)
        }
    }
}

struct SecureField_Customization_Previews : PreviewProvider {
    static var previews: some View {
        SecureField_Customization()
    }
}
