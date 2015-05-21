# Patient_Care

User Documentation

There's 2 types of users for this app, patients and caretakers. This documentation explains how to use both accounts after regestering and loginning to each account. Registering and logging in is fairly simple and easy to understand. 

After logging in the Patient has 3 options. They can view their assigned caretakers, view their assigned tasks, or access their settings. 

To view their caretakers: As a patient simply tap on the "view caretakers" button located in the PatietHomeTableViewController that is immediately visible after logging in. The patient wil then see their assigned caretakers. 

To view their tasks: As a patient tap on the button "tasks" button to view the patients assigned tasks

To access their settings: As a patient tap on the burger icon located at the top left of the app. This will take you the settings controller which allows the patient to change their first and last name, review our terms and privacy policy, set their emergency contact information, view their rewardds, and a logout feature. 


Caretaker

Similarly, caretakers have 5 options when they login. 

Assigning a task: Cartakers can tap the "tasks" button to chose between 1 of the 3 built in tasks, assign a date to that task, and then determine whether they want to assign a once and a life time task or setup a daily occuring task. Af they select between once in a life time or recurring task, they are prompted to select which of their assigned patients should recieve this task. 

Taking notes: After selecting the "notes" button, the caretaker can write up a quick note and then determine whether they want this task assigned to them selves or if they should assign it to one of their patients

Link patients: If you want to assign a patient to your accout, you would tap on the 'link patients" button, click on the add button at the top left, and then enter the email address of the patient you want to add. After you enter the email address press the search feature at the top right corner. If a patient with that email exists, it will populate the table. The caretaker then needs to click on the patient and then click on the "add patient" button located at the bottom of the screen

Tracking: If you want to track the location of any of you assigned patients, simply tap on the "track patients" button to see their last 10 recorded moments

Patient Profile: If you want to see a specific patients assigned tasks or notes, simply click on the "view patient profile" button, click on the patient you want to inspect, and then click on whether you want to see their tasks or notes

Settings: Caretakers also have a similar settings feature that allows you to change some of the information you enetered when regestering an account. 

Developer Documentation

This application was developed using storyboards and a combination of ViewControllers, TableViewControllers, NavigationalControllers, and custom CellTableViewControllers. We have 1 stobyboard named Main.storyboard which contains all of our graphical user interface. Each of the views in the storyboard have a corresponding viewcontroller except the views at the very beginning of the app that describe the app. We have created virtual groups of every feature to organize all of our viewcontrollers. 

All the viewcontrollers are named according to their specific function. For example, LinkPatientsTableViewController is where the caretaker can link patients to their account. CareTakeAddTaskViewController is where the caretaker can assing a specific task to a patient after the caretaker has added a patient. Note that the app currently does not have a feature to unlink the patient from the caretaker. That's left for a future developer to add. The naming strucutre is standard within our application, and f

We should also point out that this application uses a global class called Settings that stores all the data for the app and that Settings can therefore be accessed within any controller in the app as long the the header for Settings has been imported in that controller. Settings can give you access to the server ports to make API calls, the list of patients assigned to a caretaker, the list of caretakers assinged to the patient, a list of the paitents current tasks, the patients reward points, and many more critical variables of this project. 

Every API call uses a standard NSURLSession where we define the API to use, the HTTP method, set the body, and then parse the output from the server. All standard precedure when dealing with APIs. 

We have a folder called images that is dedicated to storing all the images we use in the app in one easy to locate directory. 

The folder Patient_CareTests contains a single test case also named Patient_CareTests which tests all of the API calls in the backend to verify that they are working properly. This can be ran before attempting to use on the app on the simulator. We verify that each server returns 202 and that the body contains the attributes that we are expecting to parse in the real app. If any of these test cases fail, that app will also fail. 

