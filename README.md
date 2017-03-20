## Welcome to the Medical_Record_Demo! (Easy Core Data Fetching with Magical Record)

![](https://github.com/magicalpanda/magicalpanda.github.com/blob/master/images/awesome_logo_small.png?raw=true) Awesome MagicalRecord

**[Magical Record](https://github.com/magicalpanda/MagicalRecord) was inspired by the ease of Ruby on Rails' Active Record fetching. The goals of this code are:**
* Clean up my Core Data related code
* Allow for clear, simple, one-line fetches
* Still allow the modification of the NSFetchRequest when request optimizations are needed

MagicalRecord is provided as-is, free of charge. For support, you have a few choices:

Ask your support question on Stackoverflow.com, and tag your question with MagicalRecord. The core team will be notified of your question only if you mark your question with this tag. The general Stack Overflow community is provided the opportunity to answer the question to help you faster, and to reap the reputation points. If the community is unable to answer, we'll try to step in and answer your question.
If you believe you have found a bug in MagicalRecord, please submit a support ticket on the [Github Issues Page](https://github.com/magicalpanda/magicalrecord/issues). We'll get to them as soon as we can. Please do NOT ask general questions on the issue tracker. Support questions will be closed unanswered.
For more personal or immediate support, MagicalPanda is available for hire to consult on your project

### Documentation
1. [Installation](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Installing-MagicalRecord.md)
2. [Getting Started](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Getting-Started.md)
3. [Working with Managed Object Contexts](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Working-with-Managed-Object-Contexts.md)
4. [Creating Entities](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Creating-Entities.md)
5. [Deleting Entities](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Deleting-Entities.md)
6. [Fetching Entities](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Fetching-Entities.md)
7. [Saving Entities](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Saving-Entities.md)
8. [Importing Data](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Importing-Data.md)
9. [Logging](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Logging.md)
10. [Other Resources](https://github.com/magicalpanda/MagicalRecord/blob/master/Docs/Other-Resources.md)

### Core Data
Core Data is an object graph and persistence framework provided by Apple in OS X and iOS operating systems. It "interfaces directly with SQLite, insulating the developer from the underlying SQL" (Yes, we all use Wikipedia). You can organize and store your data by creating entities and attributes from an interface that Xcode provides.

I was always skeptical about Core Data. Never used, never even thought of using it. Core Data for me was like one of those distant relatives; I was aware of its existence, but I always found a reason to not visit it. Well, now here I am.

### Implementation
Below you can see an example code for Core Data Stack Initialization in Swift:

```sh
guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension:"momd") else {
fatalError("Error loading model from bundle")
}

guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
fatalError("Error initializing mom from: \(modelURL)")
}

let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
managedObjectContext.persistentStoreCoordinator = psc

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)

let docURL = urls[urls.endIndex - 1]

let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
do {
try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
} catch {
fatalError("Error migrating store: \(error)")
}
}

```
I am not saying this is too hard to do, but in my mind, I've already done too many things just to initialize the thing. It was kind of intimidating.

However, I later discovered this magical tool called MagicalRecord. What does it do? Here's MagicalRecord's approach for stack initialization:

```sh
MagicalRecord.setupAutoMigratingCoreDataStack()
```

Now that doesn't look too bad, does it? Simplification at its best.

### Adaptation
Since I have never worked with pure Core Data before, I will not compare pure Core Data and MagicalRecord + Core Data, but show you how it's like using MagicalRecord to save some data.

### Creating & Saving Entities
```sh
MagicalRecord.saveWithBlock({ (localContext) -> Void in
if let jsonArray = data?.jsonObjectRepresentation() as! [[String: AnyObject]]? {
let productType = (account.type == AccountType.Demo) ? ProductType.Demo : ProductType.Real

for jsonDict in jsonArray {
let namePredicate = NSPredicate(format: "name == %@", argumentArray: [jsonDict["Name"]!])
let typePredicate = NSPredicate(format: "typeRaw == %@", argumentArray: [productType.rawValue])

let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, typePredicate])

var product: Product? = Product.MR_findFirstWithPredicate(compoundPredicate,
inContext: localContext)

if (product == nil) {
product = Product.MR_createEntityInContext(localContext)
}

product?.updateWith(info: jsonDict)
product?.type = productType
}
}
}, completion: { (contextDidSave, error) -> Void in
completion(contextDidSave, error)
})
```

As you can see MR provides a class method which allow us to create and save entities conveniently. It runs in a background thread and lets us define a localContext where we can perform all our operations.

### Fetching Entities
Fetching is a lot easier. For instance, here is how you can get all entities of one type:

```sh
let products = Product.MR_findAll()
And here how you can fetch entities with filters:

// Controller Property
private var productsResultsController: NSFetchedResultsController!

// NSFetchedResultsController Update Method
func updateProductsResultsController() {
guard let account = selectedAccount else {
return
}

let predicates = NSMutableArray()

for product in (account.products)! {
predicates.addObject(NSPredicate(format: "name == %@", argumentArray: [(product as! Product).name!]))
}

let compoundNamePredicates = NSCompoundPredicate(orPredicateWithSubpredicates: predicates as NSArray as! [NSPredicate])

let typePredicate = NSPredicate(format: "typeRaw == %@", argumentArray: [(account.typeRaw)!])

let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, compoundNamePredicates])

if productsResultsController == nil {
productsResultsController = Product.MR_fetchAllSortedBy("name",
ascending: true,
withPredicate: compoundPredicate,
groupBy: nil,
delegate: self)
} else {
productsResultsController.fetchRequest.predicate = compoundPredicate

do {
try productsResultsController.performFetch()
} catch {
print("An error occurred")
}
}
}

// NSFetchedResultsControllerDelegate
extension ProductsViewController: NSFetchedResultsControllerDelegate {
func controllerDidChangeContent(controller: NSFetchedResultsController) {
if controller == productsResultsController {
self.tableView.reloadData()
}
}
}
```
You can see that you are able to filter your data by using predicates easily, and once your copy of NSFetchedResultsController object is created once, all you need to do is update the predicate and perform another fetch when there is a change on your filtering parameters.

### Summary
With MagicalRecord, you do not need worry about the boilerplate code, all you need to do is get the most out of your entities. It hides lots of low level code from you and makes your life a LOT easier while working with data.

Now you can have a centralized model infrastructure inside your application. You can finally stop checking for the update states of the data. If you are using the same data in different controllers and implement everything correctly, whenever an object gets updated, every related piece of code inside your code will be notified and you will not need to do anything else to update your views. Getting rid off all the boilerplate code and reducing the number of KVO notification usage gives you a chance to have a little bit more control over your classes.

Need more info? Have a look at these links:

For a detailed tutorial from scratch you can read [MagicalRecord Tutorial](MagicalRecord Tutorial for iOS) for iOS on [Ray Wenderlich's website](Ray Wenderlich's website).
Another tutorials on  [code.tutsplus.com](https://code.tutsplus.com/tutorials/easy-core-data-fetching-with-magical-record--mobile-13680)

And here is the project page: [https://github.com/magicalpanda/MagicalRecord](https://github.com/magicalpanda/MagicalRecord)

I hope this gives you an idea and simplifies your life as much as it did mine.
