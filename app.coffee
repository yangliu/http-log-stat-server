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
# for i in [1..10]
#   new_logger =
#     description: "This is the Test logger \##{i}"
#     legend: "Logger \##{i}"
#     type: logger.TYPE_TEMPERATURE
#   logger.add new_logger, (err, row) ->
#     if err
#       console.error err
#     else
#       console.log "Successfully add Logger #{row.$uuid}, #{row.$legend}"
logger.get_all_uuid (err, uuids) ->
  if err then console.error err
  else
    logger.get_by_uuid uuids[3], (err, row) ->
      if err then console.error err
      else
        console.log 'get_by_uuid', row
    # logger.all "`uuid` LIKE '%4%'", (err, row) ->
    #   if err then console.error err
    #   else
    #     console.log 'each', row
    # # logger.delete uuids[2], (err) ->
    #   if err then console.error err
    #   else
    #     console.log "Item #{uuids[2]} has been removed Successfully."
    # new_row =
    #   uuid: uuids[3]
    #   description: "New description"
    #   legend: "UPDATE#1"
    #   cipher: "NEW"
    #
    logger.update new_row, (err, row) ->
      console.log row
