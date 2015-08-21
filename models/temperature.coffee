DB = require './db'

errlog = (method, err) ->
  return "MODEL: temperature; Method: #{method}; ERROR: #{err}"

module.exports =

  get_by_rowid: (rowid, cb) ->
    DB.do (db, err) ->
      if err
        cb errlog "get_by_rowid", err
        return false

      sql = db.prepare "SELECT `_rowid_`, * FROM temperature WHERE _rowid_ LIKE ?"
      sql.get rowid, (err, row) ->
        if err
          cb errlog "get_by_rowid", err
          return false

        cb null, row
        return true

  each: (where, desc_order, limit, cb) ->
    if not where then where = '1=1'
    order_by = " ORDER BY time" + if desc_order then " DESC" else ""
    if limit then limitt = " LIMIT #{limit}"
    else limitt = ""
    DB.do (db, err) ->
      if err
        cb errlog "each", err
        return false

      sql = db.prepare "SELECT `_rowid_`, * FROM temperature WHERE #{where}" + order_by + limitt
      sql.each (err, row) ->
        if err
          cb errlog "each", err
        else
          cb null, row
      return true


  add: (row, cb) ->
    if not row.logger? or not row.time? or not row.temperature?
      cb errlog "add", "missing logger id, or time, or temperature."
      return false

    DB.do (db, err) ->
      if err
        cb errlog "add", err
        return false
      else
        new_row =
          $logger: row.logger
          $time: row.time
          $temperature: row.temperature
        sql = db.prepare "INSERT INTO temperature (`logger`, `time`, `temperature`) VALUES ($logger, $time, $temperature)"
        sql.run new_row, (err) ->
          if err
            cb errlog "add", err
            return false
          else
            cb null, new_row
        return true

  update: (row, cb) ->
    if not row.rowid?
      cb errlog "update", "missing logger id."
      return false

    DB.do (db, err) ->
      if err
        cb errlog "update", err
        return false
      else
        sqlo = db.prepare "SELECT `_rowid_`, * FROM temperature WHERE _rowid_ LIKE #{row.rowid}"
        sqlo.get (err, orig_row) ->
          if err
            cb errlog "update", err
            return false

          new_row =
            $logger: row.logger ? orig_row.logger
            $time: row.time ? orig_row.time
            $temperature: row.temperature ? orig_row.temperature

          sql = db.prepare "UPDATE temperature SET `logger`=$logger, `time`=$time, `temperature`=$temperature WHERE `_rowid_`='#{row.rowid}'"
          sql.run new_row, (err) ->
            if err
              cb errlog "update", err
              return false

            cb null, new_row
            return true

  delete: (where, cb) ->
    DB.do (db, err) ->
      if err
        cb errlog "delete", err
        return false

      sql = db.prepare "DELETE FROM temperature WHERE #{where}"
      sql.run (err) ->
        if err
          cb errlog "delete", err
          return false
        cb null
        return true

  delete_by_rowid: (rowid, cb) ->
    return module.exports.delete "`_rowid_`='#{rowid}'", cb
