# a Stackoverflow clone
(learning Ruby on Rails)

User strories:
----
Guest can sign up

User can log in and log out (gem devise)

User can ask questions

User can post answers to a question (ajax)

User can comment questions and answers (ajax)

User can edit or delete his question or answer (ajax)

User can vote for (or against) a question or answer (ajax)

User can add one or more files when creating answer or asking a question

User can delete his files

Question author can accept any answer as the best answer (but there is always no more than one best answer for a given question)

### Publish/subscribe
After user adds or deletes an answer, question or comment these updates are published to other users who are viewing corresponding page in browser (gem private_pub)

### OAUTH
User can sign in from one or more OAUTH providers, e.g. Facebook

### REST API with OAUTH2 (gem doorkeeper)
User can view questions and answers using API

User can create questions and answers using API after authorizing with OAUTH2 (gem doorkeeper)

### Localization
Localisation is supported with config/locales (instead of hardcoded strings)

### Authorization
User authorization is done with gem cancancan

### Mailings
User can subscribe to a question to receive email when a new answer is posted to that question

Question author is automatically subscribed to his questions

Each user receives daily digest with a list of new questions added yesterday (gem whenever)

These mailings are deferred and delivered later with ActiveJob and Sidekiq

### TDD, BDD
Project is tested with RSpec, Capybara(-webkit)

There are tests for models and controllers

User stories are covered with a set of feature tests

### Full text search with Sphinx
User can do search with several search options:
* everything in project (questions, answers, comments, etc.)
* only for a certain kind of objects (e.g. only within answers)
* search for questions, including text in every answer or comment it contains

Some advanced technics are used in this project, including but not limited to:
* thin controllers with responders
* concerns
* shared examples
* rubocop recomendations and Rails Best Practices are respected

### Deployment
Project is deployed to production with Capistrano
