//
//  ContentView.swift
//  SwiftStorm
//
//  Created by Junaid Dawud on 10/12/24.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var swarm = Swarm()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                // Canvas drawing the agents
                Canvas { context, size in
                    for agent in swarm.agents {
                        var path = Path()
                        path.addArc(center: agent.position, radius: 3, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                        context.fill(path, with: .color(.white))
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)

                // SettingsView overlaid on top
                VStack {
                    Spacer()
                    SettingsView(swarm: swarm)
                        .padding()
                }
            }
            .onAppear {
                swarm.bounds = geometry.size
                swarm.initializeAgents()
                startSimulation()
            }
            .onDisappear {
                stopSimulation()
            }
        }
    }

    @State private var timer: Timer?

    func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            swarm.updateAllAgents()
        }
    }

    func stopSimulation() {
        timer?.invalidate()
    }
}

#Preview {
    ContentView()
}
