fs     = require 'fs'
path   = require 'path'
cfg    = require '../config.json'
if cfg.DEBUG
  sqlite = require("sqlite3").verbose()
else
  sqlite = require "sqlite3"

dbfile = path.join process.cwd(), cfg.db.filename
objDB  = null

exports.create = (cb) ->
  fs.exists dbfile, (exists) ->
    if exists
      cb "DB file already exists."
      return false
    else
      # create the database
      sample_db_file = path.join process.cwd(), "./data/sample.db"
      fs.createReadStream sample_db_file
        .pipe fs.createWriteStream dbfile

exports.open = (cb) ->
  objDB = new sqlite.Database dbfile, sqlite.OPEN_READWRITE, (err) ->
    if err
      objDB = null
      cb err
    return objDB

exports.is_open = ->
  return if objDB then true else false

exports.close = (cb) ->
  if not this.is_open()
    cb "DB not open"
    return false
  else
    objDB.close (err) ->
      if err
        cb err
        return false
      else
        return true

exports.getDB = ->
  objDB

exports.do = (cb) ->
  if not this.is_open()
    this.open (err) ->
      if err
        cb null, err
        return false
  cb objDB, null
  return true
