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
        currentRoom:'main'
    }
    console.log tmpUser

    Accounts.createUser tmpUser,(err,res)->
      if res?
        console.log res
        res
      else
        console.log err
        err
  else
    console.log Meteor.user()
#dont know why this returns as an error
  Meteor.call "getConnection", (res,err)->
    if err?
      #console.log {connection:err}
      connection = err
      #console.log connection
      Meteor.users.update(Meteor.userId(),{$set:{'profile.connectionId':connection.id}})
#console.log "hello this only runs on the client"

  Meteor.methods
    getConnection:()->
      console.log 'hello'

  Template.userProfile.helpers
    user:()->
      return Meteor.user()
  Template.userList.helpers
    listOfUsers:()->
      return Meteor.users.find {}

  Template.chat.events =
    'click #chatSub':(e)->
      message = $('input#entry').val()
      if message? and message isnt ""
        Meteor.call 'insertMessage',
          owner:Meteor.userId()
          message:message
          created:new Date()
          room:Meteor.user().profile.currentRoom
  Template.chat.helpers
    chatMessages:()->
      return Messages.find({"room":Meteor.user().profile.currentRoom},{limit:50})