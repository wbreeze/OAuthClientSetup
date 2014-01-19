#import "../../Pods/tuneup_js/tuneup.js"

function onConnectView() {
  assertWindow({
      scrollViews: [{
          staticTexts: [
            { label: "Email" },
            { label: "Password" }
          ],
          buttons: [ { name: "Connect" } ]
      }]
    });
}

function onAuthorizedView() {
  assertWindow({
    staticTexts: [ { label: /^You are authorized/ } ],
    buttons: [ { name: "Reset" } ]
  });
}

test("authorize and reset", function(target, app) {
     onConnectView();

     app.mainWindow().scrollViews()[0].textFields()[0].tap();
     app.keyboard().typeString("user@example.com");

     app.mainWindow().scrollViews()[0].secureTextFields()[0].tap();
     app.keyboard().typeString("doorkeeper");

     app.mainWindow().scrollViews()[0].buttons()["connect"].tap();

     onAuthorizedView();

     app.mainWindow().buttons()["Reset"].tap();
});
