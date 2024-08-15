//
//  ContentView.swift
//  HornerBibleReadingPlan
//
//  Created by Nicholas Villarreal on 8/14/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var readingPlan = ReadingPlan(jsonFile: "plan.json")
    @State var showInputDialog = false
    @State var inputText: String = ""
    
    #if os(iOS)
        let nextPlacement = ToolbarItemPlacement.navigationBarTrailing
        let prevPlacement = ToolbarItemPlacement.navigationBarLeading
    #else
        let nextPlacement = ToolbarItemPlacement.primaryAction
        let prevPlacement = ToolbarItemPlacement.secondaryAction
    #endif
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(readingPlan.today) { chapter in
                    Text(chapter.name)
                }
            }
            .navigationTitle("Day \(readingPlan.day)")
            .toolbar {
                ToolbarItem(placement: nextPlacement) {
                    Button("Next") {
                        readingPlan.setDay(newValue: readingPlan.day + 1)
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button("Goto") {
                        showInputDialog = true
                    }.alert("Enter Day", isPresented: $showInputDialog) {
                        TextField("Enter day", text: $inputText).keyboardType(.numberPad)
                        Button("Go") {
                            readingPlan.setDay(newValue: Int(inputText) ?? readingPlan.day)
                        }
                    } message: {
                        Text("Skip to any day in the plan")
                    }
                }
                ToolbarItem(placement: prevPlacement) {
                    Button("Previous") {
                        readingPlan.setDay(newValue: readingPlan.day - 1)
                    }
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
