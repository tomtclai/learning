/*:
 [Previous page](@previous)

 # Optimizing Collections in Swift
 ## by Károly Lőrentey
 
 Copyright © 2017 Károly Lőrentey
 
 Version 1.0 (2017-06-02)
 
 
 # Preface 
 
 
 On the surface level, this book is about making fast collection
 implementations. It presents many different solutions to the same simple
 problem, explaining each approach in detail and constantly trying to find new
 ways to push the performance of the next variation even higher than the last.
 
 But secretly, this book is really just a joyful exploration of the many tools
 Swift gives us for expressing our ideas. This book won't tell you how to
 ship a great iPhone app; rather it teaches you tools and techniques that
 will help you become better at expressing your ideas in the form of Swift code.
 
 The book has grown out of notes and source code I made in preparation for
 a talk I gave at the [dotSwift 2017 Conference][talk]. I ended up with so
 much interesting material I couldn't possibly fit into a single
 talk, so I made a book out of it. (You don't need to see the talk to understand
 the book, but the video is only 20 minutes or so, and dotSwift has done a great
 job with editing so that I almost pass for a decent presenter. Also, I'm sure
 you'll love my charming Hungarian accent!)
 
 [talk]: http://www.thedotpost.com/2017/01/karoly-lorentey-optimizing-swift-collections
 
 ## Who Is This Book For? 
 
 At face value, this book is for people who want to implement their own
 collection types, but its contents are useful for anyone who wants to learn
 more about some of the idiosyncratic language facilities that make Swift
 special. Getting used to working with algebraic data types, or knowing how to
 create *swifty* value types with copy-on-write reference-counted storage, will
 help you become a better programmer for everyday tasks too.
 
 This book assumes you're a somewhat experienced Swift programmer. You don't
 need to be an expert, though: if you're familiar with the basic syntax of the
 language and you've written, say, a thousand lines of Swift code, you'll be able to understand most
 of it just fine. If you need to get up to speed on Swift, I highly recommend
 another objc.io book, [*Advanced Swift*][AdvancedSwift] by Chris Eidhof, 
 Ole Begemann, and Airspeed Velocity. It picks up where Apple's [*The Swift
 Programming Language*][SwiftBook] left off, and it dives deeper into Swift's
 features, explaining how to use them in an idiomatic (aka *swifty*) way.
 
 [SwiftBook]: https://developer.apple.com/swift/resources/
 [AdvancedSwift]: https://www.objc.io/books/advanced-swift/
 
 Most of the code in this book will work on any platform that can run Swift
 code. In the couple of cases where I needed to use features that are
 currently available in neither the standard library nor the cross-platform
 Foundation framework, I included platform-specific code supporting Apple
 platforms and GNU/Linux. The code was tested using the Swift 4 compiler that
 shipped in Xcode 9.
 
 ## New Editions of This Book 
 
 From time to time, I may publish new editions of this book to fix bugs, to
 follow the evolution of the Swift language, or to add additional material.
 You'll be able to download these updates from the book's product page on
 [Gumroad]. You can also go there to download other variants of the book; the 
 edition you're currently reading is available in EPUB, PDF, and
 Xcode playground formats. (These are free to download as long as you're logged
 in with the Gumroad account you used to purchase the book.)
 
 [Gumroad]: https://gum.co/OptimizingCollections
 
 ## Related Work 
 
 I've set up a [GitHub repository][github] where you can find the full source
 code of all the algorithms explained in the text. This code is simply extracted
 from the book itself, so there's no extra information there, but it's nice to
 have the source available in a standalone package in case you want to
 experiment with your own modifications.
 
 [github]: https://github.com/objcio/OptimizingCollections
 
 You're welcome to use any code from this repository in your own apps, although
 doing so wouldn't necessarily be a good idea: the code is simplified to fit the
 book, so it's not quite production quality. Instead, I recommend you take a look at
 *[BTree]*, my elaborate ordered collections package for Swift. It includes a
 production-quality implementation of the most advanced data structure described
 in this book. It also provides tree-based analogues of the standard library's `Array`,
 `Set`, and `Dictionary` collections, along with a flexible `BTree` type for
 lower-level access to the underlying structure.
 
 [BTree]: https://github.com/lorentey/BTree
 
 *[Attabench]* is my macOS benchmarking app for generating microbenchmark
 charts. The actual benchmarks from this book are included in the app by
 default. I highly recommend you check out the app and try repeating my measurements
 on your own computer. You may even get inspired to experiment with benchmarking
 your own algorithms.
 
 [Attabench]: https://github.com/lorentey/Attabench
 
 ## Contacting the Author 
 
 If you find a mistake, please help me fix it by [filing a bug about it in the
 book's GitHub repository][bugreport]. For other feedback, feel free to contact
 me on Twitter; my handle is [*@lorentey*][twitter]. If you prefer email, write
 to [*collections@objc.io*](mailto:collections@objc.io).
 
 [bookrepo]: https://github.com/objcio/OptimizingCollections
 [bugreport]: https://github.com/objcio/OptimizingCollections/issues/new
 [twitter]: https://twitter.com/lorentey
 
 
 ## How to Read This Book 
 
 I'm not breaking new ground here; this book is intended to be read from front
 to back. The text often refers back to a solution from a previous chapter,
 assuming the reader has, uhm, done their job. That said, feel free to read the
 chapters in any order you want. But try not to get upset if it makes less sense
 that way, OK?
 
 This book contains lots of source code. In the Xcode playground version of the
 book, almost all of it is editable and your changes are immediately applied.
 Feel free to experiment with modifying the code — sometimes the best way to
 understand it is to see what happens when you change it.
 
 For instance, here's a useful extension method on `Sequence` that shuffles its
 elements into random order. It has a couple of FIXME comments describing
 problems in the implementation. Try modifying the code to fix these issues!
*/
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin // for arc4random_uniform()
#elseif os(Linux)
import Glibc // for random()
#endif

