import CoreData

//MARK: - NSManagedObject

extension NSManagedObject {
    
    class func entityName() -> String {
        return "\(classForCoder())"
    }
    
}

//MARK: - Protocol DBObjectManager
protocol DBObjectManager {
    
}

extension DBObjectManager where Self: NSManagedObject {
    
    /***
     It will create a new entity in database by passing its name and return NSManagedObject
     */
    static func createNewEntity() -> Self {
        
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            context = appDelegate.managedObjectContext
            // Fallback on earlier versions
        }
        
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName(), into: context) as! Self
        return object
    }
    
    
    /***
     It will return existing entity or will send band new entity
     */
    static func createNewEntity(_ key: String,value:String) -> Self {
        let predicate = NSPredicate(format: "%K = %@", key, value)
        let results = fetchDataFromEntity(predicate, sortDescs: nil)
        let entity: Self
        if results.isEmpty{
            entity = createNewEntity()
        }else{
            entity = results.first!
        }
        return entity
    }
    
    /***
     It will return existing entity with combination of key and value or will send band new entity
     */
    static func createNewEntity(_ keys:[String], values:[String]) -> Self {
        var conditions:[NSPredicate] = []
        for (index,key) in keys.enumerated() {
            conditions.append(NSPredicate(format: "%K = %@", key, values[index]))
        }
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: conditions)
        let results = fetchDataFromEntity(predicate, sortDescs: nil)
        let entity: Self
        if results.isEmpty{
            entity = createNewEntity()
        }else{
            entity = results.first!
        }
        return entity
    }
    
    /***
     It will only check for given primary key entiry and if presenet in database will return it
     */
    static func checkForEntity(_ key: String, value: NSString) -> Self? {
        let predicate = NSPredicate(format: "%K = %@", key, value)
        let results = fetchDataFromEntity(predicate, sortDescs: nil)
        if results.isEmpty {
            return nil
        } else {
            return results.first!
        }
    }
    
    
    /***
     It will return NSEntityDescription optional value, by passing entity name.
     */
    static func getExisting() -> NSEntityDescription? {
        
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            context = appDelegate.managedObjectContext
            // Fallback on earlier versions
        }
        
        let entityDesc = NSEntityDescription.entity(forEntityName: entityName(), in: context)
        return entityDesc
    }
    
    /***
     It will return an array of existing values from given entity name, with peredicate and sort description.
     */
    static func fetchDataFromEntity(_ predicate:NSPredicate?, sortDescs:NSArray?)-> [Self] {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        if let _ = predicate {
            fetchRequest.predicate = predicate
        }
        if let _ = sortDescs {
            fetchRequest.sortDescriptors = sortDescs as? Array
        }
        
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            context = appDelegate.managedObjectContext
            // Fallback on earlier versions
        }
        
        do {
            let resultsObj = try context.fetch(fetchRequest)
            if (resultsObj as! [Self]).count > 0 {
                return resultsObj as! [Self]
            }else{
                return []
            }
        } catch let error as NSError {
            print("Error in fetchedRequest : \(error.localizedDescription)")
            return []
        }
    }
    
    // This will only bring single entity of given predicate if it exist in db. No need to pass sort descriptor here.
    static func fetchSingleDataFromEntity(_ predicate:NSPredicate?)-> Self? {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        if let _ = predicate {
            fetchRequest.predicate = predicate
        }
        
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            context = appDelegate.managedObjectContext
            // Fallback on earlier versions
        }
        
        do {
            let resultsObj = try context.fetch(fetchRequest)
            if (resultsObj as! [Self]).count > 0 {
                return resultsObj[0] as? Self
            }else{
                return nil
            }
        } catch let error as NSError {
            print("Error in fetchedRequest : \(error.localizedDescription)")
            return nil
        }
    }
    
    static func deleteAllRecord1() {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
        } else {
            context = appDelegate.managedObjectContext
            // Fallback on earlier versions
        }
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    static func deleteAllRecord() {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        let context: NSManagedObjectContext!
        
        if #available(iOS 10.0, *) {
            context = appDelegate.persistentContainer.viewContext
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
            
        } else {
            context = appDelegate.managedObjectContext
            
            do {
                let result = try context.fetch(fetchRequest)
                for object in result {
                    context.delete(object as! NSManagedObject)
                }
                try context.save()
            } catch {
                print ("There was an error")
            }
            
            // Fallback on earlier versions
        }
    }
}

