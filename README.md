# AddressBookNuvalence
Address Book built in IOS using Swift for challenge - Michael Shiozaki

## Deployment Instructions
1. If not installed, Search XCode in the Mac App Store and download the app.
2. Open NuvalenceAddressbook.xcodeproj in XCode. 
3. If using physical iPhone: 
   * Plug in the iPhone and unlock it. You may need to select “Trust this Computer” if a popup appears on the phone
   * In the top bar of the screen, click the “iPhone _” and scroll up the list to your physical iPhone
   * Click the big Play button to run the app on the phone
4. If using iPhone Simulator
   * In the top bar of the screen, click the “iPhone _” and select the iPhone you would like to simulate
   * Click the big Play button to run the app on the phone

## Project Summary

### Approach
I chose a mobile application due to my previous background and current job in mobile development. Building a web app is not something I have done before, and while I would welcome the challenge I did not think that I would be able to showcase the best of my ability with technologies that I was unfamiliar with.

MVC architecture was selected due to familiarity and common use in the IOS community (although I broke from this architecture by storing the list of people in the view controller). The app is a simple, two page app. One that provides the user with a list of users and one page with a more detailed view, with basic navigation and refresh capabilities built in. The API GET request fires upon app startup to populate the tableview, which can be interacted with by the user. 


### Features
The features of the app are very standard. Upon starting up, the user is presented with a list of 30 randomly generated people from the RandomUser API. Upon tapping a person on the list, the user can find more detailed information about the person, such as their email and phone number. The user can also pull down on the table of users to refresh the address book to get a list of 30 new people.  


### Future Potential Feature Considerations
Given more time, there’s two primary areas I’d like to focus on. One is performance, specifically the tableview performance when scrolling and refreshing. Preloading or caching the images should create a smooth scrolling experience instead of each cell making a URL call for the person image and stuttering the user interface. Second is adding more details and functionality. Adding a maps integration to show their address, or adding tap functionality for email and phone that will open up the Mail or Phone apps to contact the person are features that I would consider adding given more time. Both of these areas would likely take me several hours, as I have not dealt with preloading images or passing to other apps before and would have to research first.


### Future Potential Improvements to Robustness
First would be to ensure the project is scalable. For example, using an enum for different HTTP verbs could be an addition if we choose to expand for more than just GET requests to the API. Additional unit tests for non-happy path scenarios would also be helpful, to ensure that the correct errors are firing for various responses. I would also have added UI tests to test pull to refresh and push to another view controller via taps in the tableview to ensure that UI is working as intended. 