extension Sequence {
    func shuffled() -> [Iterator.Element] {
        var contents = Array(self)
        for i in 0 ..< contents.count - 1 {
            #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                // FIXME: This breaks if the array has 2^32 elements or more.
                let j = i + Int(arc4random_uniform(UInt32(contents.count - i)))
            #elseif os(Linux)
                // FIXME: This has modulo bias. Also, `random` should be seeded by calling `srandom`.
                let j = i + random() % (contents.count - i)
            #endif
            contents.swapAt(i, j)
        }
        return contents
    }
}
/*:
 To illustrate what happens when a piece of code is executed, I sometimes
 show the result of an expression. As an example, let's try running `shuffled` to
 demonstrate that it returns a new random order every time it's run:
*/
(0 ..< 20).shuffled()
(0 ..< 20).shuffled()
(0 ..< 20).shuffled()
/*:
 In the playground version, all this output is generated live, so you'll get a
 different set of shuffled numbers every time you rerun the page.
 
 ## Acknowledgments 
 
 This book wouldn't be the same without the wonderful feedback I received from
 readers of its earlier drafts. I'm especially grateful to *Chris Eidhof*; he
 spent considerable time reviewing early rough drafts of this book, and he
 provided detailed feedback that greatly improved the final result.
 
 *Ole Begemann* was the book's technical reviewer; no issue has escaped his
 meticulous attention. His excellent notes made the code a lot swiftier, and he uncovered amazing details I would've never found on my own.
 
 *Natalye Childress*'s top-notch copy editing turned my clumsy and broken
 sentences into an actual book written in proper English. Her contribution
 can't be overstated; she fixed multiple things in almost every paragraph.
 
 Naturally, these nice people are not to be blamed for any issues that remain in
 the text; I'm solely responsible for those.
 
 I'd be amiss not to mention *Floppy*, my seven-year-old beagle: her ability to
 patiently listen to me describing various highly technical problems contributed
 a great deal to their solutions. Good girl!

 [Next page](@next)
*/