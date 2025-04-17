//
//  ContentView.swift
//  Statemanagement
//
//  Created by Tom Lai on 4/17/25.
//

import SwiftUI

struct ContentView: View {
  // @State var count: Int = 0 This is local to this view.
  @ObservedObject var state: AppState

  var body: some View {
    NavigationView {
      List {
          NavigationLink(destination: CounterView(state: state)) {
          Text("Counter demo")
        }
        NavigationLink(destination: EmptyView()) {
          Text("Favorite primes") // this is in part 2
        }
      }
      .navigationBarTitle("State management")
    }
  }
}

private func ordinal(_ n: Int) -> String {
  let formatter = NumberFormatter()
  formatter.numberStyle = .ordinal
  return formatter.string(for: n) ?? ""
}

//BindableObject

import Combine

class AppState: ObservableObject {
  @Published var count = 0
}

struct CounterView: View {
  @ObservedObject var state: AppState
    @State var isPrimeModalShown = false
  var body: some View {
    VStack {
        HStack {
            Button(action: { state.count -= 1 }) {
                Text("-")
            }
            Text("\(state.count)")
            Button(action: { state.count += 1 }) {
                Text("+")
            }
        }
        Button(action: {isPrimeModalShown.toggle()}) {
            Text("Is this prime")
        }
        Button(action: {}) {
            Text("What is the \(ordinal(state.count)) prime")
        }
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .sheet(isPresented: $isPrimeModalShown) {
        isPrimeModalView(state: state)
        
    }

  }
}


struct isPrimeModalView: View {
    @ObservedObject var state: AppState
    var body: some View {
        if isPrime(state.count) {
            Text("it prime! \(self.state.count)")
        }
        
    }
}

#Preview {
    ContentView(state: AppState())
//    CounterView(state: AppState())
}
