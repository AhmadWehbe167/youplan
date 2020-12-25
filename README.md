# youplan

mobile application that helps users create and share plans with their friends
so that they can get reminded by a notification a day before. After that the
plans are saved as memories for them to view whenever they want.

In this app I have learned much more than the last flutter project. I have learned to use cloud functions;
one example is using a cloud function to check if a phone number is already registered or it is the first time
trying to log in. I needed to know that because in firebase authentication there is no distinction between phone 
number sign up and log in. a user can give his phone number and he will be authenticated and logged in. Thus, I had 
to check if user is already registered redirect him to log in page and if he isn't redirect him to sign up page.

Also, I learned to use Google maps plugin. When a user is creating a plan he might want to choose a specific place, so
using Google maps allows him/her pick a precise place on the map.

Eventhough I am working on this project alone, I got used to git more. Whenever I start a new feature I branch and then
when finished I push and create a pull request. Then merge from github after that.

As for the database side I leveled up to create much more complicated database and backend. I have created a network where
users can add other users as friends and send them plan requests.
