## Exploration
This is a simple word guessing game built with sinatra. [Try it out!](https://csrail-hangman.herokuapp.com/start)

A word, that is longer than five characters, is randomly generated from a dictionary file. You have 7 chances to guess the secret word otherwise you fail your mission!

## Exposition

This application uses sessions in order to keep a working memory of data between HTTP requests. Assigning data to a session is the same as assigning data to a variable. You would do it this way:

```ruby
session[:name_describing_data] = instance_of(DataType)

# OR

session['name_describing_data'] = instance_of(DataType)
```

Once you have assigned data to a session, you would call it with `session[:name_describing_data]` within your RESTful routes:

```ruby
get '/' do
  session[:name_describing_data]
end
```

This sesssion object, as far as I am aware, can only ever hold onto one data type - therefore it is inevitable to use many session objects. Calling session objects one after another in this fashion, though important for understanding the flow of the project, would lead to a lot of repetition. To DRY this up, one should implement these sesssion objects within a helper method:

```ruby
helpers do
  def variables
    @secret_word = session[:secret_word]
    @guess = session[:guess]
    @incorrect_guess_history = session[:incorrect_guess_history]
  end
end
```

Then call these helpers into the route:

```ruby
get '/' do
  variables  
  #now feed @secret_word, @guess, @incorrect_guess_history into some Ruby logic
end
```

Where the terminal I/O uses `gets` to receive user input and `puts` to display it on the terminal, the set up in sinatra differs. For input, the interface is a form with the POST action and on redirection, data is then saved in session object for later use:

```ruby
post '/' do
  session[:guess] = params[:guess].downcase
end
```

For output, the embedded ruby within the views need to be set up so that the session only appears for that moment. This can be a little tricky to set up since you need to set a conditional within the view - to show the results when they are in an active state (that is, a result to be shown) - and a resting state needs to be set up in your back end logic.

```html
<!-- Conditionals in view
  –––––––––––––––––––––––––––––––––––––––––––––––––– -->
<article class="response__article">
  <% if session[:response] != "" %>
    <p class="response__paragraph--metroid-gif"></p>
  <% end %>
  
  <p class="response__paragraph">
    <%= session[:response] %>
  </p>  
</article>
```

```ruby
# /* Back end logic
#  –––––––––––––––––––––––––––––––––––––––––––––––––– */

helpers do
  def validate_input
    one_character_only
    letters_only
    no_repeats
    session[:response] = "" #the resting state
  end
  
  def one_character_only
    if @guess.length != 1
      session[:response] = "One character only"
      redirect to('/') 
    end
  end
  
  def letters_only
    #code with appropriate session[:response] assigned
  end
  
  def no_repeats
    #code with appropriate session[:response] assigned
  end
end
```

```html
# /* Conditionals in view
#  –––––––––––––––––––––––––––––––––––––––––––––––––– */
<article class="response__article">
  <% if session[:response] != "" %>
    <p class="response__paragraph--metroid-gif"></p>
  <% end %>
  
  <p class="response__paragraph">
    <%= session[:response] %>
  </p>  
</article>
```


## Excursion

This is a pretty cool snippet of code; I am trying to convey the total number of letters to guess with max health and number of letters left to guess as the remaining health:

```html
<article class="boss__article">
  <div class="boss__div--image"></div>
  <div class="boss-life-bar__div">
    <% @result_display.select{|l| ("a".."z").include? l }.length.times.each do %>
      <div class="boss-max-life__div"></div>
    <% end %>
    
    <% @result_display.select{|l| l=="_"}.length.times.each do %>
      <div class="boss-life-left__div"></div>
    <% end %>  
  </div>
</article>
```

It connects Ruby logic with instances of html elements which then allows for styling on top of this.

Initially I wanted to render out max health and life remaining - but with the way flow works in CSS, it would be very difficult to set this up without configuring each and every element. This was not the solution.

Instead, the max health of the boss would be implicit - growing depending on the number of elements inside. Therefore all we needed to do is create elements for both life lost and life remaining.

## Expletives

The word list retrieved from [scrapmaker.com](http://scrapmaker.com/view/twelve-dicts/5desk.txt) for this hangman game has a lot of redundancies. Some entries within the source file are not either not proper words are irrelevant proper nouns.

Trying to achieve responsive design on elements that must maintain proportion during resizing is a nightmare. I tried a lot of different combinations with `background-size`, `background-position` and media queries to no avail. So I ended up ditching the entire process and kept it as simple as possible.

Another way around this is to set up the back end to look for the User-Agent and redirect them based on whether they were using a mobile, ipad or desktop. A nifty little solution I heard about from a Front End developer at my local Ruby meet up.

## Eggs

The skin for this application is none other than Super Metroid!

The initial landing page is the first level of Super Metroid - the Ceres Space Station.