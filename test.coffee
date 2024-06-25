import Logger from "./default.coffee"

Logger
  .setFile realpath './main.log'
  .setSeparatorFormat 'MM/DD'
  .setTypeColor 'error', '31'
  .setTypeColor 'warning', 'none'
  .disableType()
  .setDateFormat 'none'

Logger.log 'hi', '%c1;32'
Logger.error 'hi'
Logger.warn 'hi'