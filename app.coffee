express = require 'express'

app = express()

logger = require './models/logger.coffee'
# db.create (err) ->
#   console.error err

# db.do (objDB, err) ->
#   if err
#     console.log err
#   else
#     console.log "DB open successfully"
#     stmt = objDB.prepare "INSERT INTO `logger`(`id`,`description`,`legend`,`type`,`cipher`) VALUES (?,?,?,?,?);"
#     for i in [1..10]
#       stmt.run [i, "A test logger \##{i}", "Logger \##{i}", 1, "QWERT"], (err) ->
#         console.error err
#     stmt.finalize()
#     db.close()
for i in [1..10]
  new_logger =
    description: "This is the Test logger \##{i}"
    legend: "Logger \##{i}"
    type: logger.TYPE_TEMPERATURE
  logger.add new_logger, (err, row) ->
    if err
      console.error err
    else
      console.log "Successfully add Logger #{row.$uuid}, #{row.$legend}"
