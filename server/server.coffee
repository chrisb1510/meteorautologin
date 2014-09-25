if Meteor.isServer
  @__COUNTER = 0
  Meteor.startup ->
    Meteor.users.remove { 'profile.orig':true }

  Meteor.onConnection (connection)->
    connection.onClose ->
      console.log "connection closed"+connection.id
      aUser = Meteor.users.findOne({'profile.connectionId':connection.id})
      if aUser? and aUser.profile.orig == true
        Meteor.users.remove({"_id":aUser._id},(err,res)->
          if res?
            console.log res
          if err?
            console.log err
        )

  Meteor.methods
    getConnection:()->
      connection = @connection
      #console.log connection
      playerNumber = ++__COUNTER
      console.log playerNumber
      {connection,playerNumber }

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
    updateProfileName:(userId,val)->
      Meteor.users.update userId, {$set:{'profile.name':val}}, {},(err,res)->
        if err?
          console.log err
        if res?
          console.log res
    defaultPasswordChecker:()->
      password = {digest:"default", algorithm: 'sha-256'}
      res = Accounts._checkPassword Meteor.user(), password
      res.error = null
      console.log res
      res








