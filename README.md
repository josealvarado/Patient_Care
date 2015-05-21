# Patient_Care

User Documentation

There's 2 types of users for this app, patients and caretakers. This documentation explains how to use both accounts after regestering and loginning to each account. 

Patient

Caretaker




Developer Documentation

This application was developed using storyboards and a combination of ViewControllers, TableViewControllers, NavigationalControllers, and custom CellTableViewControllers. We have 1 stobyboard named Main.storyboard which contains all of our graphical user interface. Each of the views in the storyboard have a corresponding viewcontroller except the views at the very beginning of the app that describe the app. We have created virtual groups of every feature to organize all of our viewcontrollers. 

All the viewcontrollers are named according to their specific function. For example, LinkPatientsTableViewController is where the caretaker can link patients to their account. CareTakeAddTaskViewController is where the caretaker can assing a specific task to a patient after the caretaker has added a patient. Note that the app currently does not have a feature to unlink the patient from the caretaker. That's left for a future developer to add. The naming strucutre is standard within our application, and f

We should also point out that this application uses a global class called Settings that stores all the data for the app and that Settings can therefore be accessed within any controller in the app as long the the header for Settings has been imported in that controller. Settings can give you access to the server ports to make API calls, the list of patients assigned to a caretaker, the list of caretakers assinged to the patient, a list of the paitents current tasks, the patients reward points, and many more critical variables of this project. 

Every API call uses a standard NSURLSession where we define the API to use, the HTTP method, set the body, and then parse the output from the server. All standard precedure when dealing with APIs. 

We have a folder called images that is dedicated to storing all the images we use in the app in one easy to locate directory. 

The folder Patient_CareTests contains a single test case also named Patient_CareTests which tests all of the API calls in the backend to verify that they are working properly. This can be ran before attempting to use on the app on the simulator. We verify that each server returns 202 and that the body contains the attributes that we are expecting to parse in the real app. If any of these test cases fail, that app will also fail. 

