if Meteor.isClient


  if Meteor.user()
    console.log Meteor.user()

  else
    tmp = Random.id()
    tmpUser = {
      username:tmp
      password:"default"
      email:"#{tmp}@my.com"
      profile:
        name:"player#{tmp}"
        connectionId:"null"
        currentRoom:'main'
        orig:true
    }
    console.log tmpUser

    Accounts.createUser tmpUser,(err)->
      if err?
        console.log err
        err


#dont know why this returns as an error
  Meteor.call "getConnection", (res,err)->
    if err?
      #console.log err
      connection = err.connection
      playerNum = err.playerNumber
      #console.log connection
      Meteor.users.update(Meteor.userId(),{$set:{'profile.connectionId':connection.id,'profile.name':"player"+ playerNum}})
#console.log "hello this only runs on the client"

  Meteor.methods
    getConnection:()->
      console.log 'hello'

  Template.userProfile.helpers
    user:()->
      return Meteor.users.findOne Meteor.userId()
  Template.passwordCheck.helpers
    checkDefaultPassword:()->
      Meteor.call 'defaultPasswordChecker', (res)->
        if res
          console.log res
          false


    setPassword:()->
      if Meteor.userId()?

        Accounts.changePassword 'default', $('newPassword').val() ,(err)->
          if err?
            console.log err






#needs a template autorun somewhere in here, unsure where at the moment
  Template.userProfile.events
      'keydown input#nameChanger':(e)->
        val = $('input#nameChanger').val()
        if (e.which == 13 or e.keyCode == 13 ) and val isnt ""
        #code to execute here
          Meteor.users.update(Meteor.userId(),{$set:{'profile.name':val,'profile.orig':false}})



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
      if Meteor.user()?
        return Messages.find {"room":Meteor.user().profile.currentRoom },{limit:50}
      else
        return Messages.find {"room":"main" },{limit:50}