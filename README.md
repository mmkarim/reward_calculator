# Reward Calculator
Live Demo: https://reward-calculator.herokuapp.com/

# How to run in local

Download/clone the project in your local repo. This project is without database so no need to configure anything for database.
Just run ```bundle install``` command to install all the gems and you are good to start the server with `rails s` command.

Download sample test csv file from here: https://drive.google.com/file/d/12dauOnBZlw1xRwCm33FtpGwF2M_K7gSf/view

Go to http://localhost:3000 and submit the sample csv file to see the result.


# CSV format

- It should contain three headers:  `customer_name`,`action`,`invitee_name`.

- Value of `action` column can only be `"recommends"` or `"accepts"`.

- If the value of `action` column is `"recommends"`, the row should contain value for both `customer_name` and `invitee_name`.

- If the value of `action` column is `"accepts"`, value of `customer_name` should be present.

- The input order should be in the sequence as they happened.

Exp:



| customer_name | action |invitee_name|
| ------ | ------ |------|
| A | recommends | B |
| B | accepts | |
| B | recommends | C |
| C | accepts | |
| C | recommends | D |
| B | recommends | D |
| D | accepts | |



Smaple csv file can be downloaded from here: https://drive.google.com/file/d/12dauOnBZlw1xRwCm33FtpGwF2M_K7gSf/view

# Steps I took to solve the problem

- Firstly, wrote a hepler module `CsvHelper` that will extract and filter the given csv file and returns a array of hashes.
 `app/services/concerns/csv_helper.rb`
- Created a service class where I will implement the logic.
`app/services/reward_logic.rb`

- I decided to use 2 Hashes. `@customer` hash for storing customer informations like reward points and inviter. `@invitation` hash will keep information about who invites whom.

- In `@customer` hash, key will be customer_name and value will be another hash like this `{name: "B", reward: 0, inviter_name: "A"}`

- In `@invitaion`, key will be invitee name and value will be inviter_name/customer_name.
- All set, now lets talk about logic. For a "recommondations" input, at first it checks if the invitee already exists in `@invitation` hash or not. if not it makes a entry there. If inviter not a customer yet, it will create one in `@customer` hash.
But if invitee already got an recommendation before, it ignores the recommendation.

- For an "accepts" input, it will check `@invitation` hash first to see if there's an invitation exists or not. If yes, it creates a new customer and distributes rewards point to the inviter.

- Distributing reward point will happen recursively. `distribute_reward_point` method will find the customer and adds reward point according to the level. After that it checks that customer's inviter and call itself with that inviter's name again with one level up value. The recursion will happen until it reaches the final inviter.
- To avoid looping scenario while distributing reward points recursively, some checkings added while processing a input. Like, someone can not accepts an invitation if he's a customer already or someone can not send recommendation to someone who's already a customer.
