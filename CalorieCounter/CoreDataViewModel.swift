//
//  CoreDataViewModel.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import CoreData

class CoreDataViewModel: ObservableObject {
    static let shared = CoreDataViewModel()

    static var preview: CoreDataViewModel = createPreviewData()

    let container: NSPersistentContainer
    @Published var foods: [FoodEntity] = []
    @Published var logs: [LogEntity] = []
    @Published var users: [UserEntity] = []
    @Published var goals: [GoalEntity] = []

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CalorieCounter")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error loading Core Data. \(error)")
            } else {
                print("Successfully loaded Core Data")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        fetchEverything()
    }
    
    func addFood(name: String, cal: Int, car: Int, pro: Int, fat: Int) {
        let newFood = FoodEntity(context: container.viewContext)
        newFood.name = name
        newFood.cal = Int16(cal)
        newFood.car = Int16(car)
        newFood.pro = Int16(pro)
        newFood.fat = Int16(fat)
        saveData()
    }
    
    func addLog(foods: Set<FoodEntity>, date: Date = Date()) {
        let newLog = LogEntity(context: container.viewContext)
        newLog.timestamp = date
        newLog.foods = foods as NSSet
        saveData()
    }
    
    func fetchFoods() {
        let request = NSFetchRequest<FoodEntity>(entityName: "FoodEntity")
        do {
            foods = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching foods. \(error)")
        }
    }
    
    func fetchLogs() {
        let request = NSFetchRequest<LogEntity>(entityName: "LogEntity")
        do {
            logs = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching logs. \(error)")
        }
    }
    
    func fetchUsers() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        do {
            users = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching users. \(error)")
        }
    }
    
    func fetchGoals() {
        let request = NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
        do {
            goals = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching goals. \(error)")
        }
    }
    
    func fetchEverything() {
        fetchFoods()
        fetchLogs()
        fetchUsers()
        fetchGoals()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchEverything()
        } catch let error {
            print("Error saving data. \(error)")
        }
    }
    
    static func createPreviewData() -> CoreDataViewModel {
        let result = CoreDataViewModel(inMemory: true)
        let viewContext = result.container.viewContext
        var foodArr = [FoodEntity]()
        for i in 0..<5 {
            let newFood = FoodEntity(context: viewContext)
            newFood.name = "Food \(i)"
            foodArr.append(newFood)
        }
        let newLog = LogEntity(context: viewContext)
        newLog.timestamp = Date()
        newLog.foods = Set(foodArr) as NSSet
        let newGoal = GoalEntity(context: viewContext)
        newGoal.cal = 2000
        newGoal.car = 500
        newGoal.pro = 50
        newGoal.fat = 20
        let newUser = UserEntity(context: viewContext)
        newUser.username = "davidson"
        newUser.password = "password"
        newUser.log = NSSet(object: newLog)
        newUser.goal = newGoal
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error in preview \(nsError), \(nsError.userInfo)")
        }
        return result
    }
}
