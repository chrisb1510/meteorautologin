if Meteor.isServer
  @__COUNTER = 0
  Meteor.startup ->
    Meteor.users.remove { 'profile.orig.password':true,'profile.orig.username':true }
  #hook into a client connection
  Meteor.onConnection (connection)->

    connection.onClose ->
      console.log "connection closed: "+connection.id
      #find the user
      aUser = Meteor.users.findOne({'profile.connectionId':connection.id})
      #assign user removal if either only one of username and password have been set
      if aUser? and (aUser.profile.orig.password == true or aUser.profile.orig.username == true)
        Meteor.users.remove({"_id":aUser._id},(err,res)->
          if res?
            console.log "L16 removed: #{res}"
          if err?
            console.log "L15 remove error: #{err}"
        )

  Meteor.methods
    getConnection:()->
      #grab the connection details from the client
      connection = @connection
      #increase and assign the server variable __COUNTER for usernames, errors when some already exist from testing,
      playerNumber = ++__COUNTER
      console.log "playerNumber returned : #{playerNumber}"
      #return multiple values for de-assignment
      {connection,playerNumber }


    updateProfileName:(userId,val)->
      result = Meteor.users.update userId, {$set:{'profile.name':val} }, {}, (error ,res)->
        if res?
          console.log "user updated #{res}:L35"
          return res
        if error?
          console.log "user update error #{error}:L38"
          return error
      result
    updateUsername:(userId,val)->
      result = Meteor.users.update userId, {$set:{'username':val, 'profile.orig.username':false}}, {}, (error ,res)->
        if res?
          console.log "L44: username updated: #{res}"
          return res
        if error?
          console.log "L47 : username update error: #{error} "
          return error
      result
    defaultPasswordChecker:()->
      password = {digest:"default", algorithm: 'sha-256'}
      res = Accounts._checkPassword Meteor.user(), password
      res.error = null
      console.log "password is default #{res}"
      res
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







