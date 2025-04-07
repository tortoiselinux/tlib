# Tlib

Tlib is a library for tortoise scripts, this lib contains a lot
of functions to write simple programs and scripts that can help
you.

See bellow a few util things that Tlib could help you:

- [x] A simplier way to import code
- [x] Easy and flexible CMD applications
- [x] Simple file/directory manipulation
- [x] Execute shell commands

# How to use

## Importing Tlib

To use Tlib in your lua programs you need to import the library.
If tlib.lua is in the same directory that your Lua program, just
use 'require'

```Lua
local tlib = require("tlib")
```

as a regular lua library, you can easily put that in the LUA_LIBPATH
that is usually /usr/lib/lua/5.x

	mv /usr/lib/lua/5.x
	
then, you can import using require.

I like to have Tlib as a git submodule in my projects that i've use it
So I can use and do modifications quickly.

to import Tlib from a directory in you project tree you can do:

```Lua
-- put tlib repository in LUA_PATH
	package.path = package.path .. string.format(";./%s/?.lua", "<your_submodulepath>/tlib")
	
local tlib = require("tlib")
```

That is my favorite way to do that.

## Tlib usage examples

### Import function

The import function is one of the coolest things that Tlib has.
Is a function that allow you to easily import things whithout
modify by hand the LUA_PATH.

when you import tlib you need to modify the `LUA_PATH` or put
tlib inside a directory that already is in `LUA_PATH`.

```Lua
-- put tlib repository in LUA_PATH
	package.path = package.path .. string.format(";./%s/?.lua", "<your_submodulepath>/tlib")
	
local tlib = require("tlib")
```

but when you have tlib, you can easily do:
```Lua
local module = tlib.import("path/to/module")
```

The format to Import things is the path to module and then
the module at the end of your path. You don't need to provide
a .lua extension to import the module.

### Manipulation of command line arguments

#### parse args

You can use this function to parse variadic parameters of
a function. This is used in tlib by itself to parse arguments
when is executing shell commands, for example.


```Lua
function tlib.exec(...)
	local cmd = tlib.parse_args(...)
	return os.execute(cmd)
end
```

without this function you will need to parse manually.

```Lua
function tlib.exec(...)
	local cmd = table.concat(args, " ")
	return os.execute(cmd)
end
```

#### check arguments

check_args takes a command line argument, a table of supported
arguments and a function, if the argument passed is equal to one 
of the arguments in the table, the function will be executed

```Lua
tlib.check_args(argi, expected, func)
```

Use example:
```Lua
for i in ipairs(arg) do
	tlib.check_args(arg[i], {'h', '-h', 'help', '--help'}, help)
	tlib.check_args(arg[i], {'v', '-v', 'verbose', '--verbose'}, verbose)
end
```

#### Verify args

That function takes two arguments and returns true if both are equivalent
```Lua
tlib.verify_args(argi, expected)
```

Use example:

```Lua
if tlib.verify_args(arg, {'y', '-y', '--yes'}) == false then
	print("set everything as yes by default")
else
	questions()
end
```

#### Get a specific argument

That function takes an argument from argument list using a index number.


Use example:

```Lua
tlib.get_arg(arg, 2)
```

### File/Directory manipulation

#### Creating Files

To create a empty file use mkfile
```Lua
tlib.mkfile(filename)
```

But, if you need to write a file with a content and diferent write acess
you can use the `write_file` function.
```Lua
tlib.write_file(filename, access, content)
```
if you don't know about access permissions, see the list bellow:

- "r" Read-only mode and is the default mode where an existing file is opened.
- "w" Write enabled mode that overwrites the existing file or creates a new file.
- "a" Append mode that opens an existing file or creates a new file for appending.	
- "r+" Read and write mode for an existing file.
- "w+" All existing data is removed if file exists or new file is created with read write permissions.
- "a+" Append mode with read mode enabled that opens an existing file or creates a new file.

list taken from: https://www.tutorialspoint.com/lua/lua_file_io.htm

#### Read Files
To read a file is very simple, just use the `read_file` function that
returns the file content

```Lua
tlib.read_file(filename)
```

#### Verify if a file exists

To verify if a file exist use the `file_exist` function, this function
returns true if file exists and false if not

```Lua
tlib.file_exist(filename)
```

#### Manipulate directories

Create:

```Lua
tlib.mkdir(dir)
```

List:

```Lua
tlib.ls(dir)
```

Delete:

```Lua
tlib.rmdir(dir)
```

### Execute Shell commands
To execute Shell commands we have two functions
tlib.exec(...)
tlib.run(...)
### 📄 **Functions Overview**

#### `tlib.exec(...)`

