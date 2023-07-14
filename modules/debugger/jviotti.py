# See https://lldb.llvm.org/python_reference/

# debugger = lldb.SBDebugger
# result = lldb.SBCommandReturnObject
def test(debugger, command, result, internal_dict):
  print(debugger.__class__)
  print(command.__class__)
  print(result.__class__)
  print(internal_dict.__class__)
