//
//  ContentView.swift
//  AlertsAndMenus
//
//  Created by Tom Lai on 4/21/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ActionSheetContentView()
    }
}

struct ActionSheetContentView : View {
    @State private var showingSheet = false
    @State private var selection = "None"
    var body: some View {
        Text(selection)
        Button("Confirm Paint color") {
            showingSheet = true
        }
        .confirmationDialog("Select color", isPresented: $showingSheet, titleVisibility: .visible) {
            ForEach(["Red", "Green", "Blue"], id:\.self) { color in
                Button(color) {
                    selection = color
                }
            }
        }
    }
}

struct MultipleAlertsView: View {
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
    var body: some View {
        Button("show alert 1") {
            showingAlert1 = true
        }
        .alert("Message 1", isPresented: $showingAlert1) {
            Button("OK", role: .cancel) {}
        }
        Button("show alert 2") {
            showingAlert2 = true
        }
        .alert("Message 2", isPresented: $showingAlert2) {
            Button("OK", role: .cancel) {}
        }
    }
}
struct TextFieldInAlertView: View {
    @State private var isAuthenticating = false
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        Button("Log in") {
            isAuthenticating.toggle()
        }
        .alert("Log in", isPresented: $isAuthenticating) {
            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("OK", action: authenticate)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enter your username and password.")
        }
    }
    func authenticate() {
        if username == "twostraws" && password == "sekrit" {
            print("You're in!")
        } else {
            print("Who are you?")
        }
    }
}

struct TVShowView: View {
    struct TVShow: Identifiable {
        var id: String { name }
        let name: String
    }
    @State private var selectedShow: TVShow?
    var body: some View {
        VStack(spacing: 20) {
            Text("What is your favorite tv show?")
            
            Button("Ted Lasso") {
                selectedShow = TVShow(name: "Ted Lasso")
            }
            
            Button("Bridgerton") {
                selectedShow = TVShow(name: "Bridgerton")
            }
        }
        .alert(item: $selectedShow) { show in
            Alert(title: Text(show.name), message: Text("Great choice"), dismissButton: .cancel())
        }
    }
}

struct AlertContentView : View {
    @State private var showingAlert = false
    var body: some View {
        Button("show alert") {
            showingAlert = true
        }
        .alert("Message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    ContentView()
}
