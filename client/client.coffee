if Meteor.isClient


  if Meteor.userId() is null
    tmp = Random.id()
    tmpUser = {
      username:tmp
      password:"default"
      email:"#{tmp}@my.com"
      profile:

        name:"player#{tmp}"
        connectionId:"null"
        default:true
    }
    console.log "new user:"+tmpUser

    Accounts.createUser tmpUser
  else
    console.log Meteor.user()

  Meteor.call "getConnection", (res,err)->
    if err?
      console.log {connection:err}
      connection = err
      console.log connection
      Meteor.users.update(Meteor.userId(),{$set:{'profile.connectionId':connection.id}})








  console.log "hello this only runs on the client"
  Meteor.methods

    getConnection:()->
      console.log @connection

  Template.userProfile.helpers
    user:()->
      return Meteor.user()
  Template.userList.helpers
    listOfUsers:()->
      return Meteor.users.find {}

