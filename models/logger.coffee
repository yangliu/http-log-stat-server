crypto = require 'crypto'
uuid   = require 'node-uuid'
DB     = require './db.coffee'

exports.TYPE_TEMPERATURE = 1
exports.TYPE_PRESSURE = 2

exports.get_by_uuid = (uuid, cb) ->
  err_pos = "MODEL: logger; Method: get; ERROR: "
  DB.do (db, err) ->
    if err
      cb err_pos + err, null
      return false
    else
      sql = db.prepare "SELECT * FROM logger WHERE `uuid` LIKE '?'"
      sql.get uuid, (err, row) ->
        if err
          cb err_pos + err, null
          return false
        else
          cb null, row
      return true

exports.each = (where="1=1", cb) ->
  err_pos = "MODEL: logger; Method: each; ERROR: "
  DB.do (db, err) ->
    if err
      cb err_pos + err, null
      return false
    else
      sql = db.prepare "SELECT * FROM logger WHERE #{where}"
      sql.each (err, row) ->
        if err
          cb err_pos + err, null
        else
          cb null, row
      return true

exports.all = (where="1=1", cb) ->
  err_pos = "MODEL: logger; Method: all; ERROR: "
  DB.do (db, err) ->
    if err
      cb err_pos + err, null
      return false
    else
      sql = db.prepare "SELECT * FROM logger WHERE #{where}"
      sql.all (err, rows) ->
        if err
          cb err_pos + err, null
          return false
        else
          cb null, rows
      return true

exports.get_all_uuid = (cb) ->
  err_pos = "MODEL: logger; Method: get_all_id; ERROR: "
  DB.do (db, err) ->
    if err
      cb err_pos + err, null
      return false
    else
      sql = db.prepare "SELECT id FROM logger"
      sql.all (err, rows) ->
        if err
          cb err_pos + err, null
          return false
        else
          id_list = (row.uuid for row in rows)
          cb null, id_list
      return true

exports.delete = (uuid, cb) ->
  err_pos = "MODEL: logger; Method: delete; ERROR: "
  DB.do (db, err) ->
    if err
      cb err_pos + err, null
      return false
    else
      sql = db.prepare "DELETE FROM logger WHERE `uuid` LIKE '?'"
      sql.run id, (err) ->
        if err
          cb err_pos + err, null
          return false
        else
          cb null
      return true

gen_cipher = () ->
  crypto
    .createHash 'md5'
    .update crypto.randomBytes 128
    .digest 'hex'

exports.add = (row, cb) ->
  if not row.legend? or not row.type?
    cb "Missing logger legend or logger type."
    return false

  add_row =
    $uuid: uuid.v4()
    $description: row.description ? ""
    $legend: row.legend
    $type: row.type
    $cipher: gen_cipher()
  DB.do (db, err) ->
    if err
      cb err
      return false
    else
      sql = db.prepare "INSERT INTO logger (`uuid`,`description`,`legend`,`type`,`cipher`) VALUES ($uuid, $description, $legend, $type, $cipher)"
      sql.run add_row, (err) ->
        if err
          cb err
          return false
        else
          cb null, add_row
      return true

exports.update = (row, cb) ->
  if not row.uuid?
    cb "Missing logger UUID!"
    return false
  this.get_by_uuid row.uuid, (err, orig_row) ->
    if err
      cb err
      return false
    else
      update_row =
        $description: row.description ? orig_row.description
        $legend: row.legend ? orig_row.legend
        $type: row.type ? orig_row.type
        $cipher: row.cipher ? orig_row.cipher
      if row.cipher?
        update_row.$cipher = gen_cipher()
      DB.do (db, err) ->
        if err
          cb err
          return false
        else
          sql = db.prepare "UPDATE logger SET `description`=$description, `legend`=$legend, `type`=$type, `cipher`=$cipher WHERE `uuid`='#{row.uuid}'"
          sql.run update_row, (err) ->
            if err
              cb err
              return false
            else
              cb null, update_row
          return true
