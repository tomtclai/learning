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

struct PetRankingView: View {
  @ObservedObject var viewModel: PetRankingViewModel
  var animal: AnimalEntity

  init(animal: AnimalEntity) {
    self.animal = animal
    viewModel = PetRankingViewModel(animal: animal)
  }

  var body: some View {
    HStack {
      Text("Rank me!")
        .multilineTextAlignment(.center)
      ForEach(0...4, id: \.self) { index in
        PetRankImage(index: index, recentIndex: $viewModel.ranking)
      }
    }
  }
}

struct PetRankImage: View {
  let index: Int
  @State var opacity: Double = 0.4
  @State var tapped = false
  @Binding var recentIndex: Int

  var body: some View {
    Image("creature_dog-and-bone")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .opacity(opacity)
      .frame(width: 50, height: 50)
      .onTapGesture {
        opacity = tapped ? 0.4 : 1.0
        tapped.toggle()
        recentIndex = index
      }
      .onChange(of: recentIndex) { value in
        checkOpacity(value: value)
      }
      .onAppear {
        checkOpacity(value: recentIndex)
      }
  }

  func checkOpacity(value: Int) {
    opacity = value >= index ? 1.0 : 0.4
    tapped.toggle()
  }
}

final class PetRankingViewModel: ObservableObject {
  var animal: AnimalEntity
  var ranking: Int {
    didSet {
      animal.ranking = Int32(ranking)
      objectWillChange.send()
    }
  }

  init(animal: AnimalEntity) {
    self.animal = animal
    self.ranking = Int(animal.ranking)
  }
}

struct PetRankingView_Previews: PreviewProvider {
  static var previews: some View {
    if let animal = CoreDataHelper.getTestAnimalEntity() {
      Group {
        PetRankingView(animal: animal)
          .padding()
          .previewLayout(.sizeThatFits)
          .environment(\.sizeCategory, .extraSmall)
          .previewDisplayName("Extra-Small")

        PetRankingView(animal: animal)
          .padding()
          .previewLayout(.sizeThatFits)
          .previewDisplayName("Regular")

        PetRankingView(animal: animal)
          .padding()
          .previewLayout(.sizeThatFits)
          .environment(\.sizeCategory, .extraLarge)
          .previewDisplayName("Extra-Large")
      }
    }
  }
}
