## Easy Core Data Fetching with Magical Record) ![](https://github.com/magicalpanda/magicalpanda.github.com/blob/master/images/awesome_logo_small.png?raw=true)

With MagicalRecord, you do not need worry about the boilerplate code, all you need to do is get the most out of your entities. It hides lots of low level code from you and makes your life a LOT easier while working with data.

Now you can have a centralized model infrastructure inside your application. You can finally stop checking for the update states of the data. If you are using the same data in different controllers and implement everything correctly, whenever an object gets updated, every related piece of code inside your code will be notified and you will not need to do anything else to update your views. Getting rid off all the boilerplate code and reducing the number of KVO notification usage gives you a chance to have a little bit more control over your classes.

Need more info? Have a look at these links:

For a detailed tutorial from scratch you can read [Megical Record Page](https://github.com/magicalpanda/MagicalRecord)  & [MagicalRecord Tutorial](https://www.raywenderlich.com/56879/magicalrecord-tutorial-ios) for iOS on [Ray Wenderlich's website](https://www.raywenderlich.com).
You can also find another tutorials on  [code.tutsplus.com](https://code.tutsplus.com/tutorials/easy-core-data-fetching-with-magical-record--mobile-13680)

And here is the project page: [https://github.com/magicalpanda/MagicalRecord](https://github.com/magicalpanda/MagicalRecord)

I hope this gives you an idea and simplifies your life as much as it did mine.

### few lines for better understanding
```sh
MagicalRecord.setupCoreDataStack()
// Setup MagicalRecord as per usual

// Get coredata .sqlite file path
print("URL - \(NSPersistentStore.mr_url(forStoreName: MagicalRecord.defaultStoreName()))")

// Get all data 
self.arrStudentList = Student.mr_findAll() as! [Student]

// Create entity
var selectedStudent : Student?
selectedStudent = Student.mr_createEntity()

// Delete entity
objSubjectTemp.mr_deleteEntity()

// Save data (save Managed Object Context)
NSManagedObjectContext.mr_default().mr_saveToPersistentStore(completion: { (contextDidSave, error) in
if contextDidSave {
print("User Detail Saved")
}
else {
print("error - \(error?.localizedDescription)")
}
})
```
