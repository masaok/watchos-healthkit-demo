//
//  ContentView.swift
//  watchos-healthkit-demo Watch App
//

import SwiftUI

struct ContentView: View {
    @State private var steps: Double = 0
    let manager = HealthDataManager()
    
    var body: some View {
        VStack {
            Text("Steps Today")
                .font(.headline)
            Text("\(Int(steps))")
                .font(.largeTitle)
                .padding()
            Button("Refresh") {
                loadSteps()
            }
            .padding()
        }
        .onAppear {
            loadSteps()
        }
    }
    
    func loadSteps() {
        manager.requestAuthorization { success in
            if success {
                manager.fetchTodayStepCount { newSteps in
                    self.steps = newSteps
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
