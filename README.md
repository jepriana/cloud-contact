# Cloud Contact App

This is a contact management app which is an example of implementing Firebase as a backend for a Flutter based app.

## Download Repository

Download the repository onto your computer using the `git clone` command.

```
git clone https://github.com/jepriana/cloud-contact
```

## Get Pubspec Dependencies

Open your terminal and navigate to active directory to the repository location. Use the `flutter pub get` command to download the dependencies this project needs.

```
flutter pub get
```

## Prepare Firebase API Key and Real Time Database
![Authentication page](https://github.com/jepriana/cloud-contact/blob/main/screenshots/001.jpg)
## Set API Key and Realtime Database End-Point

To run this application, a suitable API server configuration is required. Add a new file named .env to the root project folder. The file is an environment variable file for configuring the API Key and server address. Provide two line parameter with the name API_KEY and BASE_URL followed by an equal sign and value of the API Key and address of the API server.

```
API_Key=<Your API Key>
BASE_URL=<API URL>
```
An example if the API KEY is `AIzaSyDRabcdgeJdfSmkHbRhDe5lKU2SLEJJU` and Realtime Database server is running on `https://test-project-default-rtdb.asia-southeast1.firebasedatabase.app`:
```
API_Key=AIzaSyDRabcdgeJdfSmkHbRhDe5lKU2SLEJJU
BASE_URL=https://test-project-default-rtdb.asia-southeast1.firebasedatabase.app
```
## Run the Cloud Contact App

Still in the terminal, use the `flutter run` command to run the application.

```
flutter run
```