
export formatDate = (date, format) ->
  pad = (num) -> if num < 10 then '0' + num else num.toString()

  year = date.getFullYear()
  shortYear = year.toString().slice(-2) 
  month = pad(date.getMonth() + 1)
  day = pad(date.getDate())
  hours = pad(date.getHours())
  minutes = pad(date.getMinutes())
  seconds = pad(date.getSeconds())

  formattedDate = format
    .replace 'YYYY', year
    .replace 'YY', shortYear
    .replace 'MM', month
    .replace 'DD', day
    .replace 'hh', hours
    .replace 'mm', minutes
    .replace 'ss', seconds

  return formattedDate


###*
 * @type {({ type, color, date, prefix, suffix } : { prefix?: string, suffix?: string, date?: boolean, type?: boolean, color?: string }) => { type: boolean, color: string, date: boolean, prefix: string, suffix: string }}
*###
export logStyle = struct
  type: true
  color: 'type' # string, default: "type", can be: 'none'
  prefix: ''
  suffix: ''
  date: '[YY-MM-DD hh:mm:ss]' # string, default: "YY-MM-DD hh:mm:ss", can be: 'none'

logFile =
  file: ''
  style: false

###*
 * @type {({ type, text, write, style } : { style?: ReturnType<typeof logStyle>, write?: 'f' | 's' | 'sf', type?: 'log' | 'error' | 'warning', text: string }) => {'type': 'log' | 'error' | 'warning', write: 's' | 'f' | 'sf', text: string, style?: ReturnType<typeof logStyle> }}
*###
export logStruct = struct
  type: 'log' # log | error | warning
  text: ''
  write: 's' # s | f | sf
  '@style': (styles) => match styles, [[logStyle, () => styles], [match.any, () => logStyle(styles || {})]]
  _output: # only used for files 
    file: logFile.file
    style: logFile.style
    separator: 'YYYY/MM/DD' # can be: 'pid'

export setLogFile = (file, useStyle) ->
  logFile.file = file
  if useStyle isnt undefined
    logFile.style = useStyle

export get_type_color = (type, color) ->
  if color isnt 'type' then color
  else switch type
    when 'log' then '1;34'
    when 'warning' then '1;33'
    when 'error' then '1;31'


export get_type_prefix = (type) ->
  switch type
    when 'log' then '[LOG] '
    when 'warning' then '[WARNING] '
    when 'error' then '[ERROR] '

export get_date_prefix = (format) -> formatDate new Date, format.replace('PID', process.pid)
  
export writeToLogFile = (file, content, separator) ->
  today = if separator == 'none' then '' else ('--[ ' + get_date_prefix(separator || 'YY/MM/DD') + ' ]--')
  prev = ""
  if exists file
    prev = read file
  unless separator isnt 'none' and prev.includes today
    prev += '\n' + today
  write file, prev.trim() + '\n' + content

###*
 * @param log {ReturnType<typeof logStruct>}
*###
export writeLog = (log) ->
  log_value = ''

  log_value += log.style.prefix if log.style.prefix 

  if log.style.type
    log_value += get_type_prefix log.type

  if log.style.date isnt 'none'
    log_value += get_date_prefix log.style.date+' '

  log_value += log.text

  log_value += log.style.suffix if log.style.suffix 

  print_value = "\x1b[#{if log.style.color && log.style.color isnt 'none' then get_type_color(log.type, log.style.color) else '0'}m #{log_value} \x1b[0m"

  if log.write.includes 's' then print print_value

  if log.write.includes('f') and log._output.file.length
    writeToLogFile log._output.file, (if log._output.style then print_value else log_value), log._output.separator

parseLogsToText = (text) ->
  text.map((item) -> item.toString()).join ' '

writeTemplateLog = (options, type, text) ->
  color = if options.style.color is 'type' then options.style[type + 'Color'] else options.style.color
  if text[1] and text[1].match('%c')
    color = text[1].split('%c')[1].trim() 
    text.splice(1, 1)
  writeLog
    type: type
    write: options.writeOptions
    text: parseLogsToText(text)
    _output:
      file: options.file.path
      style: options.file.style
      separator: options.formats.separator
    style:
      date: options.formats.date
      prefix: options.formats.prefix if options.formats.prefix.length
      suffix: options.formats.suffix if options.formats.prefix.suffix
      color: color
      type: options.style.type

writeInfoLog = (options, ...text) ->
  writeTemplateLog options, 'log', text
  

writeWarnLog = (options, ...text) ->
  writeTemplateLog options, 'warning', text


writeErrorLog = (options, ...text) ->
  writeTemplateLog options, 'error', text

export Logger = class Logger
  options: {
    writeOptions: 's'
    file:
      path: ''
      style: false
    formats:
      date: '[YY-MM-DD hh:mm:ss]'
      prefix: ''
      suffix: ''
      separator: 'YYYY/MM/DD'
    style:
      color: 'type'
      type: true
      logColor: '1;34'
      errorColor: '1;31'
      warningColor: '1;33'
  }

  constructor: (options) ->
    unless options then options = {}
    for i of options
      if @options[i] and typeof @options[i] isnt "object"
        @options[i] = options[i]
      else
        for j of options[i]
          @options[i][j] = options[i][j]
    @

  log: (...text) -> writeInfoLog @options, text...
  warn: (...text) -> writeWarnLog @options, text...
  error: (...text) -> writeErrorLog @options, text...

  cleanFile: () ->
    if @options.file.path
      write @options.file.path, ''

  disableConsoleOutput: () ->
    @options.writeOptions.replace('s', '') if @options.writeOptions.includes 's'
    @
    
  enableConsoleOutput: () ->
    @options.writeOptions += 's' if not @options.writeOptions.includes 's'
    @

  setFile: (file, useStyle) ->
    @options.writeOptions += 'f' if not @options.writeOptions.includes 'f'
    @options.file.path = file
    if useStyle isnt undefined
      @options.file.style = useStyle
    @
  
  setDateFormat: (format) ->
    @options.formats.date = format || 'none'
    @

  setSeparatorFormat: (format) ->
    @options.formats.separator = format || 'none'
    @

  setPrefix: (format) ->
    @options.formats.prefix = format || ''
    @

  setSuffix: (format) ->
    @options.formats.suffix = format || ''
    @

  setStyleColor: (color) ->
    @options.style.color = color || 'none'
    @
  
  setTypeColor: (type, color) ->
    @options.style[type + 'Color'] = color || Logger::options.style[type + 'Color']
    @

  disableType: () ->
    @options.style.type = false
    @

  enableType: () ->
    @options.style.type = false
    @

