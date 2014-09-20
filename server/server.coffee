if Meteor.isServer
  @__COUNTER = 0
  Meteor.startup ->

  Meteor.onConnection (connection)->

    connection.onClose = ->
      console.log "bye #{connection.id}"



  Meteor.methods
    getconnection:(tmpuser)->
        connection = @connection
        console.log connection
        __COUNTER++
        connection


