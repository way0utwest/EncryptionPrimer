# Make an HTTP request and read the output
__randomize__ = True

import clr
clr.AddReference("System.Net")
from System.Net import HttpWebRequest

clr.AddReference("System")
from System.IO import StreamReader

# MediaWiki API request for Red Gate article
url = "http://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=txt&&titles=Red%20Gate%20Software"

def main(config):
    return list(read_wiki(column_size=config["column_size"]))

def read_wiki(column_size=50):
    # Create a CLR web request object
    http = HttpWebRequest.Create(url)
    http.Timeout = 5000
    http.UserAgent = "Red Gate SQL Data Generator"
    
    # Read the response with a CLR StreamReader
    response = http.GetResponse()
    responseStream = StreamReader(response.GetResponseStream())
    html = responseStream.ReadToEnd()
    
    # Yield all lines that start with a *,
    # truncated to the column width
    for line in html.splitlines():
        if line.startswith("*"):
            yield line[:column_size]