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

        #Meteor.users.remove {_id:aUser._id},(err,res)->
         # if err?
          #  console.log err
          #else
           # console.log res+"success"
            #console.log Meteor.users.find().count()
           ###





