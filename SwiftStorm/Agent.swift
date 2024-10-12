//
//  Agent.swift
//  SwiftStorm
//
//  Created by Junaid Dawud on 10/12/24.
//


import SwiftUI

struct Agent: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var acceleration: CGVector
    var maxSpeed: CGFloat = 2.0
    var maxForce: CGFloat = 0.03

    mutating func update(bounds: CGSize) {
        // Update velocity
        velocity.dx += acceleration.dx
        velocity.dy += acceleration.dy

        // Limit speed
        let speed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
        if speed > maxSpeed {
            velocity.dx = (velocity.dx / speed) * maxSpeed
            velocity.dy = (velocity.dy / speed) * maxSpeed
        }

        // Update position
        position.x += velocity.dx
        position.y += velocity.dy

        // Reset acceleration
        acceleration = CGVector(dx: 0, dy: 0)

        // Handle edges
        if position.x < 0 { position.x = bounds.width }
        if position.x > bounds.width { position.x = 0 }
        if position.y < 0 { position.y = bounds.height }
        if position.y > bounds.height { position.y = 0 }
    }

    mutating func apply(force: CGVector) {
        acceleration.dx += force.dx
        acceleration.dy += force.dy
    }
}
