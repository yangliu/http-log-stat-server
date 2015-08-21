express = require 'express'

app = express()

logger = require './models/logger'
temp = require './models/temperature'
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

getRand = (min, max, round) ->
  num = Math.random()*(max-min+1)+min
  if round?
    round = Math.floor round
    num = Math.round(num * Math.pow(10, round))/Math.pow(10,round)
  return num

getRandInt = (min, max) ->
  return Math.floor getRand(min, max)


logger.get_all_uuid (err, uuids) ->
  if err then console.error err
  else
    # logger.get_by_uuid uuids[3], (err, row) ->
    #   if err then console.error err
    #   else
    #     console.log 'get_by_uuid', row
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
    # logger.update new_row, (err, row) ->
    #   console.log row
    # for i in [1..5]
      # tmplogger = uuids[getRandInt(0,uuids.length-1)]
      # for j in [1..7]
      #   tmp = getRand -3.0, 45.0, 2
      #   newtemp =
      #     logger: tmplogger
      #     time: Date.now()
      #     temperature: tmp
      #
      #   temp.add newtemp, (err, new_row) ->
      #     if err then console.error err
      #     else
      #       console.log new_row
      # temp.each null,null,null, (err, row) ->
      #   console.log row
    temp.get_by_rowid 32, (err, row) ->
      console.log row
      new_row =
        rowid: row.rowid
        temperature: 55.0
      temp.update new_row, (err, nrow) ->
        console.log nrow
      temp.delete_by_rowid 5, (err) ->
        if err then console.error err
