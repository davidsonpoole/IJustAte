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
        print("got to handler")
        return self
    }
    
    func handle(intent: AddFoodIntent, completion: @escaping (AddFoodIntentResponse) -> Void) {
        guard let foods = intent.foods else {
            completion(AddFoodIntentResponse(code: .failure, userActivity: nil))
            return
        }
        print("handle method")
        
        var foodEntities = [FoodEntity]()
        var foodSuccesses = [String]()
        var foodErrors = [String]()
        for food in foods {
            if let foodEntity: FoodEntity = viewModel.getFood(name: food) {
                print("Found \(food) in food list")
                foodEntities.append(foodEntity)
                foodSuccesses.append(food)
            } else {
                print("Could not find \(food) in food list")
                foodErrors.append(food)
            }
        }
        viewModel.addToLog(foods: Set(foodEntities))
        if (!foodErrors.isEmpty) {
            completion(AddFoodIntentResponse.failure(foods: foodErrors))
        } else {
            completion(AddFoodIntentResponse.success(foods: foodSuccesses))
        }
        
    }
    
    func resolveFoods(for intent: AddFoodIntent, with completion: @escaping ([INStringResolutionResult]) -> Void) {
        if let foods = intent.foods {
            let mappedFoods: [INStringResolutionResult] = foods.map { food in
                INStringResolutionResult.success(with: food)
            }
            completion(mappedFoods)
        } else {
            completion([INStringResolutionResult.needsValue()])
        }
    }
    
    public func confirm(intent: AddFoodIntent, completion: @escaping (AddFoodIntentResponse) -> Void) {
        completion(AddFoodIntentResponse(code: .ready, userActivity: nil))
    }
    
}
