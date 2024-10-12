//
//  SettingsView.swift
//  SwiftStorm
//
//  Created by Junaid Dawud on 10/12/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var swarm: Swarm

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Separation")
                    .foregroundColor(.red)
                Slider(value: $swarm.separationWeight, in: 0...3, step: 0.1)
                    .accentColor(.red)
            }

            HStack {
                Text("Alignment")
                    .foregroundColor(.green)
                Slider(value: $swarm.alignmentWeight, in: 0...3, step: 0.1)
                    .accentColor(.green)
            }

            HStack {
                Text("Cohesion")
                    .foregroundColor(.blue)
                Slider(value: $swarm.cohesionWeight, in: 0...3, step: 0.1)
                    .accentColor(.blue)
            }

            HStack(spacing: 20) {
                Button(action: resetSwarm) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(8)
                }
                Button(action: addAgent) {
                    Text("Add Agent")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.7))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .border(Color.red)
        .cornerRadius(12)
        .padding(.bottom, 20)
    }

    func resetSwarm() {
        swarm.initializeAgents()
    }

    func addAgent() {
        let position = CGPoint(
            x: swarm.bounds.width / 2,
            y: swarm.bounds.height / 2
        )
        let velocity = CGVector(
            dx: CGFloat.random(in: -1...1),
            dy: CGFloat.random(in: -1...1)
        )
        let agent = Agent(position: position, velocity: velocity, acceleration: .zero)
        swarm.agents.append(agent)
    }
}