Executes a shell command constructed from variadic arguments. Returns the execution status using `os.execute`. Does **not** capture output.

#### `tlib.run(...)`

Executes a shell command and captures its output (stdout and stderr). Returns the output string, a success flag, the exit code, and the full command string.

---

### ⚖️ **Comparison: `tlib.exec` vs `tlib.run`**

| Feature                 | `tlib.exec`                          | `tlib.run`                                           |
|-------------------------|--------------------------------------|------------------------------------------------------|
| Executes command?       | ✅ Yes                                | ✅ Yes                                                |
| Captures stdout?        | ❌ No                                 | ✅ Yes                                                |
| Captures stderr?        | ❌ No                                 | ✅ Yes (via `2>&1`)                                   |
| Returns exit code?      | ✅ Yes (depends on platform)          | ✅ Yes (detailed with `io.popen`)                     |
| Use case                | Simple command execution             | Command execution with output inspection             |
| Richer abstraction?     | ❌ Minimal wrapper                    | ✅ Full-featured with output and error information    |

# 📚 Tlib Documentation

**Tlib** is a standard library for TortoiseLinux development, built to simplify scripting and automation tasks. It provides utility functions for:

- Command-line parsing
- File and directory manipulation
- Shell command execution
- Module importing

---

## 🧩 Module Importing

### `tlib.import(full_path)`

Dynamically adds a path to `package.path` and imports a Lua module.

```lua
local module = tlib.import("path/to/module")
```

**Returns**: `module, updated_package_path, path, modname`

---

## 📦 Argument Utilities

### `tlib.parse_args(...)`

Parses variadic arguments into a single command string.

```lua
local cmd = tlib.parse_args("ls", "-la", "/etc")
-- returns: "ls -la /etc"
```

---

### `tlib.check_args(argi, expected, func)`

Executes `func()` if `argi` matches any of the `expected` arguments.

```lua
tlib.check_args(arg[i], {"-h", "--help"}, show_help)
```

---

### `tlib.verify_args(argi, expected) → boolean`

Returns `true` if any item in `argi` matches an item in `expected`.

```lua
if tlib.verify_args(arg, {"--yes", "-y"}) then confirm() end
```

---

### `tlib.get_arg(argi, index)`

Returns the argument at the given index from a list.

```lua
local filename = tlib.get_arg(arg, 2)
```

---

## 📁 File and Directory Manipulation

### `tlib.write_file(filename, access, content)`

Writes `content` to a file using the given `access` mode.

```lua
tlib.write_file("data.txt", "w", "hello world")
```

---

### `tlib.read_file(filename) → string`

Reads and returns the contents of a file.

---

### `tlib.mkfile(filename)`

Creates an empty file.

---

### `tlib.file_exist(filename) → boolean`

Checks if a file exists.

---

### `tlib.mkdir(dir)`

Creates a new directory using `mkdir`.

---

### `tlib.rmdir(dir)`

Deletes a directory using `os.remove`.

> ⚠️ Currently only removes empty directories.

---

### `tlib.ls(dir)`

Runs `ls` in the specified directory.  
> Note: Output is not returned — it should probably be improved to use `tlib.run`.

---

## 💻 Shell Command Execution

### `tlib.exec(...)`

Executes a command using `os.execute`. Does not capture output.

```lua
tlib.exec("echo", "Hello")
```

---

### `tlib.run(...) → output, success, exit_code, cmd`

Runs a shell command and captures its output (`stdout` + `stderr`).

```lua
local output, ok, code, cmd = tlib.run("ls", "/tmp")
```

---

### 🔍 Comparison: `tlib.exec` vs `tlib.run`

| Feature                 | `tlib.exec`                          | `tlib.run`                                           |
|-------------------------|--------------------------------------|------------------------------------------------------|
| Executes command?       | ✅ Yes                                | ✅ Yes                                                |
| Captures stdout?        | ❌ No                                 | ✅ Yes                                                |
| Captures stderr?        | ❌ No                                 | ✅ Yes (via `2>&1`)                                   |
| Returns exit code?      | ✅ Yes (depends on platform)          | ✅ Yes (detailed with `io.popen`)                     |
| Use case                | Simple command execution             | Command execution with output inspection             |
| Richer abstraction?     | ❌ Minimal wrapper                    | ✅ Full-featured with output and error information    |

---

## 🛠️ Miscellaneous

### `tlib.check_lib(lib_table)`

Prints all keys and values from a Lua table — useful for debugging libs or configs.

```lua
tlib.check_lib({ foo = "bar", version = "1.0" })
```

---

## ✅ License

MIT — Do whatever you want, just give credit.

