# Attempts to connect to a specified machine (in this example localhost) on a specific TCP port (25 in this example)
# If the connection is successful, the script will exit silently, otherwise "Exception occurred".
#

try { 
  $tcp=new-object System.Net.Sockets.TcpClient 
  $tcp.connect("localhost",25) 
  $tcp.close() 
} 

# Catch any errors generated, otherwise exits silently.
catch { 
  "Exception occurred" 
}
