# Patient_Care

User Documentation

Download or install the a


Developer Documentation

This application was developed using storyboards and a combination of ViewControllers, TableViewControllers, NavigationalControllers, and custom CellTableViewControllers. We have 1 stobyboard named Main.storyboard which contains all of our graphical user interface. Each of the views in the storyboard have a corresponding viewcontroller except the views at the very beginning of the app that describe the app. We have created virtual groups of every feature to organize all of our viewcontrollers. 

All the viewcontrollers are named according to their specific function. For example, LinkPatientsTableViewController is where the caretaker can link patients to their account. CareTakeAddTaskViewController is where the caretaker can assing a specific task to a patient after the caretaker has added a patient. Note that the app currently does not have a feature to unlink the patient from the caretaker. That's left for a future developer to add. The naming strucutre is standard within our application, and f

We should also point out that this application uses a global class called Settings that stores all the data for the app and that Settings can therefore be accessed within any controller in the app as long the the header for Settings has been imported in that controller. 
