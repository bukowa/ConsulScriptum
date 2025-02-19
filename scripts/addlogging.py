import os
import shutil


def add_start_end_to_lua_files(directory, start_var, end_var):
    """
    Iterates through all files in the given directory (recursively) and
    adds the specified start and end variables to the beginning and end
    of each .lua file.

    Args:
      directory: The path to the directory to search.
      start_var: The string to add at the beginning of each .lua file.
      end_var: The string to add at the end of each .lua file.
    """
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".lua"):
                file_path = os.path.join(root, file)
                # clean file path
                try:
                    encoding = 'utf-8'  # Default to UTF-8 if detection fails
                    with open(file_path, "r+", encoding=encoding) as f:
                        content = f.read()
                        f.seek(0)  # Move the cursor to the beginning of the file
                        f.write(
                            f"{start_var.format(file_path[len(directory) + 1:].replace("\\", "/"))}\n{content}\n{end_var.format(file)}")
                except Exception as e:
                    print(f"Error processing file {file_path}: {e}")


if __name__ == "__main__":
    shutil.rmtree("./mod");
    shutil.copytree("./rome2_scripts", "./mod")
    directory_to_process = "mod"
    end_string = """
log:info(tostring(debug.getinfo(1, 'S').source))
""".lstrip()
    start_string = """
--logG = require('script._lib.lib_logging').new_logger("{0}", "{0}.log", "TRACE")
--logR = require('script._lib.lib_logging').new_logger("{0}", "{0}.log", "TRACE")
--logE = require('script._lib.lib_logging').new_logger("{0}", "{0}.log", "TRACE")

--logG:pretty_table(_G)
--logR:pretty_table(debug.getregistry())
--logE:pretty_table(debug.getfenv(0))
--log = require('script._lib.consulscriptum_logging').new_logger("TRACE")
--log:info("started")

local new_path = "script/consulscriptum/?.lua"
if not string.find(package.path, new_path) then
    package.path = package.path .. ";" .. new_path
end

log = require('consulscriptum_logging').new_logger("TRACE")
--log:info(package.path)
--log:stop_trace()
--log:start_trace()
log:pcall(function()
    log:info(tostring(debug.getinfo(1, 'S').source))
end)

""".lstrip()
    add_start_end_to_lua_files(directory_to_process, start_string, end_string)
    os.mkdir("./mod/script/consulscriptum/")
    shutil.copy("./src/script/consulscriptum/logging.lua", "./mod/script/consulscriptum/consulscriptum_logging.lua")
