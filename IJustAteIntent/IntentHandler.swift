//
//  IntentHandler.swift
//  CalorieCounterIntent
//
//  Created by Davidson Poole on 9/2/22.
//

import Intents

class IntentHandler: INExtension, AddFoodIntentHandling {
    
    var viewContext = IJustAteViewModel.shared.container.viewContext
    
    override func handler(for intent: INIntent) -> Any {
        
        guard intent is AddFoodIntent else {
            fatalError("Unknown intent type: \(intent)")
        }
        return self
    }
    
    func handle(intent: AddFoodIntent, completion: @escaping (AddFoodIntentResponse) -> Void) {
        guard let foodName = intent.food else {
            completion(AddFoodIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        // MARK: Get matching Food Entity
        let foodRequest = FoodEntity.fetchRequest()
        foodRequest.sortDescriptors = FoodEntity.defaultSortDescriptors
        foodRequest.predicate = NSPredicate(format: "name =[c] %@", argumentArray: [foodName])
        var matchedFoods: [FoodEntity]
        do {
            matchedFoods = try viewContext.fetch(foodRequest)
        } catch let error {
            print("Error fetching foods. \(error)")
            return
        }
        guard let food: FoodEntity = matchedFoods.first else {
            print("Could not find \(foodName) in food list")
            completion(AddFoodIntentResponse.failure(food: foodName))
            return
        }
        print("Found \(foodName) in food list")
        
        // MARK: Get today's Log Entity
        let logRequest = LogEntity.fetchRequest()
        logRequest.predicate = LogEntity.dayOfPredicate(date: Date())
        var log: LogEntity
        do {
            log = try viewContext.fetch(logRequest).last ?? LogEntity(context: viewContext)
        } catch let error {
            print("Error fetching logs. \(error)")
            return
        }
        
        // MARK: Create Logged Food for Food
        let date = Date()
        log.timestamp = date
        var foodList = log.foods.allObjects as? [LoggedFoodEntity] ?? []
        let loggedFood = LoggedFoodEntity(context: viewContext)
        loggedFood.timestamp = date
        loggedFood.food = food
        foodList.append(loggedFood)
        log.foods = Set<LoggedFoodEntity>(foodList) as NSSet
        viewContext.saveIfChanged()
        
        // MARK: Donate to Siri Intents
        let intent = AddFoodIntent()
        intent.food = foodName
        intent.suggestedInvocationPhrase = "Add Food"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if let error = error {
                print("\n Error: \(error.localizedDescription)")
            } else {
                print("\n Donated AddFoodIntent")
            }
        }
        completion(AddFoodIntentResponse.success(food: foodName))
        
        
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
