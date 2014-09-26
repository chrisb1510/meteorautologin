if Meteor.isClient
  Template.newUser.helpers
    rendered:()->
  #this currently doesn't call, always makes a new user

      Meteor.call "getConnection", (res,err)->
        if err?
      #console.log err
          connection = err.connection
          player = "player"+err.playerNumber
      #console.log connection
        tmpUser = {
          username:player
          password:"default"
          email:"#{player}@my.com"
          profile:
            name:player
            connectionId:connection.id
            currentRoom:'main'
            orig:
              password:true
              username:true
          }



        Accounts.createUser tmpUser,(err)->
          if err?
            console.log err
            return Meteor.users.findOne {'_id':tmpUser._id}


  Meteor.methods
    getConnection:()->
      console.log 'hello'

  Template.userProfile.helpers
    user:()->
      return Meteor.users.findOne Meteor.userId()

    checkDefaultPassword:()->
      Meteor.call 'defaultPasswordChecker', (res)->
        if res.error?
          console.log "L46: pass not default: #{res.error}"
          false
        res
    setPassword:()->
      if Meteor.userId()?
        val = $('input#password').val()
        if val isnt ""
          Accounts.changePassword 'default', val ,(err)->
            if err?
              console.log "L53: change pass error: #{err}"
            else
              console.log 'password changed'
              Meteor.users.update(Meteor.userId(),{$set:{'profile.orig.password': false}} )
              #TODO
              #hide password entry.
              return

    checkDefaultUsername:()->
      if Meteor.user().profile.orig.username is true
        return true
      else
        return false

    setUsername:()->
      if Meteor.userId()?
        val = $('input#userName').val()

        if val isnt ""
          result = Meteor.users.findOne({'username':val})
          if result?
            console.log "L72: user already present"
            passVal = $('input#password').val()
            if passVal isnt ""
              Meteor.loginWithPassword val,passVal, (res,err)->
                if err?
                  console.log "L79: password fail for entered user"
                if res?
                  console.log "L81: valid #{res}"

          else
            console.log 'L74: username Changed'
            Meteor.call 'updateUsername', Meteor.userId(), val, (res,error)->
              if res?
                console.log "user updated #{res}"
              if error?
                console.log "L79: user update error:  #{error}"




  Template.userProfile.events =
    'keydown input#nameChanger':(e)->
      val = $('input#nameChanger').val().display 'none'
      if (e.which == 13 or e.keyCode == 13 ) and val isnt ""
        #code to execute here
          Meteor.call 'updateProfileName', Meteor.userId(), val ,(res) ->
            if res?
              console.log res

    'keydown input#password':(e)->
      if (e.which == 13 or e.keyCode == 13 )
        Template.userProfile.setPassword()

    'keydown input#userName':(e)->
      if (e.which == 13 or e.keyCode == 13 )
        Template.userProfile.setUsername()



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