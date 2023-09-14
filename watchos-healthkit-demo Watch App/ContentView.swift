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
                print("button pressed")
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
                print("Authorization granted")
                manager.fetchTodayStepCount { newSteps in
                    print("newSteps: \(Int(newSteps))")
                    self.steps = newSteps
                }
            } else {
                print("Authorization denied or failed")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
