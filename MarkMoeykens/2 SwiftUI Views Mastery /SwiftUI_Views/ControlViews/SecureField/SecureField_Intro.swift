//
//  SecureField_Intro.swift
//  100Views
//
//  Created by Mark Moeykens on 6/23/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct SecureField_Intro : View {
    @State private var userName = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Image("Logo")
                
            Spacer()
            
            Text("SecureField")
                .font(.largeTitle)
            
            Text("Introduction")
                .font(.title)
                .foregroundStyle(.gray)
            
            Text("SecureFields, like TextFields, need to bind to a local variable.")
                .frame(maxWidth: .infinity)
                .padding().font(.title)
                .background(Color.purple)
                .foregroundStyle(Color.white)
            
            TextField("user name", text: $userName)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            SecureField("password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Spacer()
        }
    }
}

struct SecureField_Intro_Previews : PreviewProvider {
    static var previews: some View {
        SecureField_Intro()
    }
}
