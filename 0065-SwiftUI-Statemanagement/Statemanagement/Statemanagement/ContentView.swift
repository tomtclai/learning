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
        NavigationLink(destination: FavoriePrimesView(state: state)) {
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
  @Published var favoritePrimes: [Int] = []
}

struct CounterView: View {
  @ObservedObject var state: AppState
  @State var isPrimeModalShown = false
  @State var alertNthPrime: Int?
  @State var isNthPrimeButtonDisabled = false
  
  fileprivate func nthPrimeButtonAction() {
    isNthPrimeButtonDisabled = true
    nthPrime(state.count) { fullNumber in
      alertNthPrime = fullNumber
      isNthPrimeButtonDisabled = false
    }
  }
  
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
      Button(action: nthPrimeButtonAction) {
        Text("What is the \(ordinal(state.count)) prime")
          .disabled(isNthPrimeButtonDisabled)
      }
    }
    .font(.title)
    .navigationBarTitle("Counter demo")
    .sheet(isPresented: $isPrimeModalShown) {
      isPrimeModalView(state: state)
      
    }
    
    .alert(item: $alertNthPrime) { item in
      Alert(title:Text("\(ordinal(state.count)) prime is \(item)"))
    }
  }
}

extension Int: @retroactive Identifiable {
  public var id: Int { self }
}


struct isPrimeModalView: View {
  @ObservedObject var state: AppState
  var body: some View {
    VStack {
      if isPrime(state.count) {
        Text("it's prime")
        
        if state.favoritePrimes.contains(state.count) {
          Button(action:{
            state.favoritePrimes.removeAll(where: {$0 == state.count})
            
          }) {
            Text("Remove from favorites")
          }
        } else {
          Button(action:{
            state.favoritePrimes.append(state.count)
          }) {
            Text("Save to favorites")
          }
        }
        
      } else {
        Text("Naur")
      }
    }
  }
}
func isPrime(_ num: Int) -> Bool {
  if num <= 1 { return false }
  if num <= 3 { return false }
  for i in 2...Int(sqrtf(Float(num))) {
    if num % i == 0 { return false }
  }
  return true
}
#Preview {
  ContentView(state: AppState())
  //    CounterView(state: AppState())
}

func nthPrime(_ n: Int, callback: @escaping (Int?) -> Void) -> Void {
  wolframAlpha(query: "prime \(n)") { result in
    callback(result.flatMap{ $0.queryresult.pods.first(where: {$0.primary == .some(true)})?.subpods.first?.plaintext }.flatMap(Int.init))
  }
}



struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult
  
  struct QueryResult: Decodable {
    let pods: [Pod]
    
    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]
      
      struct SubPod: Decodable {
        let plaintext: String
      }
    }
  }
}
func wolframAlpha(
  query: String,
  callback: @escaping (WolframAlphaResult?) -> Void
) {
  var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
  components.queryItems = [
    URLQueryItem(name: "input",  value: query),
    URLQueryItem(name: "format", value: "plaintext"),
    URLQueryItem(name: "output", value: "JSON"),
    URLQueryItem(name: "appid",  value: wolframAlphaApiKey)
  ]
  
  URLSession.shared.dataTask(with: components.url(relativeTo: nil)!) { data, _, _ in
    let result = data.flatMap { try? JSONDecoder().decode(WolframAlphaResult.self, from: $0) }
    callback(result)
  }.resume()
}


struct FavoriePrimesView: View {
  @ObservedObject var state: AppState
  var body: some View {
    List {
      ForEach(state.favoritePrimes) { prime in
        Text("\(prime)")
      }
      .onDelete { indexSet in
        for i in indexSet {
          state.favoritePrimes.remove(at: i)
        }
      }
    }
    .navigationTitle(Text("Favorite Primes"))
  }
}
