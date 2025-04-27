//
//  ContentView.swift
//  UdacitySwiftUIDataLessons
//
//  Created by Tom Lai on 4/26/25.
//

import SwiftUI

struct InstructurorView: View {
    let profile = Profile(name: "David Harris", jobTitle: "Instructor", location: "Seattle, WA", image: "profileImage")
    var body: some View {
        ProfileCard(profile: profile)
        FollowCard(profile: profile)
    }
}

#Preview {
    FormView()
}
struct ContentView: View {
    var body: some View {
        return FormView(form:SignUpForm())
    }
}

enum FavoriteColor: String, CaseIterable {
    case red = "Red"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
    case purple = "Purple"
    case orange = "Orange"
    case other = "Other"
}
struct SignUpForm {
    var name: String = ""
    var email: String = ""
    var receiveMarketing: Bool = false
    var favoriteColor: FavoriteColor = .red
}
struct FormView: View {
    @State var form = SignUpForm()
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $form.name)
                TextField("Email", text: $form.email)
                    .keyboardType(.emailAddress)
                Picker("Favorite Color", selection: $form.favoriteColor) {
                    ForEach(FavoriteColor.allCases, id: \.rawValue) {
                        color in
                        Text(color.rawValue)
                            .tag(color)
                    }
                }
            }
            Section(header: Text("Sign Up")) {
                Toggle("Marketing Communications", isOn: $form.receiveMarketing)

            }
            Button("Sign up") {
                
            }
        }
    }
}
