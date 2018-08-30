//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

struct Vector: Printable {
    var x: Double
    var y: Double
    var length: Double {
            return sqrt(x*x + y*y)
    }

    var description: String {
        return "(\(x), \(y))"
    }

    var angle: Double {
        return atan2(y, x)
    }

    init() {
        x = 0
        y = 0
    }

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    func vectorByAddingVector(vector: Vector) -> Vector {
        return Vector(x: x + vector.x, y: y + vector.y)
    }

    func vectorByAddingVector(vector: Vector, numberOfTimes: Int) -> Vector {
        return Vector(x: x + (Double(numberOfTimes) * vector.x), y: y + (Double(numberOfTimes) * vector.y))
    }

}

func +(left: Vector, right: Vector) -> Vector {
    return left.vectorByAddingVector(right)
}

func *(left: Vector, right: Double) -> Vector {
    return Vector(x: left.x * right, y: left.y * right)
}

let gravity = Vector(x: 0.0, y: -9.8)

let twoGs = gravity*2
println(gravity)
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
        velocity.y
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
        time += dt
        // this is a closure. more on this in Chapter 15
        particles = particles.filter { particle in
            let live = particle.position.y > 0.0
            if !live {
                println("Particle terminated at time \(self.time)")
            }
            return live
        }
    }
}

let simulation = Simulation()

class Rocket: Particle {
    let thrust: Double
    var thrustTimeRemaining: NSTimeInterval
    let direction = Vector(x: 0, y: 1)
    let parachuteDeceleration = 9.8

    convenience init(thrust: Double, thrustTime: NSTimeInterval) {
        self.init(position: Vector(), thrust: thrust, thrustTime: thrustTime)
    }
    init(position: Vector, thrust: Double, thrustTime: NSTimeInterval) {
        self.thrust = thrust
        self.thrustTimeRemaining = thrustTime
        super.init(position: position)
    }

    override func tick(dt: NSTimeInterval) {
        if thrustTimeRemaining > 0.0 {
            let thrustTime = min(dt, thrustTimeRemaining)
            let thrustToApply = thrust * thrustTime
            let thrustForce = direction * thrustToApply
            acceleration = acceleration + thrustForce
            super.velocity.y

            thrustTimeRemaining -= thrustTime
        } else {
            // Safe landing
            if (velocity.y < 0) && (position.y < 300) {
                velocity = velocity * 0.1
            }
        }
        super.tick(dt)
    }
}

let rocket = Rocket(thrust: 10.0, thrustTime: 60)

simulation.addParticle(rocket)

while simulation.particles.count > 0 &&
      simulation.time < 500 {
        simulation.tick(1.0)
}
