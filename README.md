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

A listing of all pending actions can be availed and depending on any authorization mechanisim that you have implemented, a user can then access a pending 
action and authorize it.

## Installation

Add this line to your application's Gemfile:

    gem 'four_eyes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install four_eyes

## Usage

To add maker checker functionality, add the following before_filter to the controller in question.
   Sets up a before filter which adds maker checker functionality to the controller
 
     class StudentsController < ApplicationController
       add_maker_checker_to_resource
     end
  
   To exempt any one of the actions
  
     class StudentsController < ApplicationController
       add_maker_checker_to_resource, except: :delete
     end
  
   To include only a subset of the actions
  
     class StudentsController < ApplicationController
       add_maker_checker_to_resource, only: [:create, :update]
     end
  
   Once that is done, in the create, update or delete action you would call the following
   
       maker_create([User resource performaing the action],
                         [ID of resource performing the action],
                         [Class name of the resource being worked on],
                         [Parameters of oject/resource in JSON format])  
   
   For exeample, in a system where the users are called Administrators, and the resource we are trying to create via
   maker checker is a Student, the call to create a student via maker-checker would look like this.
   
   
     def create
         maker_create('Administrator',
                       current_administrator_id,
                       'Student',
                       student_params.to_json)    
     end  
                       
     def update
        maker_update('Administrator',
                     current_administrator_id,
                     'Student',
                     student_params.to_json)   
     end
     
     def destroy
        maker_delete('Administrator',
                     'current_administrator_id,
                     'Student',
                     student.to_json)
     end
     
   where in the example above, the call has the following format

## TODO - Write spec tests.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/four_eyes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
