//
//  AddFood.swift
//  IJustAte
//
//  Created by Davidson Poole on 9/27/22.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct AddFood: AppIntent {

    static var title: LocalizedStringResource = "Add Food"
    static var description = IntentDescription("Add Food to Today's Log")

    @Parameter(title: "Food")
    var food: String? // change to entity later

    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$food) to log")
    }

    enum CustomDialog {
        case foodParameterPrompt
        case responseSuccess(String)
        case responseFailure(String)

        var asDialog: IntentDialog {
            switch self {
                case .foodParameterPrompt:
                    return IntentDialog("Specify a food to add to today's log")
                case .responseSuccess(let food):
                    return IntentDialog("Successfully added \(food) to today's log")
                case .responseFailure(let food):
                    return IntentDialog("Failed to add \(food) to today's log")
            }
        }
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let viewModel = CoreDataViewModel.shared
        
        guard let food = food else {
            throw $food.needsValueError("What food would you like to add?")
        }
        
        if let foodEntity: FoodEntity = viewModel.getFood(name: food) {
            print("Found \(food) in food list")
            viewModel.addToLog(food: foodEntity)
            return .result(dialog: CustomDialog.responseSuccess(food).asDialog)
        } else {
            print("Could not find \(food) in food list")
            return .result(dialog: CustomDialog.responseFailure(food).asDialog)
        }
        
    }
}

