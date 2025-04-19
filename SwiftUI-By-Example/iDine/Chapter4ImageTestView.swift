//
//  Chapter4ImageTestView.swift
//  iDine
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI

struct Chapter4ImageTestView: View {
    
    var body: some View {
        let column = [GridItem(.adaptive(minimum: 100, maximum: 200))]
        ScrollView{
            LazyVGrid(columns: column) {
                Circle()
                    .stroke(.blue, lineWidth: 45)
                    .stroke(.green, lineWidth: 35)
                    .stroke(.yellow, lineWidth: 25)
                    .stroke(.orange, lineWidth: 15)
                    .stroke(.red, lineWidth: 5)
                    .frame(width: 150, height: 150)
                Circle()
                    .stroke(.red, lineWidth: 20)
                    .fill(.orange)
                    .frame(width: 150, height: 150)
                Capsule()
                    .fill(.green)
                    .frame(width:100, height: 50)
                RoundedRectangle(cornerRadius: 25)
                    .fill(.green)
                Rectangle()
                    .fill(.red)
                    .aspectRatio(contentMode: .fit)
                Text("Hacking with Swift")
                    .font(.system(size: 30))
                    .background(Circle()
                        .fill(.red)
                        .frame(width: 100, height: 100))
                Text("Hacking with Swift")
                    .font(.system(size: 30))
                    .background(Image(.strawberryCoolerThumb)
                        .resizable())
                Circle()
                    .strokeBorder(
                        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
                                       center: .center,
                                        startAngle: .zero,
                                        endAngle:  .degrees(360)),
                        lineWidth: 30
                    )
                Circle()
                    .fill(
                        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
                                       center: .center)
                    )
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple]), center: .center, startRadius: 1, endRadius: 60)
                    )
                Text("Hello world")
                    .padding()
                    .foregroundStyle(.black)
                    .font(.largeTitle)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .blue, .gray]), startPoint: .leading, endPoint: .trailing))
                Rectangle().fill(.blue.gradient)
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .renderingMode(.original)
                    .resizable(resizingMode: .stretch)
                    .foregroundStyle(.blue)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                Image(systemName: "cloud.sun.rain.fill")
                    .renderingMode(.original)
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .background(.black)
                    .frame(height: 200)
                    .clipShape(Circle())
                Image(systemName: "moon.stars.fill")
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                Image(systemName: "cloud.heavyrain.fill")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    
                Image(.pepperoniPizza)
                Image(.dog)
            }
        }
    }
}

struct Chapter4ImageTilingView: View {
    
    var body: some View {
        Image(.cornOnTheCob)
            .resizable(capInsets: EdgeInsets(top: 30, leading: 150, bottom: 30, trailing: 150),
                       resizingMode: .tile)
    }
}

#Preview {
    Chapter4ImageTestView()
}
