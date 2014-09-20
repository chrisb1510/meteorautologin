if Meteor.isServer
  @__COUNTER = 0
  Meteor.startup ->
    Meteor.users.remove {}

    Meteor.onConnection (connection)->

      connection.onClose ->
        console.log "connection closed"+connection.id
        user = Meteor.users.findOne {'profile.connectionId':connection.id}
        if user.profile.default is true
          Meteor.users.remove {_id:user._id},(err,res)->
            if err?
              console.log err
            else
              console.log res+"success"
        console.log user
      return




Meteor.methods
    getConnection:()->
        connection = @connection
        console.log connection
        __COUNTER++
        connection


