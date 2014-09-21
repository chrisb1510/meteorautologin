if Meteor.isServer
  @__COUNTER = 0
  Meteor.startup ->
    Meteor.users.remove {'profile.default':true}

  Meteor.onConnection (connection)->
    connection.onClose ->
      console.log "connection closed"+connection.id
      aUser = Meteor.users.findOne({'profile.connectionId':connection.id})
      if aUser? and aUser.profile.default == true
        Meteor.users.remove({"_id":aUser._id},(err,res)->
          if res?
            console.log res
          else
            console.log err
        )

  Meteor.methods
    getConnection:()->
      connection = @connection
      #console.log connection
      __COUNTER++
      connection

    insertMessage:(message)->
      result = Messages.insert {
        owner:message.owner
        message:message.message
        created:message.created
        room:message.room},(err,res)->
          if res?
            res
          if err?
            err





