# Open a file and filter the results
__randomize__ = True

filename = r"Scripting\cities.txt"

def main(config):
    filepath = config["generator_path"] + "\\" + filename
    return list(cities(filepath))

def cities(filepath):
    with open(filepath) as cities:
        for city in cities:
            if city.startswith(tuple("ABDCEFG")):
                yield city.strip()
