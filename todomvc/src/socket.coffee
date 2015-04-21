io      = require('socket.io')
Todo    = require('./task')

module.exports = (server) ->

  sio   = io.listen(server)
  users = 0

  sio.sockets.on 'connection', (socket) ->
    users++
    socket.emit('count', { count: users })
    socket.broadcast.emit('count', { count: users })

    Todo.find {}, (err, todos) ->
      socket.emit('all', todos)

    socket.on 'add', (data) ->
      Todo.create content: data.content, (err, todo) ->
        throw err if err 
        socket.emit('added', todo)
        socket.broadcast.emit('added', todo)

    socket.on 'delete', (data) ->
      Todo.remove data.id, (err) ->
        throw err if err
        socket.emit('deleted', data )
        socket.broadcast.emit('deleted', data)

    socket.on 'edit', (data) ->
      updates = content: data.content
      Todo.update data.id, updates, (err, todo) ->
        throw err if err
        socket.emit('edited', todo)
        socket.broadcast.emit('edited', todo)

    socket.on 'changestatus', (data) ->
      Todo.setDone data.id, (err) ->
        throw err if err
        socket.emit('statuschanged', data)
        socket.broadcast.emit('statuschanged', data)

    socket.on 'disconnect', ->
      users--
      socket.emit('count', { count: users })
      socket.broadcast.emit('count', { count: users })