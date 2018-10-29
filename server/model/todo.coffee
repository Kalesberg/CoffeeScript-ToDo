
# This is the to-do model
mongoose = require 'mongoose'
init = () ->
    TheSchema = new mongoose.Schema
        title: String,
        complete: Boolean
    
    mongoose.model 'Todo', TheSchema


module.exports.init = init;
