iOS SDK
=======

The iOS SDK for Hasura.


NOTE: 
=====

### This sdk works with Hasura running on version below 0.15



Installation
------------

### Step 1 : Download the Hasura iOS SDK

Using Cocoapods:

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build the Hasura sdk.

To integrate the Hasura sdk into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Hasura', '~> 0.0.2'
end
```

Then, run the following command:

```bash
$ pod install
```

### Step 2 : Setup Hasura

> import Hasura wherever you are using the SDK.

#### Project Config

You set the project name and other hasura-project related things in Project Config object.

```swift
//Minimum Config
let config = ProjectConfig(projectName: "projectName")
```

> Note: The above method can throw a `HasuraInitError`.

Other init params are :

- customBaseDomain: String  - If you have a base domain other than <project-name>.hasura-app.io
- isEnabledOverHttp: Bool   - Set this to true if you want to use Http instead of Https
- defaultRole: String       - "user" role is used by default
- apiVersion: Int           - 1 is used by default

Use the above project config to initialise Hasura.


```swift
Hasura.initialise(config: config, enableLogs: true)
```

***Note***: Initialisation **MUST** be done before you use the SDK.The best place to initialise Hasura would be in your `AppDelegate` class.

Hasura Client
-------------

The `HasuraClient` is the most functional feature of the SDK. It is built using the project config specified on initialisation.
You can get an instance of the client only from Hasura, like so :

```swift
var client = Hasura.getClient();
```

> Note: The above method can throw a `HasuraInitError`.

### Hasura User

`HasuraClient` provides a `HasuraUser` for all of your authentication needs(login, signup etc). This ensures that certain data can only be accessed by authorized users.

You can get an instance of the `HasuraUser` from the `HasuraClient` like so :

```swift
var user = client.currentUser;
```

#### SignUp

```swift
user.username = "username"
user.password = "password"
user.signUp { (isSuccessful: Bool, isPendingVerification: Bool, error: HasuraError?) in
    if isSuccessful {
        if isPendingVerification {
          //The user is registered on Hasura, but either his mobile or email needs to be verified.
        } else {
          //Now Hasura.getClient().currentUser will have this user
        }
    } else {
        //Handle Error
    }
}
```

#### Login

```swift
user.username = "username"
user.password = "password"

user.login { (successful: Bool, error: HasuraError?) in
    if successful {
      //Now Hasura.getClient().currentUser will have this user
    } else {
        //handle error
    }
}
```    

#### LoggedIn User

Each time a `HasuraUser` is signed up or logged in, the session is cached by the `HasuraClient`. Hence, you do not need to log the user in each time your app starts.

```swift
if user.isLoggedIn {
    //User is logged in
} else {
  //User is not logged in
}
```

#### Log Out

To log the user out, simple call `.logout` method on the user object.

```swift
user.logout { (successful: Bool, error: HasuraError?) in
    if successful {

    } else {

    }
}
```

### Data Service

Hasura provides out of the box data apis on the Tables and views you make in your project. To learn more about how they work, check out the docs [here](https://hasura.io/_docs/platform/0.6/getting-started/4-data-query.html)

```swift
client.useDataService(params: [String: Any])
    .responseArray { (response: [MyResponse]?, error: HasuraError?) in
        if let response = response {
            //Handle response
        } else {
            //Handle error
        }
}
```

In the above method, there are a few things to be noted :
- MyResponse is just a swift class/struct - a representation of the response you are expecting. Hasura uses [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) internally to map the json response into your class/struct.

***Note***: In case you are expecting an object response, use `.responseObject`. *All SELECT queries to the data service will return an array response.*

```
If the HasuraUser in the HasuraClient is loggedin/signedup then every call made by the HasuraClient will be authenticated by default with "user" as the default role (This default role can be changed when building the project config)
```

In case you want to make the above call for an anonymous user

```swift
client.useDataService(role: "anonymous", params: [String, Any])
    .responseArray { (response: [MyResponse]?, error: HasuraError?) in
        if let response = response {
            //Handle response
        } else {
            //Handle error
        }
}
```

In case you want to make the above call for a custom user

```swift
client.useDataService(role: "customRole", params: [String, Any])
    .responseArray { (response: [MyResponse]?, error: HasuraError?) in
        if let response = response {
            //Handle response
        } else {
            //Handle error
        }
}
```

***Note***: This role will be sent JUST for this query and ***will not*** become the default role.

### Query Template Service

The syntax for the query template service remains the same as `Data Service` except for setting the name of the query template being used.

```swift
client.useQueryTemplateService(templateName: "templateName", params: [String, Any])
    .responseArray { (response: [MyResponse]?, error: HasuraError?) in
        if let response = response {
            //Handle response
        } else {
            //Handle error
        }
}
```


### Filestore Service

Hasura provides a filestore service, which can be used to upload and download files. To use the Filestore service properly, kindly take a look at the docs [here](https://docs.hasura.io/0.13/ref/hasura-microservices/filestore/index.html).

#### Upload File

The upload file method accepts the following:

- `file`: Data - data to be uploaded.
- `mimetype`: String: the `mimetype` of the file.

```swift
client.useFileservice()
    .uploadFile(file: data, mimeType: "image/*")
    .response(callbackHandler: { (response: FileUploadResponse?, error: HasuraError?) in
        if response != nil {
            print("Successfully uploaded image")
        } else {
            //Handle error
        }
    })
```

`FileUploadResponse` in the above response contains the following:

- `id: String?`: The uniqiue Id of the file that was uploaded.
- `userId: Int?`: The id of the user who uploaded the file.
- `createdAt: Date?`: The time string for when this file was uploaded/created.

#### Download File

```swift
client.useFileservice()
    .downloadFile(fileId: "4F2D59B7-7BD0-400A-9C31-F5A43F29560F")
    .response { (downloadedData, progress, error) in
        guard progress == 100 || progress == -1 else {
            print("Download progress: \(progress)")
            return
        }
        if let file = downloadedData {
            self.imageView.image = UIImage(data: file)
        } else {
            self.handleError(error: error)
        }
}
```

ISSUES
------

In case of bugs, please raise an issue [here](https://github.com/hasura/support)
