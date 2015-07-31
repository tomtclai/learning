//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

struct Vector {
    var x: Double
    var y: Double
    
    init() {
        x = 0
        y = 0
    }
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    func vectorByAddingVector(vector: Vector) -> Vector {
        return Vector(x: x + vector.x
                    , y: y + vector.y)
    }
    
    func vectorByAddingVector(vector: Vector, numberOfTimes: Int) -> Vector {
        return Vector(x: x + (Double(numberOfTimes) * vector.x)
                    , y: y + (Double(numberOfTimes) * vector.y))
    }
}

func +(left: Vector, right: Vector) -> Vector {
    return left.vectorByAddingVector(right)
}

func *(left: Vector, right: Double) -> Vector {
    return Vector(x:left.x * right, y:left.y * right)
}


let gravity = Vector(x: 0.0, y: -9.8)

let twoGs = gravity*2

let threeGs = gravity*3


class Particle {
    var position: Vector
    var velocity: Vector
    var acceleration: Vector
    
    init(position: Vector) {
        self.position = position
        self.velocity = Vector()
        self.acceleration = Vector()
    }
    
    convenience init () {
        self.init(position: Vector())
    }
    
    func tick(dt: NSTimeInterval) {
        velocity = velocity + (acceleration * dt)
        position = position + (velocity * dt)
        position.y = (max(0, position.y))
    }
}

class Simulation {
    var particles: [Particle] = []
    var time: NSTimeInterval = 0.0
    
    func addParticle(particle: Particle) {
        particles.append(particle)
    }
    
    func tick(dt: NSTimeInterval) {
        for particle in particles {
            particle.acceleration = particle.acceleration + gravity
            particle.tick(dt)
            particle.acceleration = Vector()
            particle.position.y
        }
        time += dt;
        particles = particles.filter{ particles in
            let live = particle.position.y > 0.0
            if !live {
                println("Particle terminated at time \(self.time)")
            }
            return live
        }
    }
}
