# To-Do List App

## Introduction

This is a very simple to-do list app that you can use to track your day-to-day activities

This document provides the instructions to run the project as well as understand it properly

## Production App

The app is hosted under: https://peaceful-citadel-89094-7d120facc462.herokuapp.com

---

## Configuration

### Project

Install Ruby 3.3.5 (you can use RVM or asdf):
- https://rvm.io/
- https://github.com/asdf-vm/asdf

Setup the project with the command:

```
bundle install
```

### Assets

In order to project load all assets needed, run the following command:

```
bundle exec rake assets:precompile
```

### Database

You can use [Docker](https://www.docker.com/) to run Postgres on your machine without any plus configuration

PS: It's important to use the same values for user and password when configuring your postgres to match the config/database.yml file

```
docker run --name postgsql # add variables from database.yml
```

Create the databases:

```
bundle exec rails db:create
```

Run database migrations:

```
bundle exec rails db:migrate
```

Run web server:
```
bundle exec rails s
```

## Key Features

- OpenAI Integration - When creating a description for the task, sometimes is hard to think of a succint title name, right? The app will handle the title based on your task's description
- Reload-less app - Smooth experience using technologies like Turbo Rails
- Complete lifetime of a task - from pending to archived with a flexible approach for changing the status

## Bugs / Future Improvements

### Bugs

- Confetti not working as expected when an action interrupts the JS execution (such as a request happening while confetti not ended its animation)
- Sometines double-clicks when action is not completed yet is sending multiple requests
- When you perform an action, the existing/selected filters are gone

### Future Improvements

- Add Google Calendar integration for due date reminders
- Add "are you sure?" + alerts/notices
- Add cron job for archiving completed tasks after 7 days
- Make assets/code reusable using components
- Improve design (try to make more modern)
- Clean BE & FE (FE: try to separate styles into proper files, BE: improve controller to make it non-redundant)
- Add search tasks by title
- Pagination
- Many more...
