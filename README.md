# Cohorts

Builds and displays cohort data on the orders db

## Be sure to...

* `rake db:create db:migrate`
* Import your data in psql via `COPY users FROM '/path/to/users.csv' WITH (FORMAT csv);` and `COPY orders FROM '/path/to/orders.csv' WITH (FORMAT csv);`
* `rails s`
* Go to `localhost:3000/analyses` in your browser

## Notes

* I use recursion a bit in the `Cohorts` module. I've been doing a lot of functional programming in elixir and it is something I've gotten used to. Sorry if it's difficult to read. I'm just used to it. 
* I like to separate "business logic" from "framework logic" that's why everything having to do with cohort and analysis generation is in a seaparete module from the controller. The controller is only concerned with things like param type casting and setting up the call into our business logic.
* I used `pmap` to paralallize the work of generating the analysis. This might be overkill, but it's fun.
* I started off with a version that took over 10 seconds to run. Now it seems like this takes less than half a second to run. Woo!
* I don't have the `Cohorts` module use active record models directly. I generally access those domain objects through modules/contexts that are a bit more focused on the business domain rather than the data domain. I've found that this is helpful so that people don't just start making DB access calls all over the place.
