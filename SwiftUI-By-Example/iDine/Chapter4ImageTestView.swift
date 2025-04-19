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
                AnimatedImage(systemName: "waveform")
                AnimatedImage(systemName: "chart.bar.fill")
                AnimatedImage(systemName: "aqi.low")
                AnimatedImage(systemName: "wifi")
                Image(systemName: "wifi", variableValue: 0.5)
                    .font(.system(size: 60))
                Image(systemName: "person.3.sequence.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        .linearGradient(colors: [.red, .black], startPoint: .top, endPoint: .bottomTrailing),
                        .linearGradient(colors: [.green, .black], startPoint: .top, endPoint: .bottomTrailing),
                        .linearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottomTrailing))
                    .font(.system(size: 60))
                Image(systemName: "person.3.sequence.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue, .green, .red)
                    .font(.system(size: 60))
                Image(systemName: "theatermasks")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.blue)
                    .font(.system(size: 80))
                AsyncImage(url: URL(string: "https://hws.dev/paul3.jpg")) {
                    phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                    case .failure(let error):
                        Color.red
                    @unknown default:
                        Color.red
                    }
                }
                AsyncImage(url: URL(string: "https://hws.dev/paul2.jpg")) {
                    image in image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                ZStack{
                    ContainerRelativeShape()//only works in widgets
                        .inset(by: 10)
                        .fill(.blue)
                    Text("Hello")
                        .font(.title)
                }
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                AnimatedText(string: "Hello", fontSize: 64)
                AnimatedRecgtangle()
                AnimatedTrimCircle()
                // Before
                ZStack{
                    Circle().fill(.orange)
                    Circle().strokeBorder(.red, lineWidth: 20)
                }
                .frame(width: 100, height: 100)
                // After: one line using extension
                Circle()
                    .fill(.orange, strokeBorder: .blue, lineWidth: 20)
                    .frame(width: 100, height: 100)
                .frame(width: 100, height: 100)
                Triangle()
                    .fill(.orange, strokeBorder: .blue, lineWidth: 20)
                    .frame(width: 120, height: 120)

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

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self.stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self.strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

struct Triangle: Shape {              // NOT InsettableShape
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}

#Preview {
    Chapter4ImageTestView()
}
struct AnimatedText: View {
    @State private var animatedFontSize: CGFloat = 0
    let string: String
    let fontSize: CGFloat
    var body: some View {
        Text(string)
            .font(.system(size: animatedFontSize))
            .animation(.linear(duration: 2).repeatForever(autoreverses: true),
                       value:animatedFontSize
            )
            .onAppear(){
                animatedFontSize = fontSize
            }
            
    }
}
struct AnimatedRecgtangle: View {
    @State private var end: CGFloat = 0

    var body: some View {
        Rectangle()
            .trim(from: 0, to: end)
            .stroke(.red, lineWidth: 20)
            .frame(width: 80, height: 80)
            .animation(
                .linear(duration: 2).repeatForever(autoreverses: true),
                value: end
            )
            .onAppear {
                end = 1
            }
    }
}
struct AnimatedImage: View {
    let systemName: String
    @State private var variableValue: CGFloat = 0
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {
        Image(systemName: systemName, variableValue: variableValue)
            .font(.system(size: 60))
            .onReceive(timer) { _ in
                variableValue += 0.005
                if variableValue > 1 {
                    variableValue = 0
                }
            }
    }
}
struct AnimatedTrimCircle: View {
    @State private var end: CGFloat = 0          // animation target

    var body: some View {
        Circle()
            .trim(from: 0, to: end)              // animate this
            .animation(
                .linear(duration: 2)
                    .repeatForever(autoreverses: true),
                value: end
            )
            .onAppear {                          // kick it off
                end = 1
            }
    }
}
