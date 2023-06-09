# Task CRUD Challenge

Developed with:

* Ruby 3.0.5
* Rails 7.0.5
* SQLite Database

## Initialization:

First, install project dependencies

```sh
bundle install
```

Create database

```sh
rails db:create
```

Run migrations

```sh
rails db:migrate
```

Get a default user and some tasks examples (optional)
```sh
rails db:seed
```

Finally, start the server
```sh
rails s
```
## Usage
### Authentication

You can use default devise token methods to authenticate. Default auth path is `{{host}}`/auth

```sh
POST http://127.0.0.1:3000/auth/sign_in
Content-Type: application/json

{
  "email": "admin@admin.com",
  "password": "strongpassword"
}
```

Then, include the Authorization: Bearer in each request.

Devise token usage at https://devise-token-auth.gitbook.io/devise-token-auth/usage

### CRUD Operations

Crud operations available are

* GET /tasks
* GET /tasks/{id}
* POST /tasks
* PUT /tasks/{id}
* DELETE /tasks/{id}

GET /task params are

* order_by: an atribute to order. Posible values are id, name or description
* order_direction: order asc or desc
* page: Current page of pagination, starting by 1
* per_page: Max tasks per page

All of them are optional. By default, it is order asc, all tasks in one page.

POST and PUT params are

```sh
{
  "name": "The name",
  "description": "An optional field",
  "status": "active" #other values are inactive, in_progress
}
```
## Users

An user has the following fields

* name: Name of the user
* email: Email of the user, it is also the login uid
* password: When sign in, password_confirmation is also required
* user_type: The role of the user, can be normal, editor or admin. Normal users are created by default. This field is not restricted for demo purposes 

## Task model description

A task has the following fields

* Name: Name for the task
* Description: Description of the object
* Status: Current status of the object

Also, you can get the user related to the task by adding to the request
```sh
include=user
```

## Validations and restrictions

* A normal user can read tasks
* An editor user can also create or edit a task
* An admin can manage the tasks, including deletion
* Name is required and must be only number, letters and spaces.
* Description is optional, but cannot be greater than 100 characters
* The name of a task in progress can't be updated

## Test and documentation
A swagger documentation is included at /api-docs. You can interact with the endpoints from 127.0.0.1

Also, the code is tested with rspec, test files are

* spec/models/task_spec.rb
* spec/routing/tasks_routing_spec.rb 
* spec/requests/tasks_spec.rb