//
//  CoreDataViewModel.swift
//  CalorieCounter
//
//  Created by Davidson Poole on 6/17/22.
//

import CoreData
import Intents
import Combine

class IJustAteViewModel: ObservableObject {
    static let shared = IJustAteViewModel()
    static var preview: IJustAteViewModel = createPreviewData()

    var container: PersistentContainer
    var decoder = JSONDecoder()
    let defaults = UserDefaults.standard
    
    @Published var date: Date = Date()
    @Published var log: LogEntity? = nil
    @Published var foods: [LoggedFoodEntity] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(isPreview: Bool = false) {
        container = PersistentContainer.shared
        if (!isPreview) {
            container.setup()
            let request = FoodEntity.allFoodsFetchRequest()
            do {
                if try container.viewContext.fetch(request).isEmpty {
                    UserDefaults.standard.reset()
                }
            } catch {
                print("error fetching foods")
            }
            loadFoodsFromRemote()
            
            refresh()
        }
    }
    
    func refresh() {
        // Todo clean up old publishers
        
        // Get currently selected log
        let fetchRequest = LogEntity.fetchRequest()
        fetchRequest.predicate = LogEntity.dayOfPredicate(date: date)
        var log: LogEntity?
        do {
            log = try container.viewContext.fetch(fetchRequest).last
        } catch {
            print("Error fetching log \(error)")
        }
        self.log = log
        
        // Get foods in log
        if let log = log {
            let loggedFoodsFetchRequest = LoggedFoodEntity.fetchRequest()
            loggedFoodsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
            loggedFoodsFetchRequest.predicate = NSPredicate(format: "log == %@", log)
            do {
                foods = try container.viewContext.fetch(loggedFoodsFetchRequest)
            } catch {
                print("Error fetching logged foods \(error)")
            }
//
//            Array(Set(foods.map{$0.food})).forEach { food in
//                publisher(for: food, in: container.viewContext)
//                    .sink(receiveValue: { [weak self] updatedObject in
//                        let objectChanged = updatedObject.name != food.name ||
//                        updatedObject.cal != food.cal ||
//                        updatedObject.car != food.car ||
//                        updatedObject.fat != food.fat ||
//                        updatedObject.pro != food.pro
//
//                        if objectChanged {
//                            print("OBJECT CHANGED")
//                            let index = self?.foods.firstIndex(where: {
//                                $0.food.id == food.id
//                            })
//                            self?.foods[index!].food = updatedObject
//                            self?.objectWillChange.send()
//                        }
//                    })
//                    .store(in: &cancellables)
//            }
        }
    }
    
    func changeDate(to date: Date) {
        self.date = date
        refresh()
    }
    
