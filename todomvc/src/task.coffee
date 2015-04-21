
config      = require('../config')
Teambition  =  require('teambition')

tokenService = new Teambition()

class TaskAPI  

  constructor: ->
    @teambition = new Teambition()

  getToken: (code, callback) ->
    tokenService.post '/oauth2/access_token',
      client_id: config.client_id
      client_secret: config.client_secret
      code: code
    , callback

  find: (conds, callback) ->
    @teambition.get "/tasklists/#{config._tasklistId}/tasks", callback

  create: (data, callback) ->
    data._tasklistId = config._tasklistId
    @teambition.post '/tasks', data, callback

  remove: (_id, callback) ->
    @teambition.del '/tasks/' + _id, callback

  update: (_id, data, callback) ->
    @teambition.put '/tasks/' + _id, data, callback

  setDone: (_id, callback) ->
    @teambition.put '/tasks/' + _id, {isDone: true}, callback

module.exports = new TaskAPI



