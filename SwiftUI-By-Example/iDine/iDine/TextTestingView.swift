//
//  TextTestingView.swift
//  Chapter 3 Static Text

//  Created by Tom Lai on 4/13/25.
//


import SwiftUI

struct TextTestingView: View {
    var message1: AttributedString {
        var result = AttributedString("Hello")
        result.font = .largeTitle
        result.foregroundColor = .white
        result.backgroundColor = .red
        result.underlineStyle = Text.LineStyle(pattern: .solid, color: .white)
        return result
    }
    var message2: AttributedString {
        let string = " world world world .... . . . . . . "
        var result = AttributedString()
        
        for (index, letter) in string.enumerated() {
            var letterString = AttributedString(String(letter))
            letterString.baselineOffset = sin(Double(index))*5
            result += letterString
        }
        result.font = .largeTitle
        result.foregroundColor = .blue
        result.backgroundColor = .green
        result.underlineStyle = Text.LineStyle(pattern: .dot, color: .white)
        
        return result
    }
    
    var link: AttributedString {
        var result = AttributedString("Learn swift here")
        result.font = .largeTitle
        result.link = URL(string: "https://www.hackingwithswift.com")
        return result
    }
    
    var date: AttributedString {
        var result = Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide).attributedStyle)
        result.foregroundColor = .secondary
        
        let weekday = AttributeContainer.dateField(.weekday)
        let weekdayStyling = AttributeContainer.foregroundColor(.primary)
        result.replaceAttributes(weekday, with: weekdayStyling)
        return result
    }
    
    var name: AttributedString {
        let components = PersonNameComponents(givenName: "Taylor", familyName: "Swift")
        var result = components.formatted(.name(style: .long).attributed)
        let familyName = AttributeContainer.personNameComponent(.familyName)
        let familyNameStyling = AttributeContainer.font(.headline)
        result.replaceAttributes(familyName, with: familyNameStyling)
        return result
    }
    
    var measurements: AttributedString {
        var amount = Measurement(value: 200, unit: UnitLength.kilometers)
        var result = amount.formatted(.measurement(width: .wide).attributed)
        let distanceStyling = AttributeContainer.font(.title)
        let distance = AttributeContainer.measurement(.value)
        result.replaceAttributes(distance, with: distanceStyling)
        return result
    }
    
    
    let alignments: [TextAlignment] = [.leading, .center, .trailing]
    @State private var alignment = TextAlignment.leading
    @State private var ingredients = [String]()
    @State private var textKerningTrackingAmmount = 50.0
    var body: some View {
        List {
            // 10 min timer.
            Text(Date.now.addingTimeInterval(600), style:.timer)
            Text("ffi").font(.custom("AmericanTypewriter", size: 72))
                .kerning(textKerningTrackingAmmount)
            Text("ffi").font(.custom("AmericanTypewriter", size: 72))
                .tracking(textKerningTrackingAmmount)
            Slider(value: $textKerningTrackingAmmount, in: -10...100) {
                Text("spacing between chars")
            }
            Button("Add ingredients") {
                let possibles = ["Egg", "Sausage", "Bacon", "Spam"]
                
                if let newIngredient = possibles.randomElement() {
                    ingredients.append(newIngredient)
                }
            }
            Text(ingredients, format:.list(type: .and))
            
            Picker("Text Alighment", selection: $alignment) {
                ForEach(alignments, id: \.self) { alignment in
                    Text(String(describing: alignment))
                }
            }
            
            VStack{
                Text("This is some longer text that is limited to three lines maximum, so anything more than that will cause the text to clip. longer longer longer too long to fit")
                    .font(.largeTitle)
                    .multilineTextAlignment(alignment)
                    .frame(width: 300)
                
                Text(measurements)
                Text(name)
                Text(message1+message2)
                    .background(.yellow)
                // Attributed String stays attributed, modifiers dont work here.
                Text("This is shoter text.")
                    .lineLimit(6, reservesSpace: true)
                    .frame(width: 200)
                Text("This is some longer text that is limited to three lines maximum, so anything more than that will cause the text to clip. longer longer longer too long to fit")
                    .lineLimit(10, reservesSpace: true)
                    .padding()
                    .fontDesign(.none)
                    .fontWidth(.condensed) // fontWidth only works if font supports it.
                    .lineSpacing(10)
                    .font(.headline)
                    .background(.gray)
                    .foregroundStyle(.white.gradient)
                    .frame(width: 200)
                Text(link)
                Text(date)
            }
        }
    }
}

#Preview {
    TextTestingView()
}
