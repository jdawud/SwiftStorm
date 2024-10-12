//
//  Swarm.swift
//  SwiftStorm
//
//  Created by Junaid Dawud on 10/12/24.
//

import SwiftUI

class Swarm: ObservableObject {
    @Published var agents: [Agent] = []
    var bounds: CGSize = .zero

    // Existing properties...
    var separationDistance: CGFloat = 25.0
    var alignmentDistance: CGFloat = 50.0
    var cohesionDistance: CGFloat = 50.0

    var separationWeight: CGFloat = 1.5
    var alignmentWeight: CGFloat = 1.0
    var cohesionWeight: CGFloat = 1.0

    init(numberOfAgents: Int = 150) {
        // Agents will be initialized once bounds are set
    }

    func initializeAgents() {
        agents.removeAll()
        for _ in 0..<150 {
            let position = CGPoint(
                x: CGFloat.random(in: 0...bounds.width),
                y: CGFloat.random(in: 0...bounds.height)
            )
            let velocity = CGVector(
                dx: CGFloat.random(in: -1...1),
                dy: CGFloat.random(in: -1...1)
            )
            let agent = Agent(position: position, velocity: velocity, acceleration: .zero)
            agents.append(agent)
        }
    }

    func updateAllAgents() {
        guard bounds != .zero else { return }

        for i in agents.indices {
            var agent = agents[i]

            let separation = computeSeparation(agent: agent)
            let alignment = computeAlignment(agent: agent)
            let cohesion = computeCohesion(agent: agent)

            agent.apply(force: separation)
            agent.apply(force: alignment)
            agent.apply(force: cohesion)

            agent.update(bounds: bounds)
            agents[i] = agent
        }
    }

    func updateAllAgents(bounds: CGSize) {
            for i in agents.indices {
                var agent = agents[i]

                let separation = computeSeparation(agent: agent)
                let alignment = computeAlignment(agent: agent)
                let cohesion = computeCohesion(agent: agent)

                agent.apply(force: separation)
                agent.apply(force: alignment)
                agent.apply(force: cohesion)

                agent.update(bounds: bounds)
                agents[i] = agent
            }
        }

        private func computeSeparation(agent: Agent) -> CGVector {
            var steer = CGVector.zero
            var count: CGFloat = 0

            for other in agents {
                if other.id == agent.id { continue }
                let distance = hypot(other.position.x - agent.position.x, other.position.y - agent.position.y)
                if distance > 0 && distance < separationDistance {
                    var diff = CGVector(
                        dx: agent.position.x - other.position.x,
                        dy: agent.position.y - other.position.y
                    )
                    let distanceSquared = distance * distance
                    diff.dx /= distanceSquared
                    diff.dy /= distanceSquared
                    steer.dx += diff.dx
                    steer.dy += diff.dy
                    count += 1
                }
            }

            if count > 0 {
                steer.dx /= count
                steer.dy /= count
            }

            let magnitude = sqrt(steer.dx * steer.dx + steer.dy * steer.dy)
            if magnitude > 0 {
                steer.dx = (steer.dx / magnitude) * agent.maxSpeed - agent.velocity.dx
                steer.dy = (steer.dy / magnitude) * agent.maxSpeed - agent.velocity.dy
                // Limit force
                let force = sqrt(steer.dx * steer.dx + steer.dy * steer.dy)
                if force > agent.maxForce {
                    steer.dx = (steer.dx / force) * agent.maxForce
                    steer.dy = (steer.dy / force) * agent.maxForce
                }
            }

            steer.dx *= separationWeight
            steer.dy *= separationWeight

            return steer
        }

        private func computeAlignment(agent: Agent) -> CGVector {
            var sum = CGVector.zero
            var count: CGFloat = 0

            for other in agents {
                if other.id == agent.id { continue }
                let distance = hypot(other.position.x - agent.position.x, other.position.y - agent.position.y)
                if distance > 0 && distance < alignmentDistance {
                    sum.dx += other.velocity.dx
                    sum.dy += other.velocity.dy
                    count += 1
                }
            }

            if count > 0 {
                sum.dx /= count
                sum.dy /= count

                // Steer towards the average velocity
                sum.dx = (sum.dx / sqrt(sum.dx * sum.dx + sum.dy * sum.dy)) * agent.maxSpeed
                sum.dy = (sum.dy / sqrt(sum.dx * sum.dx + sum.dy * sum.dy)) * agent.maxSpeed

                var steer = CGVector(
                    dx: sum.dx - agent.velocity.dx,
                    dy: sum.dy - agent.velocity.dy
                )

                // Limit force
                let force = sqrt(steer.dx * steer.dx + steer.dy * steer.dy)
                if force > agent.maxForce {
                    steer.dx = (steer.dx / force) * agent.maxForce
                    steer.dy = (steer.dy / force) * agent.maxForce
                }

                steer.dx *= alignmentWeight
                steer.dy *= alignmentWeight

                return steer
            } else {
                return CGVector.zero
            }
        }

        private func computeCohesion(agent: Agent) -> CGVector {
            var sum = CGPoint.zero
            var count: CGFloat = 0

            for other in agents {
                if other.id == agent.id { continue }
                let distance = hypot(other.position.x - agent.position.x, other.position.y - agent.position.y)
                if distance > 0 && distance < cohesionDistance {
                    sum.x += other.position.x
                    sum.y += other.position.y
                    count += 1
                }
            }

            if count > 0 {
                sum.x /= count
                sum.y /= count

                // Steer towards the average position
                var steer = CGVector(
                    dx: sum.x - agent.position.x,
                    dy: sum.y - agent.position.y
                )

                steer.dx = (steer.dx / sqrt(steer.dx * steer.dx + steer.dy * steer.dy)) * agent.maxSpeed - agent.velocity.dx
                steer.dy = (steer.dy / sqrt(steer.dx * steer.dx + steer.dy * steer.dy)) * agent.maxSpeed - agent.velocity.dy

                // Limit force
                let force = sqrt(steer.dx * steer.dx + steer.dy * steer.dy)
                if force > agent.maxForce {
                    steer.dx = (steer.dx / force) * agent.maxForce
                    steer.dy = (steer.dy / force) * agent.maxForce
                }

                steer.dx *= cohesionWeight
                steer.dy *= cohesionWeight

                return steer
            } else {
                return CGVector.zero
            }
        }
}

