# Rew Logger
A simple logging utility designed for [rew](https://github.com/kevinJ045/rew)

## Installing
With [pimmy](https://github.com/kevinJ045/rew.pimmy):
```bash
pimmy -Sa rewpkgs/rew.logger
```
With rewpkgs:
```bash
rew install -yu rewpkgs/rew.logger
```
With native:
```bash
rew install -yu github:kevinJ045/rew.logger
```

## Usage
```coffee
import Logger from "rew.logger"

logger = new Logger


logger.log 'hi'

logger.log 'hi', '%c1;32' # custom color
```

## Basic Usage
Create a logger instance and log messages:

```coffee
logger = new Logger

logger.log 'This is a log message'
logger.warn 'This is a warning message'
logger.error 'This is an error message'
```

## Advanced Usage
Customizing the options:
```coffee
options = 
  file:
    path: './logs/app.log'
    style: true
  writeOptions: 'sf' # 's' for console, 'f' for file, 'sf' for both
  formats:
    date: '[YYYY-MM-DD hh:mm:ss]'
    prefix: '[CustomPrefix]'
    suffix: '[CustomSuffix]'
  style:
    color: 'type' # use type-specific colors
    type: true # keep the type prefix like [LOG] and [ERROR]

logger = new Logger options

logger.log 'This is a customized log message'
```

## Disabling and Enabling Console Output
Disable or enable console output dynamically:

```coffee
logger.disableConsoleOutput()
logger.log 'This will not appear in console'

logger.enableConsoleOutput()
logger.log 'This will appear in console'
```

## File Operations
Set a log file and optionally apply styles:

```coffee
logger.setFile './logs/newfile.log', true # Putting `true` will make it so it also includes the ansi encoding and such
logger.log 'This will be logged in newfile.log'
```

Clean the log file content:
```coffee
logger.cleanFile()
```

## Custom Log Colors
Set custom colors for different log types:

```coffee
logger.setStyleColor('1;36') # Set general style color
logger.setTypeColor('log', '1;32') # Set log color to green
logger.setTypeColor('error', '1;35') # Set error color to magenta
logger.setTypeColor('warning', '1;33') # Set warning color to yellow
```

## Without Config
A default instance that you can config.
```coffee
import Logger from "rew.logger/default"

Logger.log 'hi'
```


## Using `using`
There's a `Usage` for the logger.
```coffee
import Console from "rew.logger/usage"

using Console, { style: { logColor: '1;32' } },  (console) ->
  console.log 'hi'
```
Or
```coffee
import Console from "rew.logger/usage"

using Console, (console) ->
  console.log 'hi'
```

## API Reference

### Logger Class

#### Constructor

```coffee
new Logger(options)
```

**Parameters:**

-   `options`: An object to configure the logger.

#### Methods

-   `log(...text)`: Logs a message with 'log' type.
-   `warn(...text)`: Logs a message with 'warning' type.
-   `error(...text)`: Logs a message with 'error' type.
-   `cleanFile()`: Cleans the content of the log file.
-   `disableConsoleOutput()`: Disables console output.
-   `enableConsoleOutput()`: Enables console output.
-   `setFile(file, useStyle)`: Sets the log file path and style.
-   `setDateFormat(format)`: Sets the date format.
-   `setSeparatorFormat(format)`: Sets the separator format.
-   `setPrefix(format)`: Sets a custom prefix.
-   `setSuffix(format)`: Sets a custom suffix.
-   `setStyleColor(color)`: Sets the general log color.
-   `setTypeColor(type, color)`: Sets the log color for a specific type.
-   `disableType()`: Disables type labels in log messages.
-   `enableType()`: Enables type labels in log messages.