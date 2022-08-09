//
//  SettingsView.swift
//  GameOfLife
//
//  Created by Kevin Roebuck on 4/25/22.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SettingsView: View {
    @ObservedObject var game: GameViewModel
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.locale = Locale.current
        
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    @State private var isEditing = false

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Width:")
                    TextField(
                        "\(game.gridWidth)",
                        value: $game.gridWidth,
                        formatter: numberFormatter
                    ) { isEditing in
                        self.isEditing = isEditing
                    }
                    .keyboardType(.numberPad)
                    if self.isEditing {
                        Button("Submit") {
                            UIApplication.shared.endEditing() // Call to dismiss keyboard
                            self.isEditing = false
                        }
                    } else {
                        Stepper("",
                                value: $game.gridWidth,
                                in: 1...100,
                                step: 1)
                    }
                }
                HStack {
                    Text("Height:")
                    TextField("\(game.gridHeight)",
                              value: $game.gridHeight,
                              formatter: numberFormatter)
                        .keyboardType(.numberPad)
                    Stepper("",
                            value: $game.gridHeight,
                            in: 1...100,
                            step: 1)
                }
//                Stepper("Width: \(game.gridWidth)",
//                        value: $game.gridWidth,
//                        in: 1...100,
//                        step: 1)
//                Stepper("Height: \(game.gridHeight)",
//                        value: $game.gridHeight,
//                        in: 1...100,
//                        step: 1)
            } header: {
                Text("Grid size")
            }
            Section {
                Stepper("Timer Interval: \(game.timerInterval, specifier: "%g")",
                        value: $game.timerInterval,
                        in: 0.05...1.00,
                        step: 0.05)
                Toggle("Toroidal topology", isOn: $game.isToroidal)
            } header: {
                Text("Misc.")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(game: GameViewModel())
    }
}
