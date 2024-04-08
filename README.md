# open-weather

This sample app does the following:

1. Allows the user to search for a city or zip code
1. Reverse geocodes the query using the appropriate open weather API
1. Requests the weather conditions from the latitude/longitude obtained from the reverse geocode request using the appropriate open weather API
1. Displays some of the weather conditions returned by the open weather API call

Additionally:

- Uses the MVVM pattern, view controllers are fed data by view models
- Uses the `Combine` framework, data vended by view models is exposed as a series of combine publishers
- Provides a few units tests for decoding API responses
- Allows the user to pull to refresh on the detail screen to re-request the weather conditions for the same latitude/longitude and updates the UI in response

## Setup

To setup and run the app:

1. Clone the repo

        git clone https://github.com/willbur1984/open-weather-sample.git

2. `cd` into the cloned directory

        cd open-weather-sample

3. Run the setup script

        ./setup.sh

4. Build and run the *open-weather* target