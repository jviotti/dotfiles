# See https://lldb.llvm.org/python_reference/
import lldb

# debugger = lldb.SBDebugger
# command = Arguments, as a string, passed to the command
# result = lldb.SBCommandReturnObject
def test(debugger, command, result, internal_dict):
  '''A sample test function'''
  print(debugger.__class__)
  print(command.__class__)
  print(result.__class__)
  print(internal_dict.__class__)

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
    launch_command = f'process launch -- --gtest_filter={command.strip()}'
    filter_message = f"with filter: {command.strip()}"
  else:
    # Explicitly set the filter to * to run all tests, overriding any previous filter
    launch_command = 'process launch -- --gtest_filter=*'
    filter_message = "without filter (running all tests)"

  debugger.SetAsync(True)
  res = lldb.SBCommandReturnObject()
  interpreter = debugger.GetCommandInterpreter()
  interpreter.HandleCommand(launch_command, res)

  if res.Succeeded():
    result.AppendMessage(f"Launched process {filter_message}")
  else:
    result.SetError(f"Failed to launch process: {res.GetError()}")
