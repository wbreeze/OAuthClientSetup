#import "../../Pods/tunup_js/tuneup.js"

test("authorize and reset", function(target, app) {
     var target = UIATarget.localTarget();

     target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].tap();
     target.frontMostApp().keyboard().typeString("user@example.com");
     target.frontMostApp().mainWindow().scrollViews()[0].textFields()[0].tap();
     target.frontMostApp().keyboard().typeString("doorkeeper");
     target.frontMostApp().mainWindow().scrollViews()[0].buttons()["Connect"].tap();
     target.frontMostApp().mainWindow().buttons()["Reset"].tap();
     });

