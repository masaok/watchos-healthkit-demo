Creating a WatchOS app with SwiftUI that reads steps from HealthKit involves a few main steps:

1. **Setup**: Create a new WatchOS app with SwiftUI.
2. **Permissions**: Request permission to read steps from HealthKit.
3. **Query HealthKit**: Access the step count data.
4. **UI**: Display the step count in the SwiftUI interface.

Below is a step-by-step guide on how to create this app:

### 1. Setup

Create a new WatchOS app project in Xcode. Choose the WatchOS tab, and select the "Watch App for iOS App" template. You won't need an accompanying iOS app, so you can deselect that option.

### 2. Permissions

To use HealthKit, you need to add the HealthKit entitlement and request permission to read step data. 

1. Go to the Signing & Capabilities tab of your WatchKit Extension target. Press the "+" button and add the HealthKit entitlement.
2. In the `Info.plist` of the WatchKit Extension, add the following:
```xml
<key>NSHealthShareUsageDescription</key>
<string>We would like to read your step count data.</string>
```

### 3. Query HealthKit

In your WatchKit Extension, implement the code to query step count data:

```swift
import HealthKit

class HealthDataManager {
    let healthStore = HKHealthStore()
    let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: [], read: [stepCountType]) { (success, error) in
            completion(success)
        }
    }

    func fetchTodayStepCount(completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
}
```

### 4. UI

Finally, use SwiftUI to display the step count:

```swift
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
```

Once you've added these components, run your WatchOS app on a simulator or a physical device. Ensure that HealthKit data (steps in this case) is available on the target device or simulator. 

Note: Real devices often have more HealthKit data, while simulators might not have meaningful data unless you've added it manually.
