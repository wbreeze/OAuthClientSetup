#import "../../../../Pods/tuneup_js/tuneup.js"

test("authorize and reset", function(target, app) {

     app.mainWindow().scrollViews()[0].textFields()[0].tap();
     app.keyboard().typeString("user@example.com");

     app.mainWindow().scrollViews()[0].secureTextFields()[0].tap();
     app.keyboard().typeString("doorkeeper");

     app.mainWindow().scrollViews()[0].buttons()["Connect"].tap();

     app.mainWindow().logElementTree();

     app.mainWindow().buttons()["Reset"].tap();
});
