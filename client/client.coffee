if Meteor.isClient


  if Meteor.userId() is null
    tmp = Random.id()
    tmpuser = {
      username:tmp
      password:"default"
      email:"#{tmp}@my.com"
      profile:
        name:"player#{tmp}"
        connectionid:"null"
    }
    console.log "new user:"+tmpuser

    Accounts.createUser tmpuser

    Meteor.call "getconnection", (res,err)->
      if res?
        console.log "RES: "+ res
      else
        console.log err

  else
    console.log Meteor.user()





  console.log "hello this only runs on the client"
  Meteor.methods
    setUserId:(user)->
      console.log user
  Template.userprofile.helpers
      user:()->
        return Meteor.user()

