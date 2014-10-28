== README

Inspiration
-------------

I wanted an application that would help me find good concerts to go to. I also wanted it to help me discover artists
that I hadn't already heard of. I wanted to see an exhaustive list of shows in my town within a timeframe that I set.
Ideally, I would then be able to select some of the artists that seemed interesting and create a mix in my Spotify account.
This sort of application would allow me to listen to the artists coming to my town and see if I actually wanted to go see the live show.
This is exactly what I have built here.


The Specifics
--------------

This web app is built with Ruby on Rails, jQuery, HAML, and JavaScript.

It is live at https://concertplaylist.herokuapp.com (it may take 10 - 15 seconds to load
since I am hosting it for free on Heroku right now)

Application Flow

1. First, login with your Spotify
2. Select a city and a date timeframe
3. You will then be taken to a page with all the artists playing shows in that city's metro area in the specified timeframe
4. You can click Songkick to go the artist's Songkick page or click "listen" to hear that artist's top track on Spotify
5. Select the artists you find interesting, put in a name for your playlist, and then click generate
6. A playlist containing songs from the artists you selected will be sent to your Spotify account

If a city you want is not in the drop down list, open an issue on the project and I will add it for you.
