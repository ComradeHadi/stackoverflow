# a Stackoverflow clone
(just for learning Rails)

User strories:
----
Guest can sign up

User can log in (and log out) [gem devise is used]

User can ask questions

User can post answers to a question (ajax - without page reload)

User can comment questions and answers (ajax)

User can edit or delete his question or answer (ajax)

User can vote for (or against) a question or answer (ajax)

User can add one or more files when creating answer or asking a question

User can delete his files

Question author can accept any answer as the best answer (but there is always no more than one best answer for a given question)

### Publish/subscribe
After user adds (or deletes) an answer, question or comment, these updates are published to other users, who are viewing corresponding page in browser (with PrivatePub)

### OAUTH
User can sign in from one or more OAUTH providers, e.g. Facebook or Twitter (with email confirmation)

### REST API with OAUTH2 (gem doorkeeper)
User can view questions and answers using REST API

User can create question or answer (after authorizing with OUATH2)

### Localization
Supported with config/locales (instead of hardcoded strings)

### Authorization
User authorization is done with cancancan

### Mailings
User can subscribe to a question to receive a email when new answer is posted to that question

Question author is automatically subscribed to his question

Each user receives a daily digest with a list of new question added yesterday (gem whenever)

These mailings are deferred and delivered later with ActiveJob and Sidekiq

### TDD, BDD
Project is tested with RSpec, Capybara(-webkit)

Every user story is covered with a set of feature tests

### Full text search with Sphinx
User can do search with several search options:
* everything in project (questions, answers, comments)
* only for a certain kind of objects (e.g. only within answers)
* search for questions, including every answer or comment it contains

Some advanced technics are used in this project, including but not limited to:
* thin controllers with responders
* concerns
* shared examples
* rubocop recomendations and Rails Best Practices are respected

### Deployment
Project is deployed to production with Capistrano
