import { Logger } from "./main.coffee"

Console = Usage::create "logger", (options, cb) ->
  if typeof options is "function" and not cb
    cb = options
    options = {}
  cb new Logger options

export default Console