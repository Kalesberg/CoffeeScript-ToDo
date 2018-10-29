express = require 'express'

controller = require '../controller/controller'
app = express()
app.get '/', () ->
  console.log '### get /'
  controller.getTodos()
app.get '/:id', () ->
  console.log '### get /:id'
  controller.getTodo()

module.exports.todoRoutes = app;