//
//  IntentHandler.swift
//  CalorieCounterIntent
//
//  Created by Davidson Poole on 9/2/22.
//

import Intents

class IntentHandler: INExtension, AddFoodIntentHandling {
    
    var viewModel = CoreDataViewModel.shared
    
    override func handler(for intent: INIntent) -> Any {
        
        guard intent is AddFoodIntent else {
            fatalError("Unknown intent type: \(intent)")
        }
        return self
    }
    
    func handle(intent: AddFoodIntent, completion: @escaping (AddFoodIntentResponse) -> Void) {
        guard let food = intent.food else {
            completion(AddFoodIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        if let foodEntity: FoodEntity = viewModel.getFood(name: food) {
            print("Found \(food) in food list")
            viewModel.addToLog(food: foodEntity)
            completion(AddFoodIntentResponse.success(food: food))
        } else {
            print("Could not find \(food) in food list")
            completion(AddFoodIntentResponse.failure(food: food))
        }
        
    }
    
    func resolveFood(for intent: AddFoodIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let food = intent.food {
            completion(INStringResolutionResult.success(with: food))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    public func confirm(intent: AddFoodIntent, completion: @escaping (AddFoodIntentResponse) -> Void) {
        completion(AddFoodIntentResponse(code: .ready, userActivity: nil))
    }
    
}
