//
//  EatingCaloriesView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 12/16/24.
//


import SwiftUI

struct EatingCaloriesView: View {
    @State private var calorieInput: String = ""
    @State private var calorieEntries: [CalorieEntry] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Input Section
                HStack {
                    TextField("Enter calories", text: $calorieInput)
                        
                     
                    
                    Button(action: addCalorieEntry) {
                        Text("Add")
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(calorieInput.isEmpty)
                }
                .padding()
                
                // Calorie List
                List {
                    ForEach(calorieEntries) { entry in
                        HStack {
                            Text("\(entry.calories) kcal")
                            Spacer()
                            Text(entry.timestamp, style: .date)
                        }
                    }
                    .onDelete(perform: deleteEntry)
                }
                
                Spacer()
            }
            .navigationTitle("Eating Calories")
            .onAppear(perform: loadCalorieEntries)
        }
    }
    
    // MARK: - Functions
    
    private func addCalorieEntry() {
        guard let calories = Int(calorieInput) else { return }
        
        let newEntry = CalorieEntry(id: UUID(), calories: calories, timestamp: Date())
        calorieEntries.append(newEntry)
        saveCalorieEntries()
        calorieInput = ""
    }
    
    private func deleteEntry(at offsets: IndexSet) {
        calorieEntries.remove(atOffsets: offsets)
        saveCalorieEntries()
    }
    
    private func loadCalorieEntries() {
        if let data = UserDefaults.standard.data(forKey: "calorieEntries"),
           let savedEntries = try? JSONDecoder().decode([CalorieEntry].self, from: data) {
            calorieEntries = savedEntries
        }
    }
    
    private func saveCalorieEntries() {
        if let data = try? JSONEncoder().encode(calorieEntries) {
            UserDefaults.standard.set(data, forKey: "calorieEntries")
        }
    }
}

// MARK: - CalorieEntry Model

struct CalorieEntry: Identifiable, Codable {
    let id: UUID
    let calories: Int
    let timestamp: Date
}