    func appendFoodToLog(food: FoodEntity) {
        let viewContext = container.viewContext
        let log = self.log ?? LogEntity(context: viewContext)
        log.timestamp = date
        var foodList = log.foods.allObjects as? [LoggedFoodEntity] ?? []
        let loggedFood = LoggedFoodEntity(context: viewContext)
        loggedFood.timestamp = date
        loggedFood.food = food
        foodList.append(loggedFood)
        log.foods = Set<LoggedFoodEntity>(foodList) as NSSet
        viewContext.saveIfChanged()
        refresh()
        
        // donate to siri intents
        let intent = AddFoodIntent()
        intent.food = food.name
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
    
    func deleteFoodFromLog(offset: Int) {
        let foodToDelete = foods[offset]
        container.viewContext.delete(foodToDelete)
        container.viewContext.saveIfChanged()
        refresh()
    }
    
    func deleteFood(food: FoodEntity) {
        guard food.local else {
            return
        }
        
        container.viewContext.delete(food)
        container.viewContext.saveIfChanged()
        refresh()
    }
    
    func createFood(name: String, cal: String, car: String, pro: String, fat: String) {
        let viewContext = container.viewContext
        let newFood = FoodEntity(context: viewContext)
        
        let id: Int16 = Int16(defaults.integer(forKey: UserDefaults.Keys.lastFoodId.rawValue))
        newFood.id = id
        defaults.set(id + 1, forKey: UserDefaults.Keys.lastFoodId.rawValue)
        
        newFood.name = name
        newFood.cal = cal.convertToDouble()
        newFood.car = car.convertToDouble()
        newFood.pro = pro.convertToDouble()
        newFood.fat = fat.convertToDouble()
        newFood.local = true
        
        viewContext.saveIfChanged()
        
        // Send food information to global database for approval
        let route = "foods/api/foods/"
        var req = URLRequest(url: URL(string: IJustAteProps.localIP + route)!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.httpBody = try? JSONEncoder().encode(newFood)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 3.0
        let session = URLSession(configuration: sessionConfig)
        session.dataTask(with: req) { data, response, error in
            guard
                let _ = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                print("Unable to connect to Local IP. Trying External IP...")
                req = URLRequest(url: URL(string: IJustAteProps.externalIP + route)!)
                req.httpMethod = "POST"
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                req.setValue("application/json", forHTTPHeaderField: "Accept")
                req.httpBody = try? JSONEncoder().encode(newFood)
                
                session.dataTask(with: req) { data, response, error in
                    guard
                        let _ = data,
                        let response = response as? HTTPURLResponse,
                        error == nil
                    else {
                        print("error", error ?? URLError(.badServerResponse))
                        return
                    }
                    guard (200...299) ~= response.statusCode else {
                        print("status code should be 2xx, but it is \(response.statusCode)")
                        print("response = \(response)")
                        return
                    }
                    
                    // Success
                    print("Successfully sent new food.")
                    
                }.resume()
                
                // will not resuming twice cause a problem?
                
                return
            }
            guard (200...299) ~= response.statusCode else {
                print("status code should be 2xx, but it is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            // Success
            print("Successfully sent new food.")
            
        }.resume()
        
        refresh()
    }
    
    func clearEverything() {
        clearFoods()
        clearLogs()
        clearLoggedFoods()
        
        container.viewContext.saveIfChanged()
        refresh()
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
    
    func clearGlobalFoods() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FoodEntity")
        fetchRequest.predicate = NSPredicate(format: "local == FALSE")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch let error {
            print("Error deleting foods. \(error)")
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
    
    func loadFoodsFromRemote() {
        let route = "foods/api/foods"
        let lastTimestamp: String = defaults.string(forKey: UserDefaults.Keys.lastTimestamp.rawValue)!
        var urlParam = ""
        if lastTimestamp != "" {
            urlParam = "/?time=" + lastTimestamp
        }
        let url = URL(string: IJustAteProps.localIP + route + urlParam)!
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 3.0
        let session = URLSession(configuration: sessionConfig)
        session.fetchData(for: url, decoder: decoder) { [self] (result: Result<ServerUpdateMessage, Error>) in
            switch result {
            case .success(let msg):
                print("Received update message from Server:")
                print(msg)
                DispatchQueue.main.async { [self] in
                    if (msg.reset) {
                        clearGlobalFoods()
                    }
                    msg.foods.forEach {
                        let newFood = FoodEntity(context: container.viewContext)
                        newFood.id = $0.id
                        newFood.name = $0.name
                        newFood.cal = $0.cal
                        newFood.car = $0.car
                        newFood.fat = $0.fat
                        newFood.pro = $0.pro
                        newFood.local = false
                        
                        mergeDuplicateFood(food: newFood)
                        refresh()
                    }
                    // get the first food which is the most recently updated
                    defaults.set(msg.timestamp, forKey: UserDefaults.Keys.lastTimestamp.rawValue)
                    self.container.viewContext.saveIfChanged()
                }
            case .failure(_ ):
                print("Unable to connect. Trying external IP...")
                let extURL = URL(string: IJustAteProps.externalIP + route + urlParam)!
                DispatchQueue.main.async {
                    session.fetchData(for: extURL, decoder: self.decoder) { [self] (result: Result<ServerUpdateMessage, Error>) in
                        switch result {
                        case .success(let msg):
                            print("Received update message from Server:")
                            DispatchQueue.main.async { [self] in
                                if (msg.reset) {
                                    clearGlobalFoods()
                                }
                                msg.foods.forEach {
                                    let newFood = FoodEntity(context: container.viewContext)
                                    newFood.id = $0.id
                                    newFood.name = $0.name
                                    newFood.cal = $0.cal
                                    newFood.car = $0.car
                                    newFood.fat = $0.fat
                                    newFood.pro = $0.pro
                                    newFood.local = false
                                    
                                    mergeDuplicateFood(food: newFood)
                                    refresh()
                                }
                                // get the first food which is the most recently updated
                                defaults.set(msg.timestamp, forKey: UserDefaults.Keys.lastTimestamp.rawValue)
                                self.container.viewContext.saveIfChanged()
                            }
                        case .failure(let error):
                            print("load failed " + error.localizedDescription)
                      }
                    }
                }
          }
        }
    }
    
    func mergeDuplicateFood(food: FoodEntity) {
            
        // If name exists in database, we replace locally stored food with global food and update logs that reference it
        let fetchRequest = FoodEntity.fetchRequest()
        fetchRequest.sortDescriptors = FoodEntity.defaultSortDescriptors
        let namePredicate = NSPredicate(format: "name == %@", food.name)
        let localPredicate = NSPredicate(format: "local == YES")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, localPredicate])
        do {
            if let oldFood = try container.viewContext.fetch(fetchRequest).first {
                // find logs that contain food and update them
                let loggedFoodRequest = LoggedFoodEntity.fetchRequest()
                loggedFoodRequest.predicate = NSPredicate(format: "food == %@", oldFood)
                let loggedFoods = try container.viewContext.fetch(loggedFoodRequest)
                if (!loggedFoods.isEmpty) {
                    print("Found \(loggedFoods.count) logs using this food. Changing them...")
                }
                for i in 0..<loggedFoods.count {
                    loggedFoods[i].food = food
                }
                container.viewContext.delete(oldFood)
            }
        } catch {
            print("Error merging duplicate foods. \(error)")
        }
    }
    
    func publisher<T: NSManagedObject>(for managedObject: T, in context: NSManagedObjectContext) -> AnyPublisher<T, Never> {
        let notification = NSManagedObjectContext.didMergeChangesObjectIDsNotification
        return NotificationCenter.default.publisher(for: notification, object: context)
            .compactMap { notification in
                if let updated = notification.userInfo?[NSUpdatedObjectIDsKey] as? Set<NSManagedObjectID>, updated.contains(managedObject.objectID),
                   let updatedObject = context.object(with: managedObject.objectID) as? T {
                    return updatedObject
                } else {
                    return nil
                }
            }
            .eraseToAnyPublisher()
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
    
    static func createPreviewData() -> IJustAteViewModel {
        let result = IJustAteViewModel(isPreview: true)
        let viewContext = result.container.viewContext
        var foodArr = [FoodEntity]()
        for i in 0..<5 {
            let newFood = FoodEntity(context: viewContext)
            newFood.name = "Food \(i)"
            foodArr.append(newFood)
        }
        let newLog = LogEntity(context: viewContext)
        newLog.timestamp = Date()
        let loggedFoods: [LoggedFoodEntity] = foodArr.map {
            let newLoggedFood = LoggedFoodEntity(context: viewContext)
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
