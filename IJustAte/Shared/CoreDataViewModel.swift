//
//  CoreDataViewModel.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import CoreData
import Intents

class CoreDataViewModel: ObservableObject {
    static let shared = CoreDataViewModel()
    static var preview: CoreDataViewModel = createPreviewData()

    var container: PersistentContainer
        
    @Published var foods: [FoodEntity] = []
    @Published var loggedFoods: [LoggedFoodEntity] = []
    @Published var logs: [LogEntity] = []
    @Published var users: [UserEntity] = []
    @Published var goals: [GoalEntity] = []

    init(isPreview: Bool = false) {
        container = PersistentContainer.shared
        if (!isPreview) {
            container.setup()
            fetchEverything()
        }
    }
    
    // ------ Start of Data Controller commands --------- //
        
    
    func createFood(name: String, cal: Double, car: Double, pro: Double, fat: Double) {
        let newFood = FoodEntity(context: container.viewContext)
        newFood.name = name
        newFood.cal = cal
        newFood.car = car
        newFood.pro = pro
        newFood.fat = fat
        saveData()
    }
    
    enum MyError: Error {
        case runtimeError(String)
    }
    
    func addToLog(food: FoodEntity, date: Date = Date()) {
        var log = logs.last(where: { $0.timestamp?.get(.day) == date.get(.day) })
        if (log == nil) {
            log = LogEntity(context: container.viewContext)
        }
        log!.timestamp = date
        var foodList = log!.foods?.allObjects as? [LoggedFoodEntity]
        let loggedFood = LoggedFoodEntity(context: container.viewContext)
        loggedFood.timestamp = date
        loggedFood.food = food
        foodList?.append(loggedFood)
        log!.foods = Set<LoggedFoodEntity>(foodList!) as NSSet
        saveData()
        
        // donate to siri intents
        let intent = AddFoodIntent()
        intent.food = food.name ?? ""
        intent.suggestedInvocationPhrase = "Add Food"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if let error = error {
                print("\n Error: \(error.localizedDescription)")
            } else {
                print("\n Donated AddFoodIntent")
            }
        }
    }
    
    func getFood(name: String) -> FoodEntity? {
        return foods.last(where: { $0.name?.lowercased() == name.lowercased() })
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
    
    func clearLogs() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LogEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print("Error deleting logs. \(error)")
        }
    }
    
    func clearFoods() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FoodEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print("Error deleting foods. \(error)")
        }
    }
    
    func clearLoggedFoods() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LoggedFoodEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print("Error deleting foods. \(error)")
        }
    }
    
    func saveData() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                fetchEverything()
                print("saved data")
            } catch let error {
                print("Error saving data. \(error)")
            }
        }
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "foods.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data)
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            do {
                try fileHandle!.seekToEnd()
                let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
                fileHandle!.write(csvData!)
                
                try fileHandle!.close()
            } catch {
                print("Error seeking to end")
            }
        }
    }
    
    func createExportString() -> String {
        var str = ""
        for food in foods {
            let m = food.macro
            str += "\(m.cal),\(m.car),\(m.pro),\(m.fat)\n"
        }
        return str
    }
    
    static func createPreviewData() -> CoreDataViewModel {
        let result = CoreDataViewModel(isPreview: true)
        let viewContext = result.container.viewContext
        var foodArr = [FoodEntity]()
        for i in 0..<5 {
            let newFood = FoodEntity(context: viewContext)
            newFood.name = "Food \(i)"
            foodArr.append(newFood)
        }
        let newLog = LogEntity(context: viewContext)
        newLog.timestamp = Date()
        var loggedFoods: [LoggedFoodEntity] = foodArr.map {
            var newLoggedFood = LoggedFoodEntity(context: viewContext)
            newLoggedFood.timestamp = Date()
            newLoggedFood.food = $0
            return newLoggedFood
        }
        newLog.foods = Set(loggedFoods) as NSSet
        let newGoal = GoalEntity(context: viewContext)
        newGoal.cal = 2000
        newGoal.car = 500
        newGoal.pro = 50
        newGoal.fat = 20
        let newUser = UserEntity(context: viewContext)
        newUser.username = "davidson"
        newUser.password = "password"
        //newUser.log = NSSet(object: newLog)
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

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
