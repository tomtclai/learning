/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct RegisterView: View {
  @State var experimentDouble = 0.0
  @State var experimentString = ""

  @EnvironmentObject var userManager: UserManager

  @ObservedObject var keyboardHandler: KeyboardFollower
  init(keyboardHandler: KeyboardFollower) {
    self.keyboardHandler = keyboardHandler
  }
  var experimentSlider: some View {
    VStack{
      HStack{
        Text("0")
        Slider(value: $experimentDouble,
               in: 0.0...10.0,
               step: 0.5)
        Text("10")
      }
      Text("\(experimentDouble)")
    }
  }
  var experimentStepper: some View {
    VStack{
      HStack{
        Stepper("Quantity: \(experimentDouble)",
                value: $experimentDouble,
               in: 0.0...10.0,
               step: 0.5)
      }
    }
  }
  var experimentSecureField: some View {
    SecureField("Password", text: $experimentString)
      .textFieldStyle(RoundedBorderTextFieldStyle())
  }
  var body: some View {
    VStack {
//      experimentSlider
//      experimentStepper
//      experimentSecureField
      Spacer()
      WelcomeMessageView()
      TextField("Type your name...", text: $userManager.profile.name).bordered()
      HStack {
        Spacer()
        Text("\(userManager.profile.name.count)")
          .font(.caption)
          .foregroundColor(userManager.isUserNameValid() ? .green : .red)
          .padding(.trailing)
      }
      HStack {
        Spacer()
        Toggle(isOn: $userManager.settings.rememberUser) {
          Text("Remember me")
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .fixedSize()
      }
      .padding(.bottom)
      Button(action: self.registerUser) {
        HStack {
          Image(systemName: "checkmark")
            .resizable()
            .frame(width: 16, height: 16, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          Text("OK")
            .font(.body)
            .bold()
        }
      }.disabled(!userManager.isUserNameValid())
      .bordered()
      Spacer()
    }
    .padding(.bottom, keyboardHandler.keyboardHeight)
    .edgesIgnoringSafeArea(keyboardHandler.isVisible ? .bottom : [])
    .padding()
    .background(WelcomeBackgroundImage())
  }
}

extension RegisterView {
  func registerUser() {
    if userManager.settings.rememberUser {
    userManager.persistProfile()
    } else {
      userManager.clear()
    }
    userManager.persistSettings()
    userManager.setRegistered()
  }
}

struct RegisterView_Previews: PreviewProvider {
    static let user = UserManager(name: "Ray")
    static var previews: some View {
      RegisterView(keyboardHandler: KeyboardFollower()).environmentObject(user)
    }
}
