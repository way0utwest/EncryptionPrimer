# Read an XML file
__randomize__ = True

# Use the CLR XML libraries
import clr
clr.AddReference("System.Xml")
from System.Xml.XPath import XPathDocument, XPathNavigator

# A sample XML file 
filename = r"Scripting\BookStore.xml"

def main(config):
    filepath = config["generator_path"] + "\\" + filename
    return list(books(filepath, column_size=config["column_size"]))

def books(filepath, column_size=50):
    # Locate all titles of books in this document
    doc = XPathDocument(filepath)
    nav = doc.CreateNavigator()
    expr = nav.Compile("/bookstore/book/title")
    titles = nav.Select(expr)

    for title in titles:
        # Truncate titles to the column size before yield
        yield str(title)[:column_size]