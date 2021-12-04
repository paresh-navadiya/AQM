# AQM (Air Quality Monitoring)
Demo project for the air quality monitoring using MVVM in Swift

# Example

### Air Quality Index (Cities)
<img width="641" alt="Air Quality Index List" src="https://user-images.githubusercontent.com/1125736/144711876-5f520557-dc9c-4c0a-8a37-0c22468f345b.png">

### Realtime Graph
<img width="746" alt="Realtime-graph-AQI" src="https://user-images.githubusercontent.com/1125736/144711887-fd699cb6-915f-4bee-90fc-d062bc2ecff4.png">

### Air Quality Index value based its color Info
<img width="746" alt="AQI Info" src="https://user-images.githubusercontent.com/1125736/144711894-10e60f55-0aa2-416e-8bc9-979eabb6223f.png">

# Details

#### WebSocket
- Subscribe to websocket `ws://city-ws.herokuapp.com` to receive Air Quality Indexes for the Cities.
- Pod: `Starscream` => https://github.com/daltoniam/Starscream

#### Design Pattern
Used MVVM design pattern.

- Model: is used as data source.
- View: has ability to show list. i.e. Table and information
- ViewModel: has all the logic and a mediator between `View` & `Model`.

#### Realtime Graph
- Show the realtime graph for the City AQI (Air Quality Index) Data.
- Pod: `Charts` => https://github.com/danielgindi/Charts

#### Unit/UI tests
- Added Unit and UI Tests using `XCTest`.

##### Code Coverage
<img width="641" alt="AQI-Code-Coverage" src="https://user-images.githubusercontent.com/1125736/144712043-6463bff9-35dd-4596-b54b-29449d8e0d39.png">