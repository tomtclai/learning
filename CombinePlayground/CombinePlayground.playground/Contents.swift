// https://www.youtube.com/watch?v=RysM_XPNMTw
import Foundation
import Combine

enum WeatherError: Error {
    case thingsJustHappen
}
let weatherPublisher = PassthroughSubject<Int, WeatherError>()


let anotherSubscriber = weatherPublisher.handleEvents { subscription in
    print("new subscription \(subscription)")
} receiveOutput: { output in
    print("new output \(output)")
} receiveCompletion: { (error) in
    print("new error \(error)")
} receiveCancel: {
    print("received cancel")
} receiveRequest: { (demand) in
    print("received request")
}.sink { (error) in
    print("received error \(error)")
} receiveValue: { (value) in
    print("received value \(value)")
}
let subscriber = weatherPublisher
    .filter{ $0 > 25}
    .sink { (error) in
        print("received error \(error)")
    } receiveValue: { value in
        print ("A summer day of \(value) C")
    }


weatherPublisher.send(10)
weatherPublisher.send(20)
weatherPublisher.send(24)
weatherPublisher.send(26)
weatherPublisher.send(28)
weatherPublisher.send(30)
weatherPublisher.send(completion: Subscribers.Completion<WeatherError>.failure(.thingsJustHappen))
weatherPublisher.send(18)




