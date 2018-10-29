mongoose = require 'mongoose'

Todo = require '../model/todo'

getTodos = (req,res) ->
  Todo.find().exec (err,todos) -> 
    if err
        return res.json {'success':false,'message':'Some Error'}
    res.json {'success':true,'message':'Todos fetched successfully','todos':todos } 

addTodo = (io,T) ->  
  newTodo = new Todo T
  newTodo.save (err,todo) -> 
    if err 
      result = {'success':false,'message':'Some Error','error':err }
      console.log result    
    else
       result = {'success':true,'message':'Todo Added Successfully','todo':todo }
       io.emit 'TodoAdded', result

updateTodo = (io,T) ->  
   Todo.findOneAndUpdate { _id:T.id }, T, { new:true }, (err,todo) ->
    if err
       result = {'success':false,'message':'Some Error','error':err}
       console.log result    
    else
       result = {'success':true,'message':'Todo Updated Successfully','todo':todo}
       io.emit 'TodoUpdated', result
    
getTodo = (req,res) -> 
   Todo.find({_id:req.params.id}).exec (err,todo) ->
    if err
       res.json {'success':false,'message':'Some Error'}    
    if todo.length
       res.json {'success':true,'message':'Todo fetched by id successfully','todo':todo}    
    else
       res.json {'success':false,'message':'Todo with the given id not found'}

deleteTodo = (io,T) => 
   Todo.findByIdAndRemove T._id, (err,todo) ->
    if err 
       result = {'success':false,'message':'Some Error','error':err}
       console.log result    
    else 
      result = {'success':true,'message':'Todo deleted successfully', 'todo':todo}
      io.emit 'TodoDeleted', result
   
  

module.exports.getTodos = getTodos
module.exports.addTodo = addTodo    
module.exports.updateTodo = updateTodo  


