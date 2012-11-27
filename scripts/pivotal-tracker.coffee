# Description:
#   Automatically respond to messages including that seem to include a
#   Pivotal Tracker story ID with some details about the story. For
#   example, if you say "Who's working on 31445781?", Hubot will
#   respond with:
#
#     feature 31445781 As a user I want to log in (2)
#     http://www.pivotaltracker.com/123456/31445781
#
# Dependencies:
#   "pivotal": "0.1.3"
#
# Configuration:
#   PIVOTAL_TRACKER_TOKEN
#   PIVOTAL_TRACKER_PROJECT_ID
#
# Commands:
#   Listens for \d{8} and responds with user story details and a link
#
# Author:
#   avdgaag

module.exports = (robot) ->
  pt = require 'pivotal'
  pt.useToken process.env.PIVOTAL_TRACKER_TOKEN
  project_id = process.env.PIVOTAL_TRACKER_PROJECT_ID

  robot.hear /\b(\d{8})\b/, (msg) ->
    story_number = msg.match[1]
    return if isNaN story_number

    pt.getStory project_id, story_number, (error, story) ->
      if error
        console.log error
        return
      msg.send "#{story.story_type} #{story_number} (#{story.estimate}): #{story.name}\n#{story.url}"