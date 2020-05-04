# FoodZone

[Fall 2019] Congressional App Challenge (CA-17) - 2nd Place Team Submission

## Inspiration
We were inspired by the courage it takes to be a homeless person constantly in a battle against hunger and wanted to alleviate some of their pain by creating an iOS app. Smartphones are essential to modern life and sources claim that 80% of homeless people have phones.

## What it does
It is a smartphone app that identifies nearby restaurants and chat rooms for these restaurants to provide the user with information like when the restaurant has excess food from other users in likeminded situations. These chat rooms can also be a way for these people to bond and share their story. The app also has a search bar to identify places of interests like car parks, libraries, homeless shelters, or manually entered restaurants with the click of a button.

## How I built it
Using MapKit, we were able to track the user's location and construct a simple search bar to find the nearby places of interests quickly. We used a foursquare API to find all of the restaurants near a user's location and realtime Firebase to create the chat room for each unique restaurant to foster a sense of community.

## Challenges I ran into
Implementing the Foursquare API proved to be challenging. The purpose of using this API was to get a JSON list of nearby venues, but not nearby restaurants specifically. Hence, we had to nest our code multiple times to filter the JSON data in order to encode the information that we want to utilize in the iOS application.

## Accomplishments that I'm proud of
One speciality of the mobile application that we developed is the impact that it would have on society. According to statistics, there are 550,000 homeless people on a given day looking for food, however, there is no efficient way for these individuals to get access to food with ease. With our application, Food Zone, food shelter organizations and homeless people can receive up-to-date access to restaurants near them. Additionally, they can discuss facts and information about each and every individual restaurant with their community. In conclusion, the idea of allowing homeless people to receive access to excess food is something we are proud that we developed.


## What I learned
We learned a lot about querying and usage of APIs. For example, while using Foursquare's API for detecting venues, we had to nest our code to gather an even more specific place, a restaurant.
Additionally, we constantly sent cloud requests to our cloud server, allowing data to be visible to consumers on a cross-network basis, opposing to that of a local server running on something like NodeJS.


## What's next for FoodZone

We wish to add an option where the user can click on annotations on the map to provide directions and distance to the location via Google Maps, Waze, or other flagship navigation applications. We also hope to polish the Restaurant Discussions to create robust speech bubbles and a better user interface.

## Authors
Built by Kevin C, Ishan J, Neeraj R, - official submission can be found [here.](https://www.youtube.com/watch?v=3Bog5Lgk7Rs&feature=youtu.be)
