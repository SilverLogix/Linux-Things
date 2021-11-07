#

import json


data = {
    "username": "logix",
    "active": True,
    "num": 8843.89,
    "id": 42,
}

# ---------------------------- #


def save_all():   # Save ALL data
    with open("data.json", "w") as f1:
        json.dump(data, f1, indent=4)
        f1.close()

        print(data)     # DEBUG

# ---------------------------- #


def save(key: str, val: any):           # Save SOME data
    data[key] = val                     # Assign value and key to change

    with open("data.json", "w") as f2:  # Open file
        json.dump(data, f2, indent=4)   # Add data
        f2.close()                      # Close file

# --------------------------------- #


def load_all():     # Loading ALL data
    global data
    with open("data.json") as f3:
        getdata = json.load(f3)
        data = getdata
        f3.close()

    print(data)     # DEBUG

# ---------------------------- #


def load(key: str):             # Load SOME data
    with open("data.json") as f4:

        ldata = json.load(f4)   # load the file
        val = ldata[key]        # assign val from loaded key
        f4.close()              # close the file

    print(val)     # DEBUG


""" ==================================================== """


def main():
    save_all()
    print("")
    save("num", 777)

    load("username")
    load("id")
    load("num")


if __name__ == '__main__':
    main()