/*
 {
 "collections": {
 "flashlist": [
 {
 "lessonid": "344",
 "strLessonName": "Audiobook - Modal Verbs - Must",
 "LessonInfo1": [
 "5. Klasse Gym / Englisch Grammatik",
 "5. Klasse Gym / Englisch Grammatik"
 ],
 "RowsInList": "11",
 "red": "0",
 "yellow": "0",
 "green": "0",
 "points": "17",
 "flashlistcontent": {
 "sentence": [
 {
 "id": "7873_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Modalverben oder im Englischen"
 },
 {
 "id": "7873_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Modal Verbs"
 },
 {
 "id": "7874_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "drücken eine Fähigkeit, eine Erlaubnis, einen Wunsch oder eine Notwendigkeit in Bezug auf eine Tätigkeit aus. Im Deutschen heißen sie: müssen, können, dürfen, mögen, sollen und wollen. Gebildet wird ein Satz mit einem Modal Verb indem man das abgewandelte Modalverb und den Infinitiv des Verbs verwendet. Z.B. ich kann schwimmen."
 },
 {
 "id": "7874_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I can swim. You can Swim. He can swim. We can swim. You can swim. They can swim. I could swim. You could swim. We could swim."
 },
 {
 "id": "7875_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Müssen heißt"
 },
 {
 "id": "7875_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Must or to have to"
 },
 {
 "id": "7876_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Müssen drückt eine Notwendigkeit aus. Z.B. Ich muss heute lernen."
 },
 {
 "id": "7876_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I must learn today."
 },
 {
 "id": "7877_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Das Wort Müssen hat im Englischen keine direkte Vergangenheitsform, man kann z.b. nicht sagen:"
 },
 {
 "id": "7877_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I musted learn yesterday."
 },
 {
 "id": "7878_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Stattdessen sagt man:"
 },
 {
 "id": "7878_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I had to learn yesterday. to have to"
 },
 {
 "id": "7879_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Ist also die Ersatzform für"
 },
 {
 "id": "7879_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "must"
 },
 {
 "id": "7880_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Man kann diese Ersatzform auch im Präsens verwenden. Z.B. "
 },
 {
 "id": "7880_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I have to learn today."
 },
 {
 "id": "7881_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Die Verneinung von müssen lautet:"
 },
 {
 "id": "7881_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "must not or mustn´t or not to be allowed to"
 },
 {
 "id": "7882_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Anders als im Deutschen heißt"
 },
 {
 "id": "7882_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "must not"
 },
 {
 "id": "7883_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "nicht \"nicht müssen\" sondern \"nicht dürfen\". Z.B. Ich darf nicht schwimmen."
 },
 {
 "id": "7883_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I must not swim."
 }
 ]
 }
 },
 {
 "lessonid": "349",
 "strLessonName": "Audiobook - Modal Verbs - Einleitung",
 "LessonInfo1": [
 "5. Klasse Gym / Englisch Grammatik",
 "5. Klasse Gym / Englisch Grammatik"
 ],
 "RowsInList": "6",
 "red": "0",
 "yellow": "0",
 "green": "0",
 "points": "0",
 "flashlistcontent": {
 "sentence": [
 {
 "id": "7917_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Modalverben oder im Englischen"
 },
 {
 "id": "7917_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Modal Verbs"
 },
 {
 "id": "7918_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "drücken eine Fähigkeit, eine Erlaubnis, einen Wunsch oder eine Notwendigkeit in Bezug auf eine Tätigkeit aus. Im Deutschen heißen sie: müssen, können, dürfen, mögen, sollen und wollen. Im Englischen: "
 },
 {
 "id": "7918_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "must, have to, need, can, be able to, may, be allowed to, like, would like, shall, ought to, want"
 },
 {
 "id": "7919_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Gebildet wird ein Satz mit einem Modal Verb indem man das abgewandelte Modalverb und den Infinitiv des Verbs verwendet. Z.B. schwimmen können"
 },
 {
 "id": "7919_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I can swim. You can Swim. He can swim. We can swim. You can swim. They can swim."
 },
 {
 "id": "7920_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Wenn man einen Satz in der Vergangenheit bildet, wird nur das Modalverb abgewandelt, das Hauptverb bleibt gleich. Z.B.: Ich konnte schwimmen."
 },
 {
 "id": "7920_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I could swim."
 },
 {
 "id": "7921_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Wenn man eine Frage bildet, wird das Modalverb an den Satzanfang gestellt. Z.B.: Kann ich schwimmen?"
 },
 {
 "id": "7921_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Can I swim?"
 },
 {
 "id": "7922_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Bei der Verneinung wird das Modalverb verneint, das Hauptverb bleibt gleich. Z.B.: Ich kann nicht schwimmen."
 },
 {
 "id": "7922_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I can not swim."
 }
 ]
 }
 },
 {
 "lessonid": "350",
 "strLessonName": "Audiobook - Modal Verbs - Can",
 "LessonInfo1": [
 "5. Klasse Gym / Englisch Grammatik",
 "5. Klasse Gym / Englisch Grammatik"
 ],
 "RowsInList": "8",
 "red": "0",
 "yellow": "0",
 "green": "0",
 "points": "0",
 "flashlistcontent": {
 "sentence": [
 {
 "id": "7923_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Das Modalverb Können heißt im Englischen"
 },
 {
 "id": "7923_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Can, be able to"
 },
 {
 "id": "7924_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Können drückt eine Fähigkeit aus. Z.B. Ich kann singen."
 },
 {
 "id": "7924_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I can sing."
 },
 {
 "id": "7925_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Das Wort Können hat eine direkte Vergangenheitsform, man kann sagen:"
 },
 {
 "id": "7925_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I could sing."
 },
 {
 "id": "7926_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Man kann aber auch die Ersatzform verwenden um die Vergangenheit auszudrücken. Z.B."
 },
 {
 "id": "7926_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I was able to sing."
 },
 {
 "id": "7927_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Man kann die Ersatzform auch im Präsens verwenden. Z.B.:"
 },
 {
 "id": "7927_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I am able to sing."
 },
 {
 "id": "7928_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Die Verneinung von können lautet"
 },
 {
 "id": "7928_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "can not, be not able to"
 },
 {
 "id": "7929_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Ein Beispiel zur Verneinung:"
 },
 {
 "id": "7929_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I can not sing. I am not able to sing."
 },
 {
 "id": "7930_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Bei Fragen stellt man das Modalverb an den Satzanfang. Z.B. Kann ich singen?"
 },
 {
 "id": "7930_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Can I sing? Am I able to sing?"
 }
 ]
 }
 },
 {
 "lessonid": "351",
 "strLessonName": "Audiobook - Modal Verbs - Shall",
 "LessonInfo1": [
 "5. Klasse Gym / Englisch Grammatik",
 "5. Klasse Gym / Englisch Grammatik"
 ],
 "RowsInList": "8",
 "red": "0",
 "yellow": "0",
 "green": "0",
 "points": "0",
 "flashlistcontent": {
 "sentence": [
 {
 "id": "7931_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Das Modalverb \"Sollen\" heißt im Englischen"
 },
 {
 "id": "7931_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Shall, should, ought to, to be supposed to do something"
 },
 {
 "id": "7932_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Sollen drückt eine Notwendigkeit aus, welche aber weniger dringend ist als die von müssen. Man kann mit diesem Modalverb auch Ratschläge geben. Z.B.: Ich sollte diese Woche einkaufen gehen."
 },
 {
 "id": "7932_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I shall go shopping this week. I should go shopping this week. I ought to go shopping this week."
 },
 {
 "id": "7933_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Wenn jemand eigentlich etwas machen sollte, verwendet man"
 },
 {
 "id": "7933_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "ought to"
 },
 {
 "id": "7934_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Ein Beispiel dazu: Eigentlich sollte ich meine Hausaufgaben machen, aber ich will nicht."
 },
 {
 "id": "7934_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I ought to do my homework but I do not want to."
 },
 {
 "id": "7935_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Wenn man die Vergangenheit ausdrücken will nimmt man die Ersatzform"
 },
 {
 "id": "7935_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "to be supposed to"
 },
 {
 "id": "7936_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Ein Beispiel dazu:"
 },
 {
 "id": "7936_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "I was supposed to go shopping last week."
 },
 {
 "id": "7937_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Bei Fragen verwendet man oft das Modalverb"
 },
 {
 "id": "7937_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "shall"
 },
 {
 "id": "7938_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Jedoch kann man die anderen zwei Verben auch verwenden. Z.B.:"
 },
 {
 "id": "7938_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "Shall I go shopping this week? Should I go shopping this week? Am I supposed to go shopping this week?"
 }
 ]
 }
 },
 {
 "lessonid": "352",
 "strLessonName": "Audiobook - Modal Verbs - May",
 "LessonInfo1": [
 "5. Klasse Gym / Englisch Grammatik",
 "5. Klasse Gym / Englisch Grammatik"
 ],
 "RowsInList": "7",
 "red": "0",
 "yellow": "0",
 "green": "0",
 "points": "0",
 "flashlistcontent": {
 "sentence": [
 {
 "id": "7939_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Das Modalverb \"Dürfen\" heißt im Englischen"
 },
 {
 "id": "7939_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "May, to be allowed to"
 },
 {
 "id": "7940_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Dürfen drückt eine Möglichkeit oder eine Erlaubnis aus. Z.B.: Wir dürfen heute ins Kino gehen."
 },
 {
 "id": "7940_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "We may go to the cinema today. We are allowed to go to the cinema today."
 },
 {
 "id": "7941_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Um die Vergangenheit auszudrücken, verwendet man die Ersatzform"
 },
 {
 "id": "7941_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "to be allowed to"
 },
 {
 "id": "7942_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Ein Beispiel dazu: Wir durften gestern ins Kino gehen."
 },
 {
 "id": "7942_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "We were allowed to go to the cinema yesterday,"
 },
 {
 "id": "7943_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Bei Fragen wird das Modalverb an den Satzanfang gestellt. Z.B.:"
 },
 {
 "id": "7943_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "May we go to the cinema today? Are we allowed to go to the cinema today?"
 },
 {
 "id": "7944_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Wenn man ein Verbot ausdrücken will, nimmt man meistens die Verneinung von müssen. Z.B.: Wir dürfen während des Unterrichts nicht reden."
 },
 {
 "id": "7944_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "We must not talk during the lesson."
 },
 {
 "id": "7945_a",
 "language": "DE",
 "breakafter": "1000",
 "say": "Ein Beispiel zur regulären Verneinung:"
 },
 {
 "id": "7945_b",
 "language": "EN",
 "breakafter": "2000",
 "say": "We may not go to the cinema today. We are not allowed to go to the cinema today."
 }
 ]
 }
 }
 ]
	}
 }
 */

