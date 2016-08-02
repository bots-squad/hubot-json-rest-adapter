Robot = require('hubot').Robot
Adapter = require('hubot').Adapter
TextMessage = require('hubot').TextMessage
request = require('request')
string = require("string")

# sendmessageURL domain.com/your/path/ + user.channel
sendMessageUrl = process.env.HUBOT_REST_SEND_URL

class WebAdapter extends Adapter
  createUser: (username, room) ->
    user = @robot.brain.userForName username
    unless user?
      id = new Date().getTime().toString()
      user = @robot.brain.userForId id
      user.name = username

    user.room = room

    user

  send: (user, strings...) ->
    if strings.length > 0
      data = JSON.stringify({
        message: strings.shift(),
        from: "#{@robot.name}"
      })
      # The resulting url will be sendMessageUrl + user.room, so sendMessageUrl must include the slash in the end
      url = "#{sendMessageUrl}#{user.room}"
      options = {
        url: url,
        method: 'POST',
        body: data,
        json: true
      }
      request options, (err, res, body) ->
          if err
            console.log "There was an error sending the request to: #{url}"
      @send user, strings...

  reply: (user, strings...) ->
    @send user, strings.map((str) -> "#{user.user.name}: #{str}")...

  run: ->
    self = @

    options = {}

    @robot.router.post '/receive/:room', (req, res) ->
      user = self.createUser(req.body.from, req.params.room)

      if req.body.options
        user.options = JSON.parse(req.body.options)
      else
        user.options = {}

      console.log "[#{req.params.room}] #{user.name} => #{req.body.message}"

      res.setHeader 'content-type', 'application/json'
      res.setHeader 'Access-Control-Allow-Origin', '*'
      res.setHeader 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
      self.receive new TextMessage(user, req.body.message)
      res.end JSON.stringify({status: 'received'})

    self.emit "connected"

exports.use = (robot) ->
  new WebAdapter robot
