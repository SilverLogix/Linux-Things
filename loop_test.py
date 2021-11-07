#


import timeit


def while_loop(n=100_000_000):
    i = 0
    s = 0
    while i < n:
        s += i
        i += 1
    return s


def for_loop(n=100_000_000):
    s = 0
    for i in range(n):
        s += i
    return s


def main():
    print("Starting\n")
    print('while loop\t\t', timeit.timeit(while_loop, number=1))
    print('for pure\t\t', timeit.timeit(for_loop, number=1))
    print('true loop\t\t', timeit.timeit(for_loop, number=1))

    """i = 0
    for _ in iter(int, 1):
        print(i)
        i += 1"""


if __name__ == '__main__':
    try:
        main()

    except BaseException as error:
        print(f"An exception occurred: {error}")
