# EMS Mobile App

The EMS Mobile App is a mobile application that allows EMTs to better find a hospital for their patients. The application consists of 3 components: a Django backend, Python Webscraper and an iOS app.

## Install Guide

### Prerequisites
- For the iOS app, a Mac Computer is needed
- Install XCode and Swift 5
- Install Python 3.8 with pip and virtualenv
- Clone the Git repository

### Download Instructions
1. In terminal, navigate to the folder where you would like to save the project
2. Clone the project to this location using ```git clone https://github.com/ryantobin77/6235_EMS_Project.git```
3. A repository named "6235_EMS_Project" now exists

### Dependent libraries
- All dependent libraries can be found in the repo directory at ```6235_EMS_Project/Backend/EMS_Django_Backend/requirements.txt```  and are also listed below
- See Build Instructions for the Django Backend below to install the following dependent libraries:
- Install asgiref
- Install beautifulsoup4
- Install bs4
- Install certifi
- Install chardet
- Install Django
- Install geographiclib
- Install geopy
- Install idna
- Install lxml
- Install numpy
- Install pandas
- Install python-dateutil
- Install pytz
- Install requests
- Install six
- Install soupsieve
- Install sqlparse
- Install urllib3
- Install wheel

### Build Instructions
#### Django Backend and Python Webscraper
1. Initialize your virtualenv with ```virtualenv venv``` in the root directory. Do not push this to Git
2. Activate virtualenv with ```source venv/bin/activate```
3. Go into the backend directory ```cd Backend/EMS_Django_Backend```
4. Install dependent libraries with ```pip install -r requirements.txt```
5. Run migrations ```python manage.py migrate```
6. The Django Backend is now built and ready to run

#### iOS App
1. Open up XCode
2. Click File > Open
3. Navigate to the repo's root directory and go into "EMS\ iOS\ App" and click on "EMS\ iOS\ App.xcodeproj" and click open
4. Within XCode, click Product > Build to build the project

### Installation Instructions
- No additional installation is required to run the application

### Run Instructions

#### Run Instructions for Django Backend
In terminal, from the root directory of the repo with virtualenv activated, run the following:

```bash
cd Backend/EMS_Django_Backend
python manage.py runserver
```

#### Run Instructions for Python Webscraper
In a separate terminal window, from the root directory of the repo with virtualenv activated, run the following:

```bash
cd Backend/EMS_Django_Backend
python schedule.py
```

#### Run Instructions for the iOS App
1. Make sure both the Django Backend and Python Webscraper are running
2. Open up XCode
3. Click File > Open
4. Navigate to the repo's root directory and go into "EMS\ iOS\ App" and click on "EMS\ iOS\ App.xcodeproj" and click open
5. In the top left of the XCode window, select a simulator to run the application
6. Press the play button to run the app
7. Wait a few seconds and the iOS simulator will open with the application
8. If the distances of the hospitals seem off (i.e. they are super far), please see step 3 of the iOS App Troubleshooting section below. You likely need to give the simulator a location.

### Troubleshooting

#### Django Backend and Python Webscraper
There should be no errors that occur during installation / running the project, but If you do run into any errors, verify the following:
1. Ensure you are running python 3.8. Earlier versions of python are not compatible with this application.
2. Ensure all dependencies are installed as detailed above in the build instructions
3. Ensure you are running the Django backend and Python webscraper with virtualenv activated. Failure to do so will not allow the application to run with the correct dependencies
4. Make sure you have ran the migrations as detailed above in the build instructions or hospital data will be unable to be loaded into the database
5. Ensure you have an internet connection. Our data is scraped from the Georgia RCC website (georgiarcc.org), so a stable internet connection is required
6. If the application seems to be unable to load hospital data, check the Georgia RCC website (georgiarcc.org) and ensure it is not experiencing any issues.

#### iOS App
There should be no errors that occur during installation / running the project, but if you do run into any errors, verify the following:
1. Ensure your Mac has the latest software installed and is updated
2. Ensure the latest version of XCode is installed along with Swift 5. Earlier versions of Swift are not compatible with this app.
3. Our application is dependent on location. Ensure the simulator has a location to use:
    - When the simulator opens, click on the simulator. Click Features > Location > Custom Location
    - We recommend using the following location: lat = 33.77718 and long = -84.39235
