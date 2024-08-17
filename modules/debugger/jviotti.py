import subprocess
import shlex
import sys

# See https://lldb.llvm.org/python_reference/
import lldb

def make(debugger, command, result, internal_dict):
  """
  Run GNU Make command from within LLDB and stream the output in real-time.

  Usage: make [target]
  """
  make_cmd = ["make"] + shlex.split(command)
  try:
    process = subprocess.Popen(make_cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1)
    for line in iter(process.stdout.readline, ''):
      print(line, end='')
      sys.stdout.flush()
    process.stdout.close()
    return_code = process.wait()
    if return_code != 0:
      result.SetError(f"Make command failed with exit code {return_code}.")
  except subprocess.CalledProcessError as e:
    result.SetError(f"Make command failed: {e}")
  except Exception as e:
    result.SetError(f"An error occurred: {str(e)}")

def gtest(debugger, command, result, internal_dict):
  """
  LLDB command to run Google Test with an optional filter.

  Usage: gtest [test_filter]

  Examples:
  gtest                        - Runs all tests
  gtest MyTestSuite.MyTestCase - Runs tests matching the filter

  This command launches the current target process with the specified
  Google Test filter. If no filter is provided, it runs all tests.
  """
  target = debugger.GetSelectedTarget()
  if not target:
    result.SetError("Error: No target selected. Please select a target before running this command.")
    return

  if command.strip():
    launch_command = f'process launch -- --gtest_brief=1 --gtest_filter={command.strip()}'
    filter_message = f"with filter: {command.strip()}"
  else:
    # Explicitly set the filter to * to run all tests, overriding any previous filter
    launch_command = 'process launch -- --gtest_brief=1 --gtest_filter=*'
    filter_message = "without filter (running all tests)"

  debugger.SetAsync(True)
  res = lldb.SBCommandReturnObject()
  interpreter = debugger.GetCommandInterpreter()
  interpreter.HandleCommand(launch_command, res)

  if res.Succeeded():
    result.AppendMessage(f"Launched process {filter_message}")
  else:
    result.SetError(f"Failed to launch process: {res.GetError()}")