Author: [Wellyton “welly”](mailto:welly.tohn@gmail.com)

---

# 📚 Tlib Documentation

**Tlib** is a standard library for TortoiseLinux development, built to simplify scripting and automation tasks. It provides utility functions for:

- Command-line parsing
- File and directory manipulation
- Shell command execution
- Module importing

---

## 📑 Table of Contents

- [Module Importing](#module-importing)
- [Argument Utilities](#argument-utilities)
- [File and Directory Manipulation](#file-and-directory-manipulation)
- [Shell Command Execution](#shell-command-execution)
- [Comparison: `tlib.exec` vs `tlib.run`](#comparison-tlibexec-vs-tlibrun)
- [Miscellaneous](#miscellaneous)
- [License](#license)

---

## 🧩 Module Importing

### `tlib.import(full_path)`

📄 Dynamically adds a path to `package.path` and imports a Lua module.

💡 Example:
```lua
local module = tlib.import("path/to/module")
```

📤 Returns: `module, updated_package_path, path, modname`

---

## 📦 Argument Utilities

### `tlib.parse_args(...) → string`

📄 Parses variadic arguments into a single command string.

💡 Example:
```lua
local cmd = tlib.parse_args("ls", "-la", "/etc")
-- "ls -la /etc"
```

---

### `tlib.check_args(argi, expected, func)`

📄 Executes `func()` if `argi` matches any of the `expected` arguments.

💡 Example:
```lua
tlib.check_args(arg[i], {"-h", "--help"}, show_help)
```

---

### `tlib.verify_args(argi, expected) → boolean`

📄 Returns `true` if any item in `argi` matches an item in `expected`.

💡 Example:
```lua
if tlib.verify_args(arg, {"--yes", "-y"}) then confirm() end
```

---

### `tlib.get_arg(argi, index) → string | nil`

📄 Returns the argument at the given index from a list.

💡 Example:
```lua
local filename = tlib.get_arg(arg, 2)
```

---

## 📁 File and Directory Manipulation

### `tlib.write_file(filename, access, content)`

📄 Writes `content` to a file using the given `access` mode (`"w"`, `"a"`, etc).

💡 Example:
```lua
tlib.write_file("data.txt", "w", "hello world")
```

---

### `tlib.read_file(filename) → string | nil, error`

📄 Reads and returns the contents of a file.

💡 Example:
```lua
local content, err = tlib.read_file("config.txt")
```

---

### `tlib.mkfile(filename)`

📄 Creates an empty file.

---

### `tlib.file_exist(filename) → boolean`

📄 Checks if a file exists.

---

### `tlib.mkdir(dir)`

📄 Creates a new directory using the shell `mkdir`.

⚠️ Relies on external `mkdir` command (POSIX).

---

### `tlib.rmdir(dir)`

📄 Deletes a directory using `os.remove`.

⚠️ Only works on empty directories.

---

### `tlib.ls(dir)`

📄 Lists files in the directory using `ls`. *(Output printed directly)*

⚠️ Consider replacing with a version that returns results.

---

## 💻 Shell Command Execution

### `tlib.exec(...)`

📄 Executes a command using `os.execute`. Does not capture output.

💡 Example:
```lua
tlib.exec("echo", "Hello")
```

---

### `tlib.run(...) → output, success, exit_code, cmd`

📄 Runs a shell command and captures its output (`stdout` + `stderr`).

💡 Example:
```lua
local output, ok, code, cmd = tlib.run("ls", "/tmp")
```

---

## 🔍 Comparison: `tlib.exec` vs `tlib.run`

| Feature                 | `tlib.exec`                          | `tlib.run`                                           |
|-------------------------|--------------------------------------|------------------------------------------------------|
| Executes command?       | ✅ Yes                                | ✅ Yes                                                |
| Captures stdout?        | ❌ No                                 | ✅ Yes                                                |
| Captures stderr?        | ❌ No                                 | ✅ Yes (via `2>&1`)                                   |
| Returns exit code?      | ✅ Yes (depends on platform)          | ✅ Yes (detailed with `io.popen`)                     |
| Use case                | Simple command execution             | Command execution with output inspection             |
| Richer abstraction?     | ❌ Minimal wrapper                    | ✅ Full-featured with output and error information    |

---

## 🛠️ Miscellaneous

### `tlib.check_lib(lib_table)`

📄 Prints all keys and values from a Lua table — useful for debugging.

💡 Example:
```lua
tlib.check_lib({ foo = "bar", version = "1.0" })
```

---

## ✅ License

MIT — Do whatever you want, just give credit.

Author: [Wellyton “welly”](mailto:welly.tohn@gmail.com)

---