# FourEyes

A gem to implement the maker-checker principle. The 4-eyes principle.

Maker-checker (or Maker and Checker, or 4-Eyes) is one of the central principles of authorization in the information systems 
of financial organizations.The principle of maker and checker means that for each transaction, there must be at least two 
individuals necessary for its completion. While one individual may create a transaction, the other individual should be involved 
in confirmation/authorization of the same. Here the segregation of duties plays an important role. In this way, strict control 
is kept over system software and data, keeping in mind functional division of labor between all classes of employees.

(courtesy Wikipedia)

Working with institutions such as financial institutions you may be required to restrict some actions to be done by two pairs of eyes.
FourEyes makes it easy to do this by adding minimal code to the controller with the actions you would like to have verified.

For every action that needs to be authorized, an action containing all the details is stored together with the changes required. 
The new object or changes are stored on JSON format.
This is done after a validation check to ensure that the object will pass validation during the authorization stage. You are 
responsible for performing the validation check to see if the resource is indeed valid. However, this cannot be guaranteed because 
the system state may change before authorization to a state that renders the action invalid. In such a scenario, the action 
would need to be cancelled and created again.

A listing of all pending actions can be availed and depending on any authorization mechanism that you have implemented, a user can then access a pending 
action and authorize it.
       
## Installation

Add this line to your application's Gemfile:

    gem 'four_eyes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install four_eyes
    
Generate the migrations required
    
    $ rails g four_eyes
    $ rake db:migrate
    
## Upgrading
    
### Upgrading from v0.1.x to v1.0.x
    
Switching to version 1 changes the implementation of the maker and checker resources to be 
polymorphic relations of the action object. A assignable polymorphic relation has also been added to the actions 
object so that a maker can easily (if desired) assign a pending action to someone specific for authorization. 

To upgrade to v1.0.x run

    rails g four_eyes:upgrade_four_eyes_one
    
to perform the migrations and changes necessary to the four_eyes_actions table to cater for polymorphism of the 
maker, checker, and assignable. Run migrations:
    
    rake db:migrate
    
Run the rake task:
    
    rake four_eyes_tasks:upgrade_to_version_one 
      
This does some clean up, specifically setting the checker_type column which did not exist before.

### Upgrading from v1.0.x to v2.0.x

Switching to version 2 introduces a new model, `FourEyes::Attachment` that enables attaching files to `FourEyes::Action`s,
An `Action` can have many `Attachment`s, which can, in turn, have multiple pages.

To upgrade to v2.0.x run

    rails g four_eyes:upgrade_four_eyes_two

to generate the migration that adds the four_eyes_attachments table. Run migrations:

    rake db:migrate

### Database Setup

Generate the migration files required by running:

    rails g four_eyes

## Usage

To add maker checker functionality, add the following before_filter to the controller in question.
   Sets up a before filter which adds maker checker functionality to the controller
 
     class StudentsController < ApplicationController
       add_maker_checker_to_resource
     end
  
   To exempt any one of the actions
  
     class StudentsController < ApplicationController
       add_maker_checker_to_resource except: :delete
     end
  
   To include only a subset of the actions
  
     class StudentsController < ApplicationController
       add_maker_checker_to_resource only: [:create, :update]
     end
  
   Once that is done, in the create, update or delete action you would call the following

       maker_create([Resource eg. user performing the action],
                     [Class name of the resource being worked on],
                     [Parameters of object/resource in JSON format],
                     [(Optional) suggested assignee of the action])  
   
   For example, in a system where the users are called Administrators, and the resource we are trying to create via
   maker checker is a Student, the call to create a student via maker-checker would look like this.
   
   
     def create
         maker_create(current_administrator,
                       'Student',
                       student_params.to_json,
                       assignee_administrator)    
     end  
                       
     def update
        maker_update(current_administrator,
                     student,
                     student_params.to_json,
                     assignee_administrator)   
     end
     
     def destroy
        maker_delete(current_administrator
                     student,
                     student.to_json,
                     assignee_administrator)
     end
     
   Minimal views have been provided for viewing pending and authorized actions. You will probably want to override these
   and style them accordingly to your application. 
   
   Please note four_ayes is agnostic for the type of authorization system you are using. Right now the only check that is performed is 
   ensuring that the maker of an action cannot be the same person to authorize an action. You can extend this to your own authorization
   system. For example using CanCan you can have something like this for a certain role:
   
   
   
       class AdminAbility
         include CanCan::Ability
         
         def initialize(admin)
           admin ||= Administrator.new
           if admin.role? :Manager
             can :authorize, FourEyes::Action, object_resource_class_name: %w(Student Teacher)
             can :cancel, FourEyes::Action
           end
         end
       end 

## Attaching Files to Actions

four_eyes includes an integration with [ActiveStorage](https://edgeguides.rubyonrails.org/active_storage_overview.html) 
that allows you to attach files to four_eyes action.

> **Note:**
> Usage of this feature requires ActiveStorage to have been set up in yor Rails project. To learn how to set up ActiveStorage,
> please refer to the [official ActiveStorage documentation](https://edgeguides.rubyonrails.org/https://edgeguides.rubyonrails.org/active_storage_overview.html#setup)..
 
A `FourEyes::Action` can have multiple `` which in turn canhave multiple `pages`. 
The `pages` property on `FourEyes::Attachment` is an ActiveStorage [has_many_attached](https://edgeguides.rubyonrails.org/active_storage_overview.html#has-many-attached) relationship and has all the methods and functionality provided by ActiveStorage. 

### Attaching Files

This is done using the [`attach`](https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/Many.html#method-i-attach) methods on the `:files` property of `FourEyes::Action`, like so.

```ruby
action = maker_create(current_user, Gallery.name, gallery_params.except[:images])
attachment = action.attachments.create(name: "Result Slip", data: { semester: 1, year: 3 })
attachment.pages.attach(gallery_params[:images])
```

### Checking for Attached Files

To check for attached files, use the [`attached?`](https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/Many.html#method-i-attached-3F) method.

```ruby
action = FourEyes::Action.first
attachment = action.attachments.first
attachment.pages.attached?
```

### Detaching Attached files

To detach files attached to a `FourEyes::Attachment`, use the [`purge`](https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/Many.html#method-i-detach) method.

```ruby
action = FourEyes::Action.first
attachment = action.attachments.first

attachment.files.purge # <= # Synchronously destroy the avatar and actual resource files.
# OR
attachment.files.purge_later # <= # Destroy the associated models and actual resource files async, via Active Job.
```

### Accessing Attached files

ActiveStorage provides a number of ways to access attached files. Please refer to the Rails Guides to find out different
ways of [serving](https://edgeguides.rubyonrails.org/active_storage_overview.html#serving-files),
[downloading](https://edgeguides.rubyonrails.org/active_storage_overview.html#analyzing-files),
[analyzing](https://edgeguides.rubyonrails.org/active_storage_overview.html#analyzing-files) and 
[displaying](https://edgeguides.rubyonrails.org/active_storage_overview.html#displaying-images-videos-and-pdfs) files 
stored via ActiveStorage.

## TODO - Write spec tests.h

## Contributing

1. Fork it ( https://github.com/[my-github-username]/four_eyes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
