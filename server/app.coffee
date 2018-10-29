require('dotenv').config()
express = require 'express'
  , routes = require './routes/main'
  , user = require './routes/user'
  , http = require 'http'
  , path = require 'path'
  , mongoose = require 'mongoose'
  , socket = require 'socket.io'
  , mongoURI =  'mongodb://localhost/to-do-list' || process.env.MONGOLAB_URI 
  , Todo = require('./model/todo').init()


controller = require './controller/controller'

connectRepeat = ->
  console.log 'Mongo URI:', mongoURI
  mongoose.connect mongoURI, (err) -> 
    if err 
      console.error 'Failed to connect to mongo on startup - retrying in 5 sec', err 
      setTimeout connectRepeat, process.env.DB_CONNECT_RETRY
    
connectRepeat() 

mongoose.connection.on 'open', -> 
  console.log 'Connected to Mongodb'

app = express()

app.configure -> 
  app.set 'port', process.env.PORT || 8080
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static path.join(__dirname, 'public')  
  app.use (req,res,next) ->
    res.header "Access-Control-Allow-Origin", "*"
    res.header "Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"
    next()
  app.use '/api', routes
  app.get '/', (req,res) ->
    res.end 'Api working' 
  app.use (req, res, next) ->
    res.status(404).send '<h2 align=center>Page Not Found!</h2>'

app.configure 'development', -> 
  app.use express.errorHandler()


server = http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'


io = socket(server) 
# socket.io connection
io.on 'connection', (socket) ->
  console.log "Connected to Socket!!" + socket.id 
  # Receiving Todos from client
  socket.on 'addTodo', (Todo) ->
    console.log 'addTodo '
    controller.addTodo io,Todo

  # Receiving Updated Todo from client
  socket.on 'updateTodo', (Todo) ->
    console.log 'socketData update'
    todoController.updateTodo io,Todo

  # Receiving Todo to Delete
  socket.on 'deleteTodo', (Todo) ->
    console.log 'socketData delete'
    todoController.deleteTodo io,Todo

    




