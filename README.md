Http Utils is a way to handle json request responses with a bigger control of the keys that this json contains. 
Multiple times we make our models to parse jsons with only the key of the map, but if one of them fails we will only know what misses or has incorrect types watching the output of the console. Instead, with this package a specific **body exception** will be thrown, containing if it was null or if it was an incorrect value type or if key is not coming.

It also comes with a **http_exception** model, that can handle in an easier way how your requests fails.
With this exception you can centrify all the exceptions that occurs in the requests with a simple dialog or a customizable one single widget.

## Features

#### Body Utils
- Parse simple json keys
- Parse multiple json keys
- Determine if this key can be nullable
- Give a default value in case this key is null

#### Http Exception
- Receives a message
- A Code
- A Reason
- A Status Http code

## Usage

#### For Body Utils

```dart
    factory RequestData.fromJson (dynamic json) {
        return RequestData(
            id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
            name: jsonField<String> (json, ["name",],  nullable: false),
            number: jsonField<num> (json, ["number"],  nullable: false),
            integer: jsonField<int> (json, ["integer",],  nullable: false),
            shortMap: jsonField<dynamic> (json, ["short_map",],  nullable: false),
            date: DateTime.fromMillisecondsSinceEpoch(
                jsonField<int> (json, ["date", "\$date"]),
            )
        );
    }

    // Where is called
    try {

        RequestData myData = RequestData.fromJson (response_body);
    } on BodyException catch (error) {
        // Handle Exception
    }
```

#### For Http Exception
```dart
    
    try {

        final response = http.get (
            Uri, 
            headers: {}
        )

        switch (response.statusCode) {
            case 200:
                //Success Action
            break;
            default:
                //Error
                throw HttpException (
                    response.body,
                    code: Code.request,
                    reason: Reason.server,
                    status: response.statusCode
                )
        }
    
    } on HttpException {
        rethrow
    } catch (error) {
        throw HttpException (
            error.toString,
            code: Code.system,
            status: -1
        )
    }
```
